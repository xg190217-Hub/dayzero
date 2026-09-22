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

// --- parametric breathing tones: one per (name, duration, direction) ------
function breathTone(name, dur, rise) {
  const n = Math.floor(SR * dur);
  const out = new Float64Array(n);
  let phase = 0;
  for (let i = 0; i < n; i++) {
    const t = i / n;
    const freq = rise ? 220 + 110 * Math.pow(t, 1.4) : 330 - 134 * Math.pow(t, 1.15);
    phase += (2 * Math.PI * freq) / SR;
    const shape = rise ? Math.pow(t, 1.5) : Math.pow(1 - t, 0.8);
    out[i] = 0.55 * shape * env(i, n, 0.08, 0.06) * Math.sin(phase);
    out[i] += 0.12 * shape * env(i, n, 0.08, 0.06) * Math.sin(2 * phase);
  }
  writeWav(path.join(OUT, name), out);
}

// 4-4-6 pattern (default): 4s in, 6s out
breathTone('breath_in.wav', 4.0, true);
breathTone('breath_out.wav', 6.0, false);
// 4-7-8 pattern: 4s in (shared), 8s out
breathTone('breath_out_8.wav', 8.0, false);
// 5-5 pattern: 5s in, 5s out
breathTone('breath_in_5.wav', 5.0, true);
breathTone('breath_out_5.wav', 5.0, false);
// 4-4-4 box pattern: 4s in (shared), 4s out
breathTone('breath_out_4.wav', 4.0, false);

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

// --- calm_ambient.wav: 12s loop, seamless BY CONSTRUCTION ---------------
// Every component is periodic over 12s (pad LFOs divide 12, arpeggio is
// 4 steps x 3s). v4's loop point fell mid-cycle (21s loop vs 12s pattern)
// and the phase jump read as noise. A full 12s buffer of periodic content
// loops mathematically clean.
(function ambient() {
  const P = 12.0; // the loop period
  const n = Math.floor(SR * P);
  const rand = mulberry32(42);
  const out = new Float64Array(n);

  // Whisper of dark air (cutoff 300 Hz, level 0.015).
  const noise = new Float64Array(n);
  for (let i = 0; i < n; i++) {
    noise[i] = rand() * 2 - 1;
  }
  lowpass(noise, 300);

  // Warm pad: pure sines with swells whose periods divide 12.
  const padVoices = [
    { f: 110.0, a: 0.10, period: 4.0 },   // A2
    { f: 164.81, a: 0.07, period: 6.0 },  // E3
    { f: 220.0, a: 0.06, period: 12.0 },  // A3
  ];
  // Music-box arpeggio: A3 C#4 E4 A4, one pluck every 3s (4 steps = 12s).
  const arp = [220.0, 277.18, 329.63, 440.0];
  for (let i = 0; i < n; i++) {
    const t = i / SR;
    let v = 0.015 * noise[i];
    for (const p of padVoices) {
      const lfo = 0.5 + 0.5 * Math.sin((2 * Math.PI * t) / p.period);
      const swell = 0.5 + 0.5 * lfo;
      v += p.a * swell * Math.sin(2 * Math.PI * p.f * t);
    }
    const step = Math.floor(t / 3.0) % 4;
    const since = t - Math.floor(t / 3.0) * 3.0;
    const f = arp[step];
    const pluck = Math.exp(-since / 0.9) * Math.sin(2 * Math.PI * f * since);
    const overtone = 0.25 * Math.exp(-since / 0.4) *
        Math.sin(2 * Math.PI * f * 2.0 * since);
    const pluckEnv = since < 0.02 ? since / 0.02 : 1;
    v += 0.16 * pluckEnv * (pluck + overtone);
    out[i] = v;
  }

  // Periodic content: the whole buffer IS one clean loop (12s = exactly
  // 4 arpeggio steps and integer LFO cycles).
  writeWav(path.join(OUT, 'calm_ambient.wav'), out);
})();

// --- rain.wav: 16s loop — steady bright drizzle, no swells (ocean owns
// the rhythm): a fine constant patter + sparse resonant droplets.
(function rain() {
  const dur = 16.0;
  const n = Math.floor(SR * dur);
  const rand = mulberry32(7);
  const out = new Float64Array(n);

  // Bright mist: higher cutoff than the ocean rumble (1200 Hz vs 400),
  // steady level (rain does not swell).
  const mist = new Float64Array(n);
  for (let i = 0; i < n; i++) mist[i] = rand() * 2 - 1;
  lowpass(mist, 1200);
  for (let i = 0; i < n; i++) out[i] = 0.07 * mist[i];

  // Fine continuous patter: dense tiny ticks, like steady drizzle.
  for (let i = 0; i < n; i++) {
    if (rand() < 0.0016) {
      out[i] += (0.05 + rand() * 0.08) * (rand() * 2 - 1);
    }
  }

  // Sparse resonant droplet pings (the water-drop character).
  const pings = Math.floor(dur * 5);
  for (let p = 0; p < pings; p++) {
    const at = Math.floor(rand() * (n - 4000));
    const f = 1000 + rand() * 1000;
    const len = Math.floor(SR * (0.015 + rand() * 0.02));
    let phase = 0;
    for (let i = 0; i < len; i++) {
      phase += (2 * Math.PI * f) / SR;
      const decay = Math.exp(-i / (len * 0.3));
      out[at + i] += 0.16 * decay * Math.sin(phase);
    }
  }
  // Occasional deeper drip.
  const drips = Math.floor(dur / 4.0);
  for (let d = 0; d < drips; d++) {
    const at = Math.floor(rand() * (n - 8000));
    const f = 420 + rand() * 160;
    const len = Math.floor(SR * 0.08);
    let phase = 0;
    for (let i = 0; i < len; i++) {
      phase += (2 * Math.PI * f) / SR;
      const decay = Math.exp(-i / (len * 0.25));
      out[at + i] += 0.17 * decay * Math.sin(phase) +
          0.06 * decay * Math.sin(2.3 * phase);
    }
  }
  const fadeN = Math.floor(SR * 2);
  for (let i = 0; i < fadeN; i++) {
    const k = i / fadeN;
    out[i] = out[i] * k + out[n - fadeN + i] * (1 - k);
  }
  writeWav(path.join(OUT, 'rain.wav'), out.slice(0, n - fadeN));
})();

