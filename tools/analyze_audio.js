// analyze_audio.js — decodes an mp3 in headless Edge via Web Audio and
// reports the characteristics (duration, rhythm, brightness bands, decay)
// needed to synthesize an original sound in the same style.
//
// Usage: node tools/analyze_audio.js <path-to.mp3>
// Requires headless Edge with CDP on port 9223 (started automatically).
'use strict';
const fs = require('fs');
const http = require('http');
const { spawn } = require('child_process');

const DEBUG_PORT = 9223;
const EDGE = 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

const mp3Path = process.argv[2];
if (!mp3Path || !fs.existsSync(mp3Path)) {
  console.error('usage: node tools/analyze_audio.js <path-to.mp3>');
  process.exit(1);
}

function getJSON(url) {
  return new Promise((resolve, reject) => {
    http
      .get(url, (res) => {
        let d = '';
        res.on('data', (c) => (d += c));
        res.on('end', () => {
          try { resolve(JSON.parse(d)); } catch (e) { reject(e); }
        });
      })
      .on('error', reject);
  });
}

async function main() {
  // 1. Make sure headless Edge with CDP is running.
  let up = false;
  try { await getJSON(`http://127.0.0.1:${DEBUG_PORT}/json`); up = true; } catch (e) {}
  if (!up) {
    spawn(EDGE, [
      '--headless=new', `--remote-debugging-port=${DEBUG_PORT}`,
      '--user-data-dir=C:/Users/Administrator/AppData/Local/Temp/edge_audio_cdp',
      '--no-first-run', 'about:blank',
    ], { stdio: 'ignore', detached: true }).unref();
    for (let i = 0; i < 30; i++) {
      await sleep(500);
      try { await getJSON(`http://127.0.0.1:${DEBUG_PORT}/json`); up = true; break; } catch (e) {}
    }
  }
  if (!up) { console.error('could not start CDP Edge'); process.exit(1); }

  const targets = await getJSON(`http://127.0.0.1:${DEBUG_PORT}/json`);
  const page = targets.find((t) => t.type === 'page');

  const ws = new WebSocket(page.webSocketDebuggerUrl);
  const pending = new Map();
  let nextId = 1;
  ws.onmessage = (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id !== undefined && pending.has(msg.id)) {
      const { resolve, reject } = pending.get(msg.id);
      pending.delete(msg.id);
      if (msg.error) reject(new Error(msg.error.message));
      else resolve(msg.result);
    }
  };
  await new Promise((resolve, reject) => { ws.onopen = resolve; ws.onerror = reject; });
  const send = (method, params = {}) =>
    new Promise((resolve, reject) => {
      const id = nextId++;
      pending.set(id, { resolve, reject });
      ws.send(JSON.stringify({ id, method, params }));
    });
  await send('Runtime.enable');

  // 2. Decode the mp3 with Web Audio, return the PCM as base64.
  const b64 = fs.readFileSync(mp3Path).toString('base64');
  const expr = `(async () => {
    const b64 = '${b64}';
    const bin = atob(b64);
    const bytes = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
    const ctx = new OfflineAudioContext(1, 1, 44100);
    const buf = await ctx.decodeAudioData(bytes.buffer);
    const ch = buf.getChannelData(0);
    const out = new Uint8Array(ch.length * 2);
    const dv = new DataView(out.buffer);
    for (let i = 0; i < ch.length; i++) {
      dv.setInt16(i * 2, Math.max(-32768, Math.min(32767, Math.round(ch[i] * 32767))), true);
    }
    // Re-encode as base64 in chunks to stay under string limits.
    let s = '';
    for (let i = 0; i < out.length; i += 32768) {
      s += String.fromCharCode.apply(null, out.subarray(i, i + 32768));
    }
    return { sr: buf.sampleRate, dur: buf.duration, pcmB64: btoa(s) };
  })()`;
  const res = await send('Runtime.evaluate', {
    expression: expr, awaitPromise: true, returnByValue: true,
  });
  if (res.exceptionDetails) {
    console.error('decode failed:', res.exceptionDetails.exception?.description || res.exceptionDetails.text);
    process.exit(1);
  }
  const { sr, dur, pcmB64 } = res.result.value;
  const pcm = Buffer.from(pcmB64, 'base64');
  const n = pcm.length / 2;
  const samples = new Float32Array(n);
  for (let i = 0; i < n; i++) samples[i] = pcm.readInt16LE(i * 2) / 32768;
  console.log(`decoded: ${dur.toFixed(2)}s @ ${sr}Hz, ${n} samples`);

  // 3. Analysis.
  // 3a. Envelope: RMS per 10 ms window; find impact peaks.
  const win = Math.floor(sr * 0.01);
  const env = [];
  for (let i = 0; i < n; i += win) {
    let s = 0;
    const end = Math.min(i + win, n);
    for (let j = i; j < end; j++) s += samples[j] * samples[j];
    env.push(Math.sqrt(s / (end - i)));
  }
  const envMax = Math.max(...env);
  const peakIdx = [];
  for (let i = 2; i < env.length - 2; i++) {
    if (env[i] > 0.25 * envMax &&
        env[i] >= env[i - 1] && env[i] >= env[i - 2] &&
        env[i] > env[i + 1] && env[i] > env[i + 2]) {
      peakIdx.push(i);
    }
  }
  const gaps = [];
  for (let i = 1; i < peakIdx.length; i++) gaps.push((peakIdx[i] - peakIdx[i - 1]) * 0.01);
  const med = (a) => a.length ? a.sort((x, y) => x - y)[Math.floor(a.length / 2)] : 0;
  console.log(`impacts: ${peakIdx.length}, median gap ${med(gaps).toFixed(3)}s, min ${Math.min(...gaps).toFixed(3)}s, max ${Math.max(...gaps).toFixed(3)}s`);

  // 3b. Decay: mean envelope per 10% time slice, relative to max.
  const slices = [];
  for (let s = 0; s < 10; s++) {
    const a = Math.floor(env.length * s / 10);
    const b = Math.floor(env.length * (s + 1) / 10);
    let sum = 0;
    for (let i = a; i < b; i++) sum += env[i];
    slices.push(sum / (b - a) / envMax);
  }
  console.log('envelope by 10% slices: ' + slices.map((x) => x.toFixed(2)).join(' '));

  // 3c. Brightness: band energies in dB per octave-ish bands, averaged over
  // the whole signal (DFT on 40 ms frames, 50% overlap).
  const frame = Math.floor(sr * 0.04);
  const hop = frame / 2;
  const bands = [[0, 250], [250, 800], [800, 2500], [2500, 8000]];
  const bandSum = [0, 0, 0, 0];
  let frames = 0;
  for (let start = 0; start + frame <= n; start += hop) {
    frames++;
    for (let bi = 0; bi < bands.length; bi++) {
      const [f0, f1] = bands[bi];
      let energy = 0;
      const kMin = Math.max(1, Math.floor(f0 * frame / sr));
      const kMax = Math.min(frame / 2 - 1, Math.floor(f1 * frame / sr));
      for (let k = kMin; k <= kMax; k++) {
        let re = 0, im = 0;
        for (let j = 0; j < frame; j++) {
          const x = samples[start + j];
          const ang = (2 * Math.PI * k * j) / frame;
          re += x * Math.cos(ang);
          im -= x * Math.sin(ang);
        }
        energy += re * re + im * im;
      }
      bandSum[bi] += energy;
    }
  }
  const dB = (e) => (10 * Math.log10(e / frames + 1e-12)).toFixed(1);
  console.log('band dB (avg/frame): <250Hz ' + dB(bandSum[0]) +
    ', 250-800 ' + dB(bandSum[1]) +
    ', 800-2.5k ' + dB(bandSum[2]) +
    ', 2.5k-8k ' + dB(bandSum[3]));

  // 3d. Clack anatomy: average the loudest clacks. For each detected peak,
  // take a 40 ms segment, align on the peak, and compute (a) the average
  // waveform decay and (b) the average magnitude spectrum.
  const segLen = Math.floor(sr * 0.04);
  const segs = [];
  for (const pi of peakIdx) {
    const center = pi * win;
    const a = center - Math.floor(segLen / 4);
    if (a < 0 || a + segLen > n) continue;
    const seg = samples.slice(a, a + segLen);
    segs.push(seg);
  }
  if (segs.length > 0) {
    // Decay: mean |amplitude| envelope across aligned segments.
    const avgEnv = new Float32Array(segLen);
    for (const seg of segs) {
      for (let i = 0; i < segLen; i++) avgEnv[i] += Math.abs(seg[i]) / segs.length;
    }
    const peak = Math.max(...avgEnv);
    const decays = [];
    for (let ms = 2; ms <= 14; ms++) {
      const idx = Math.floor(ms / 1000 * sr);
      if (avgEnv[idx] > peak * 0.05) decays.push(ms);
    }
    const envStr = [1, 2, 3, 4, 5, 7, 9, 12, 16, 20, 30, 40, 60, 80, 100]
      .map((ms) => (avgEnv[Math.floor(ms / 1000 * sr)] / peak).toFixed(2))
      .join(' ');
    console.log('clack envelope (rel @1/2/3/4/5/7/9/12/16/20/30/40/60/80/100ms): ' + envStr);

    // Mean magnitude spectrum of the clack segments (dB rel. to max bin).
    const freqs = [500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 5000, 6000, 8000, 10000, 12000];
    const mag = new Array(freqs.length).fill(0);
    for (const seg of segs) {
      for (let fi = 0; fi < freqs.length; fi++) {
        const f = freqs[fi];
        const w = (2 * Math.PI * f) / sr;
        let re = 0, im = 0;
        for (let j = 0; j < segLen; j++) {
          re += seg[j] * Math.cos(w * j);
          im -= seg[j] * Math.sin(w * j);
        }
        mag[fi] += Math.sqrt(re * re + im * im) / segs.length;
      }
    }
    const magMax = Math.max(...mag);
    console.log('clack spectrum (dB rel peak): ' +
      freqs.map((f, i) => `${(f / 1000).toFixed(1)}k:${(20 * Math.log10(mag[i] / magMax + 1e-9)).toFixed(0)}`).join(' '));
  }

  // 3e. Rolling bed: spectrum of the quietest windows (between clacks),
  // where only the dice-rubbing wash remains. Level relative to clack peak.
  const winMs = 20;
  const wLen = Math.floor(sr * winMs / 1000);
  const quietWindows = [];
  let minWinE = Infinity;
  for (let i = 0; i + wLen <= n; i += wLen) {
    let e = 0;
    for (let j = i; j < i + wLen; j++) e += samples[j] * samples[j];
    e /= wLen;
    minWinE = Math.min(minWinE, e);
    quietWindows.push({ i, e });
  }
  quietWindows.sort((a, b) => a.e - b.e);
  const bedWins = quietWindows.slice(0, Math.max(4, Math.floor(quietWindows.length * 0.15)));
  const bedFreqs = [250, 500, 1000, 1500, 2000, 3000, 4000, 6000, 8000];
  const bedMag = new Array(bedFreqs.length).fill(0);
  for (const wnd of bedWins) {
    for (let fi = 0; fi < bedFreqs.length; fi++) {
      const f = bedFreqs[fi];
      const w = (2 * Math.PI * f) / sr;
      let re = 0, im = 0;
      for (let j = 0; j < wLen; j++) {
        re += samples[wnd.i + j] * Math.cos(w * j);
        im -= samples[wnd.i + j] * Math.sin(w * j);
      }
      bedMag[fi] += Math.sqrt(re * re + im * im) / bedWins.length;
    }
  }
  const bedMax = Math.max(...bedMag);
  const clackRms = Math.sqrt(peakIdx.reduce((s, pi) => {
    const a = pi * win, b = Math.min(a + win, n);
    let e = 0;
    for (let j = a; j < b; j++) e += samples[j] * samples[j];
    return s + e / (b - a);
  }, 0) / peakIdx.length);
  const bedRms = Math.sqrt(minWinE);
  console.log('bed spectrum (dB rel bed peak): ' +
    bedFreqs.map((f, i) => `${(f / 1000).toFixed(2)}k:${(20 * Math.log10(bedMag[i] / bedMax + 1e-9)).toFixed(0)}`).join(' '));
  console.log(`bed level vs clack RMS: ${(20 * Math.log10(bedRms / clackRms + 1e-9)).toFixed(1)} dB`);
  process.exit(0);
}

main().catch((e) => { console.error(e); process.exit(1); });
