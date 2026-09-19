// gen_sounds.js — synthesizes the game sound effects as 44.1 kHz / 16-bit /
// mono WAV files. Pure Node, no dependencies, deterministic (seeded PRNG).
//
// Usage: node tools/gen_sounds.js
// Output: assets/sounds/dice_rattle.wav, assets/sounds/lid_open.wav
'use strict';
const fs = require('fs');
const path = require('path');

const SR = 44100;

// --- deterministic PRNG (mulberry32) so regeneration is reproducible ---
function mulberry32(seed) {
  let a = seed >>> 0;
  return function () {
    a |= 0;
    a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// --- WAV writer (44-byte header + Int16 PCM, soft-clipped) ---
function writeWav(filePath, samples) {
  const n = samples.length;
  const buf = Buffer.alloc(44 + n * 2);
  buf.write('RIFF', 0);
  buf.writeUInt32LE(36 + n * 2, 4);
  buf.write('WAVE', 8);
  buf.write('fmt ', 12);
  buf.writeUInt32LE(16, 16); // fmt chunk size
  buf.writeUInt16LE(1, 20); // PCM
  buf.writeUInt16LE(1, 22); // mono
  buf.writeUInt32LE(SR, 24);
  buf.writeUInt32LE(SR * 2, 28); // byte rate
  buf.writeUInt16LE(2, 32); // block align
  buf.writeUInt16LE(16, 34); // bits per sample
  buf.write('data', 36);
  buf.writeUInt32LE(n * 2, 40);
  for (let i = 0; i < n; i++) {
    const v = Math.tanh(samples[i]);
    const s = Math.max(-32768, Math.min(32767, Math.round(v * 32767)));
    buf.writeInt16LE(s, 44 + i * 2);
  }
  fs.writeFileSync(filePath, buf);
}

function peakNormalize(samples, target) {
  let peak = 0;
  for (const s of samples) peak = Math.max(peak, Math.abs(s));
  if (peak === 0) return;
  const k = target / peak;
  for (let i = 0; i < samples.length; i++) samples[i] *= k;
}

// ---------------------------------------------------------------------------
// dice_rattle.wav (~1.7 s): bright plastic dice tumbling inside the cup.
// Each clack is synthesized by FFT spectral shaping: white noise is given
// the exact magnitude curve measured from the reference recording (peak at
// 6 kHz, steep rolloff above, gentle low-end slope), modulated by 3-4 tiny
// gaussian "bounce" sub-hits within ~14 ms — the die's micro-bounces.
// Spacing and amplitude follow the reference statistics too.
// ---------------------------------------------------------------------------
function makeRattle(rng, opts = {}) {
  const dur = opts.dur ?? 1.7;
  const n = Math.floor(SR * dur);
  const out = new Float32Array(n);

  // Target clack magnitude (dB at Hz) from tools/analyze_audio.js on the
  // reference recording. curveShiftHz moves the whole curve (positive =
  // darker, features at lower frequencies).
  const specPts = [
    [0, -20], [250, -18], [500, -15], [1000, -12], [1500, -5], [2000, -8],
    [2500, -7], [3000, -3], [3500, -6], [4000, -12], [5000, -3], [6000, 0],
    [8000, -15], [10000, -31], [12000, -36],
  ];
  const FFT_N = 1024; // ~23 ms per clack
  const binHz = SR / FFT_N;
  const shift = opts.curveShiftHz ?? 0;
  const target = new Float64Array(FFT_N / 2 + 1);
  for (let b = 0; b < target.length; b++) {
    const f = b * binHz + shift;
    let dB = specPts[0][1];
    for (let i = 0; i < specPts.length - 1; i++) {
      const [f0, d0] = specPts[i];
      const [f1, d1] = specPts[i + 1];
      if (f >= f0 && f <= f1) {
        dB = d0 + (d1 - d0) * (f - f0) / (f1 - f0);
        break;
      }
      if (f > f1) dB = d1;
    }
    target[b] = Math.pow(10, dB / 20);
  }

  // Radix-2 FFT in place.
  function fft(re, im) {
    const N = re.length;
    for (let i = 1, j = 0; i < N; i++) {
      let bit = N >> 1;
      for (; j & bit; bit >>= 1) j ^= bit;
      j ^= bit;
      if (i < j) {
        let t = re[i]; re[i] = re[j]; re[j] = t;
        t = im[i]; im[i] = im[j]; im[j] = t;
      }
    }
    for (let len = 2; len <= N; len <<= 1) {
      const ang = (-2 * Math.PI) / len;
      const wr = Math.cos(ang);
      const wi = Math.sin(ang);
      for (let i = 0; i < N; i += len) {
        let cr = 1, ci = 0;
        for (let j = 0; j < len / 2; j++) {
          const ur = re[i + j], ui = im[i + j];
          const vr = re[i + j + len / 2] * cr - im[i + j + len / 2] * ci;
          const vi = re[i + j + len / 2] * ci + im[i + j + len / 2] * cr;
          re[i + j] = ur + vr; im[i + j] = ui + vi;
          re[i + j + len / 2] = ur - vr; im[i + j + len / 2] = ui - vi;
          const ncr = cr * wr - ci * wi;
          ci = cr * wi + ci * wr;
          cr = ncr;
        }
      }
    }
  }

  // Early reflections off the cup walls: delays and gains are randomized
  // per clack so the echoes scatter instead of comb-filtering the spectrum
  // (fixed delays carved 200 Hz notches into the response).

  // One knock: noise × bounce envelope → FFT → target magnitude → IFFT,
  // plus the cup's response — early reflections, a bright ringing tail,
  // and a dark low thump from the cup body.
  function addKnock(startSec, amp) {
    const re = new Float64Array(FFT_N);
    const im = new Float64Array(FFT_N);
    const subMin = opts.subMin ?? 3;
    const subMax = opts.subMax ?? 4;
    const subHits = subMin + Math.floor(rng() * (subMax - subMin + 1));
    const centerStart = opts.centerStart ?? 0.2;
    const centerSpread = opts.centerSpread ?? 12;
    const centers = [], widths = [], amps = [];
    for (let k = 0; k < subHits; k++) {
      centers.push(Math.floor(((centerStart + rng() * centerSpread) / 1000) * SR));
      widths.push(30 + rng() * 60); // 0.7-2 ms sigma
      amps.push(0.5 + rng() * 0.5);
    }
    for (let i = 0; i < FFT_N; i++) {
      let e = 0;
      for (let k = 0; k < subHits; k++) {
        const d = (i - centers[k]) / widths[k];
        e += amps[k] * Math.exp(-d * d);
      }
      re[i] = (rng() * 2 - 1) * e;
    }
    fft(re, im);
    for (let b = 0; b <= FFT_N / 2; b++) {
      const m = target[b];
      re[b] *= m; im[b] *= m;
      if (b > 0 && b < FFT_N / 2) {
        re[FFT_N - b] *= m; im[FFT_N - b] *= m;
      }
    }
    for (let i = 0; i < FFT_N; i++) im[i] = -im[i];
    fft(re, im);
    const start = Math.floor(startSec * SR);
    // Scattered reflections: 7 echoes with random delays (3-35 ms),
    // gains decaying with delay and random sign, per clack.
    const nEchoes = 7;
    const echoes = [];
    for (let k = 0; k < nEchoes; k++) {
      const dMs = 3 + rng() * 32;
      echoes.push([dMs, 0.35 * Math.exp(-dMs / 20) * (rng() < 0.5 ? 1 : -1)]);
    }
    for (let i = 0; i < FFT_N; i++) {
      const idx = start + i;
      if (idx >= n) break;
      const v = amp * re[i] * (30 / FFT_N);
      out[idx] += v;
      for (const [dMs, g] of echoes) {
        const j = idx + Math.floor((dMs / 1000) * SR);
        if (j < n) out[j] += v * g;
      }
    }

    // Cup ringing tail: low-dominant decaying noise after each hit
    // (120 ms, ~1.8 kHz and below, matching the reference's measured
    // tail spectrum which peaks around 250 Hz). Dense clacks overlap
    // these tails into the "哗啦" wash — no constant noise bed.
    const tailLen = Math.floor(0.12 * SR);
    let t1 = 0, t2 = 0;
    for (let i = 0; i < tailLen; i++) {
      const idx = start + i;
      if (idx >= n) break;
      const t = i / SR;
      const noise = rng() * 2 - 1;
      t1 = t1 + 0.3 * (noise - t1);
      t2 = t2 + 0.3 * (t1 - t2);
      out[idx] += amp * 0.12 * Math.exp(-t / 0.025) * t2;
    }

    // Cup body thump: dark low knock (30 ms, ~500 Hz and below).
    const lowLen = Math.floor(0.03 * SR);
    let lp = 0;
    for (let i = 0; i < lowLen; i++) {
      const idx = start + i;
      if (idx >= n) break;
      const t = i / SR;
      const noise = rng() * 2 - 1;
      lp = lp + 0.08 * (noise - lp);
      out[idx] += amp * 0.5 * Math.exp(-t / 0.008) * lp;
    }
  }

  // Rolling: dense, fairly regular clacks, following the reference
  // amplitude curve.
  const spacingMin = opts.spacingMin ?? 0.03;
  const spacingMax = opts.spacingMax ?? 0.07;
  const ampJitter = opts.ampJitter ?? 0.3;
  const decay = opts.decay ?? 1.6;
  let t = 0.02;
  while (t < dur - 0.18) {
    const amp = envelope(t, decay) * (0.85 + rng() * ampJitter);
    addKnock(t, amp);
    t += spacingMin + rng() * spacingMax;
  }

  // 8 ms attack on every sample so no knock pops at t=0.
  for (let i = 0; i < n; i++) {
    const tSec = i / SR;
    if (tSec < 0.008) out[i] *= tSec / 0.008;
  }

  peakNormalize(out, 0.92);
  return out;
}

/// Reference-modelled amplitude curve: nearly silent start, quick build to
/// the peak around 0.28 s, then an exponential decay that keeps energy
/// through the middle and fades at the end.
function envelope(t, decay = 1.6) {
  if (t < 0.12) return 0.06;
  if (t < 0.28) return 0.06 + 0.94 * ((t - 0.12) / 0.16);
  return Math.exp(-(t - 0.28) * decay);
}

// ---------------------------------------------------------------------------
// lid_open.wav (~0.3 s): one crisp wood knock as the lid separates — a fast
// bright noise attack plus a wood tone at ~450-550 Hz with a 2.2x partial.
// ---------------------------------------------------------------------------
function makeLidOpen(rng) {
  const dur = 0.3;
  const n = Math.floor(SR * dur);
  const out = new Float32Array(n);

  // One wood knock: crisp bright attack + damped wood tone.
  function addWoodKnock(startSec, amp, freq) {
    const start = Math.floor(startSec * SR);

    // 1) Crisp attack: 2.5 ms bright noise burst (the "t" of the knock).
    {
      const len = Math.floor(0.0025 * SR);
      let lp = 0;
      for (let i = 0; i < len; i++) {
        const noise = rng() * 2 - 1;
        lp = lp + 0.5 * (noise - lp);
        out[start + i] += amp * 0.8 * Math.exp(-i / SR / 0.0008) * (noise - lp);
      }
    }

    // 2) Wood tone: damped sine at the knock frequency plus a lighter
    //    2.2x partial — the hollow "叩" body of two wooden pieces meeting.
    {
      const len = Math.floor(0.06 * SR);
      let phase = 0;
      let phase2 = 0;
      for (let i = 0; i < len; i++) {
        const t = i / SR;
        phase += (2 * Math.PI * freq) / SR;
        phase2 += (2 * Math.PI * freq * 2.2) / SR;
        out[start + i] +=
          amp *
          (0.65 * Math.exp(-t / 0.022) * Math.sin(phase) +
            0.25 * Math.exp(-t / 0.010) * Math.sin(phase2));
      }
    }
  }

  // One clean knock as the lid separates.
  addWoodKnock(0.005, 0.9, 480 + rng() * 100);

  peakNormalize(out, 0.85);
  return out;
}

// ---------------------------------------------------------------------------
// dice_click.wav (~40 ms): one pure "ding" for the dice-count stepper
// buttons — a single damped 2.8-3.2 kHz sine, no noise attack, no tail.
// ---------------------------------------------------------------------------
function makeClick(rng) {
  const dur = 0.04;
  const n = Math.floor(SR * dur);
  const out = new Float32Array(n);

  const freq = 2800 + rng() * 400;
  let phase = 0;
  for (let i = 0; i < n; i++) {
    const t = i / SR;
    phase += (2 * Math.PI * freq) / SR;
    out[i] = Math.exp(-t / 0.008) * Math.sin(phase);
  }

  peakNormalize(out, 0.8);
  return out;
}

// ---------------------------------------------------------------------------
module.exports = { makeRattle, makeLidOpen, makeClick, writeWav, mulberry32, SR };

if (require.main === module) {
  const outDir = path.join(__dirname, '..', 'assets', 'sounds');
  fs.mkdirSync(outDir, { recursive: true });

  // The shipped rattle is the "dense & long" variant chosen by ear:
  // 2.3 s, tighter clack spacing, slightly slower decay.
  const rattle = makeRattle(mulberry32(20240824), {
    dur: 2.3,
    spacingMin: 0.02,
    spacingMax: 0.05,
    decay: 1.9,
  });
  const lidOpen = makeLidOpen(mulberry32(20240825));
  const click = makeClick(mulberry32(20240919));
  writeWav(path.join(outDir, 'dice_rattle.wav'), rattle);
  writeWav(path.join(outDir, 'lid_open.wav'), lidOpen);
  writeWav(path.join(outDir, 'dice_click.wav'), click);

  const rattlePath = path.join(outDir, 'dice_rattle.wav');
  const lidPath = path.join(outDir, 'lid_open.wav');
  const clickPath = path.join(outDir, 'dice_click.wav');
  console.log(`dice_rattle.wav  ${(fs.statSync(rattlePath).size / 1024).toFixed(1)} KB  ${rattle.length / SR}s`);
  console.log(`lid_open.wav     ${(fs.statSync(lidPath).size / 1024).toFixed(1)} KB  ${lidOpen.length / SR}s`);
  console.log(`dice_click.wav   ${(fs.statSync(clickPath).size / 1024).toFixed(1)} KB  ${click.length / SR}s`);
}