// --- ocean.wav: 20s seamless loop — three overlapping swells ---------------
(function ocean() {
  const dur = 20.0;
  const n = Math.floor(SR * dur);
  const rand = mulberry32(11);
  const out = new Float64Array(n);

  // Distant surf bed.
  const bed = new Float64Array(n);
  for (let i = 0; i < n; i++) bed[i] = rand() * 2 - 1;
  lowpass(bed, 420);
  for (let i = 0; i < n; i++) out[i] = 0.07 * bed[i];

  // Three wave layers, each a swell: slow build, soft crash, recede.
  const periods = [8.0, 6.4, 9.6];
  const offsets = [0.0, 2.6, 4.9];
  for (let w = 0; w < 3; w++) {
    const burst = new Float64Array(n);
    for (let i = 0; i < n; i++) burst[i] = rand() * 2 - 1;
    lowpass(burst, 650);
    const T = SR * periods[w];
    const off = SR * offsets[w];
    for (let i = 0; i < n; i++) {
      const ph = ((i + off) % T) / T; // 0..1 within this wave's cycle
      // Envelope: quiet lull (0-0.55), building swell (0.55-0.82),
      // crash + recede (0.82-1).
      let e = 0.05;
      if (ph < 0.55) e = 0.05 + 0.10 * (ph / 0.55);
      else if (ph < 0.82) e = 0.15 + 0.85 * ((ph - 0.55) / 0.27);
      else e = 1.0 * Math.exp(-(ph - 0.82) / 0.10);
      out[i] += 0.30 * e * burst[i];
    }
  }
  const fadeN = Math.floor(SR * 2);
  for (let i = 0; i < fadeN; i++) {
    const k = i / fadeN;
    out[i] = out[i] * k + out[n - fadeN + i] * (1 - k);
  }
  writeWav(path.join(OUT, 'ocean.wav'), out.slice(0, n - fadeN));
})();

// --- campfire.wav: 20s loop — low rumble + random crackles and pops -------
(function campfire() {
  const dur = 20.0;
  const n = Math.floor(SR * dur);
  const rand = mulberry32(31);
  const out = new Float64Array(n);

  // Warm low rumble.
  const rumble = new Float64Array(n);
  for (let i = 0; i < n; i++) rumble[i] = rand() * 2 - 1;
  lowpass(rumble, 140);
  for (let i = 0; i < n; i++) {
    const t = i / SR;
    const flicker = 0.8 + 0.2 * Math.sin((2 * Math.PI * t) / 5.3);
    out[i] = 0.22 * flicker * rumble[i];
  }
  // Crackle: dense, sharp, irregular transients (the wood-fire snap).
  // A continuous sizzle bed (tiny high-rate ticks) plus clustered snaps.
  for (let i = 0; i < n; i++) {
    if (rand() < 0.004) {
      const amp = 0.05 + rand() * 0.1;
      out[i] += amp * (rand() * 2 - 1);
    }
  }
  const snaps = 260;
  for (let c = 0; c < snaps; c++) {
    const at = Math.floor(rand() * (n - 300));
    const len = 2 + Math.floor(rand() * 7);
    const amp = 0.15 + rand() * 0.55;
    for (let i = 0; i < len; i++) {
      out[at + i] += amp * Math.exp(-i / 1.6) * (rand() * 2 - 1);
    }
  }
  // Real pops: sharp attack, slower decay, louder.
  const pops = 12;
  for (let p = 0; p < pops; p++) {
    const at = Math.floor(rand() * (n - 800));
    const len = 14 + Math.floor(rand() * 46);
    const amp = 0.65 + rand() * 0.35;
    for (let i = 0; i < len; i++) {
      out[at + i] += amp * Math.exp(-i / 5) * (rand() * 2 - 1);
    }
  }
  const fadeN = Math.floor(SR * 2);
  for (let i = 0; i < fadeN; i++) {
    const k = i / fadeN;
    out[i] = out[i] * k + out[n - fadeN + i] * (1 - k);
  }
  writeWav(path.join(OUT, 'campfire.wav'), out.slice(0, n - fadeN));
})();
