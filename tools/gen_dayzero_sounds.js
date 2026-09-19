// gen_dayzero_sounds.js — synthesizes DayZero's calming audio as 44.1 kHz /
// 16-bit / mono WAV files. Pure Node, no dependencies, deterministic.
// All sounds are original synthesis (no copyrighted samples).
//
// Usage: node tools/gen_dayzero_sounds.js
// Output: assets/sounds/breath_in.wav, breath_out.wav, chime.wav,
//         calm_ambient.wav
'use strict';
const fs = require('fs');
const path = require('path');

const SR = 44100;
const OUT = path.resolve(__dirname, '..', 'assets', 'sounds');

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

function writeWav(filePath, samples) {
  const n = samples.length;
  const buf = Buffer.alloc(44 + n * 2);
  buf.write('RIFF', 0);
  buf.writeUInt32LE(36 + n * 2, 4);
  buf.write('WAVE', 8);
  buf.write('fmt ', 12);
  buf.writeUInt32LE(16, 16);
  buf.writeUInt16LE(1, 20);
  buf.writeUInt16LE(1, 22);
  buf.writeUInt32LE(SR, 24);
  buf.writeUInt32LE(SR * 2, 28);
  buf.writeUInt16LE(2, 32);
  buf.writeUInt16LE(16, 34);
  buf.write('data', 36);
  buf.writeUInt32LE(n * 2, 40);
  for (let i = 0; i < n; i++) {
    const v = Math.tanh(samples[i]);
    const s = Math.max(-32768, Math.min(32767, Math.round(v * 32767)));
    buf.writeInt16LE(s, 44 + i * 2);
  }
  fs.writeFileSync(filePath, buf);
  console.log('wrote', filePath, `${(n / SR).toFixed(1)}s`);
}

// --- helpers ---------------------------------------------------------------

// Smooth attack + release envelope over the sample index.
function env(i, n, attackFrac, releaseFrac) {
  const a = Math.max(1, Math.floor(n * attackFrac));
  const r = Math.max(1, Math.floor(n * releaseFrac));
  let e = 1;
  if (i < a) e = i / a;
  else if (i > n - r) e = (n - i) / r;
  return e * e * (3 - 2 * e); // smoothstep for click-free edges
}

// One-pole lowpass (stateful, simple).
function lowpass(samples, cutoff) {
  const alpha = 1 - Math.exp(-2 * Math.PI * cutoff / SR);
  let y = 0;
  for (let i = 0; i < samples.length; i++) {
    y += alpha * (samples[i] - y);
    samples[i] = y;
  }
  return samples;
}

// --- breath_in.wav: 4s rising sine 220→330 Hz, gentle swell ---------------
(function breathIn() {
  const dur = 4.0;
  const n = Math.floor(SR * dur);
  const out = new Float64Array(n);
  let phase = 0;
  for (let i = 0; i < n; i++) {
    const t = i / n;
    const freq = 220 + 110 * Math.pow(t, 1.4);
    phase += (2 * Math.PI * freq) / SR;
    const swell = Math.pow(t, 1.5); // slow build, mirroring an inhale
    out[i] = 0.55 * swell * env(i, n, 0.08, 0.06) * Math.sin(phase);
    // faint breath overtone
    out[i] += 0.12 * swell * env(i, n, 0.08, 0.06) * Math.sin(2 * phase);
  }
  writeWav(path.join(OUT, 'breath_in.wav'), out);
})();

// --- breath_out.wav: 6s falling sine 330→196 Hz, slow decay ---------------
(function breathOut() {
  const dur = 6.0;
  const n = Math.floor(SR * dur);
  const out = new Float64Array(n);
  let phase = 0;
  for (let i = 0; i < n; i++) {
    const t = i / n;
    const freq = 330 - 134 * Math.pow(t, 1.15);
    phase += (2 * Math.PI * freq) / SR;
    const fade = Math.pow(1 - t, 0.8); // long release, like an exhale
    out[i] = 0.55 * fade * env(i, n, 0.06, 0.1) * Math.sin(phase);
    out[i] += 0.1 * fade * env(i, n, 0.06, 0.1) * Math.sin(2 * phase);
  }
  writeWav(path.join(OUT, 'breath_out.wav'), out);
})();

// --- chime.wav: 2.5s bell (C5 + E6 + G6 partials, exponential decay) ------
(function chime() {
  const dur = 2.5;
  const n = Math.floor(SR * dur);
  const out = new Float64Array(n);
  const partials = [
    { f: 523.25, a: 0.5, d: 0.35 }, // C5
    { f: 1318.5, a: 0.25, d: 0.12 }, // E6
    { f: 1568.0, a: 0.15, d: 0.08 }, // G6
  ];
  for (let i = 0; i < n; i++) {
    const t = i / SR;
    let v = 0;
    for (const p of partials) {
      v += p.a * Math.exp(-t / p.d) * Math.sin(2 * Math.PI * p.f * t);
    }
    out[i] = v * env(i, n, 0.004, 0.5);
  }
  writeWav(path.join(OUT, 'chime.wav'), out);
})();

// --- calm_ambient.wav: 24s seamless loop, filtered noise + soft pad -------
(function ambient() {
  const dur = 24.0;
  const n = Math.floor(SR * dur);
  const rand = mulberry32(42);
  const out = new Float64Array(n);

  // Lowpassed pink-ish noise: the "air".
  const noise = new Float64Array(n);
  for (let i = 0; i < n; i++) {
    noise[i] = rand() * 2 - 1;
  }
  lowpass(noise, 700);

  // Very slow pad: A2 + E3 with a 12s LFO so it breathes.
  const chord = [110.0, 164.81]; // A2, E3
  const lfoPeriod = SR * 12;
  for (let i = 0; i < n; i++) {
    const t = i / SR;
    const lfo = 0.5 + 0.5 * Math.sin((2 * Math.PI * i) / lfoPeriod);
    let pad = 0;
    for (const f of chord) {
      pad += Math.sin(2 * Math.PI * f * t);
    }
    out[i] = 0.16 * noise[i] + 0.05 * (0.4 + 0.6 * lfo) * pad;
  }

  // 3s crossfade of tail into head for a click-free loop.
  const fadeN = Math.floor(SR * 3);
  for (let i = 0; i < fadeN; i++) {
    const k = i / fadeN;
    out[i] = out[i] * k + out[n - fadeN + i] * (1 - k);
  }
  const looped = out.slice(0, n - fadeN);
  writeWav(path.join(OUT, 'calm_ambient.wav'), looped);
})();
