// gen_dayzero_icon.js — procedurally renders the 1024x1024 DayZero app icon
// as a PNG. Pure Node (zlib only), no dependencies, deterministic.
//
// Composition: deep-green vertical gradient + a gold sunrise clipped at the
// horizon + a white ring (the "zero") circling the sun. No alpha channel
// (App Store requirement; iOS applies its own mask).
//
// Usage: node tools/gen_dayzero_icon.js
// Then: dart run flutter_launcher_icons
'use strict';
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const SIZE = 1024;
const SS = 2; // supersampling factor per axis

// --- PNG encoding (RGBA in, RGB out, no alpha) ----------------------------
function crc32(buf) {
  let table = crc32.table;
  if (!table) {
    table = crc32.table = new Int32Array(256);
    for (let n = 0; n < 256; n++) {
      let c = n;
      for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
      table[n] = c;
    }
  }
  let crc = -1;
  for (let i = 0; i < buf.length; i++) crc = (crc >>> 8) ^ table[(crc ^ buf[i]) & 0xff];
  return (crc ^ -1) >>> 0;
}

function chunk(type, data) {
  const len = Buffer.alloc(4);
  len.writeUInt32BE(data.length, 0);
  const typeBuf = Buffer.from(type, 'ascii');
  const crcBuf = Buffer.alloc(4);
  crcBuf.writeUInt32BE(crc32(Buffer.concat([typeBuf, data])), 0);
  return Buffer.concat([len, typeBuf, data, crcBuf]);
}

function encodePng(width, height, rgba) {
  const sig = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr[8] = 8;
  ihdr[9] = 2; // color type RGB — no alpha
  ihdr[10] = 0;
  ihdr[11] = 0;
  ihdr[12] = 0;
  const stride = width * 3;
  const raw = Buffer.alloc((stride + 1) * height);
  for (let y = 0; y < height; y++) {
    raw[y * (stride + 1)] = 0;
    for (let x = 0; x < width; x++) {
      const src = (y * width + x) * 4;
      const dst = y * (stride + 1) + 1 + x * 3;
      raw[dst] = rgba[src];
      raw[dst + 1] = rgba[src + 1];
      raw[dst + 2] = rgba[src + 2];
    }
  }
  const idat = zlib.deflateSync(raw, { level: 9 });
  return Buffer.concat([sig, chunk('IHDR', ihdr), chunk('IDAT', idat), chunk('IEND', Buffer.alloc(0))]);
}

// --- geometry --------------------------------------------------------------
function ringSdf(x, y, cx, cy, radius, thickness) {
  return Math.abs(Math.hypot(x - cx, y - cy) - radius) - thickness / 2;
}

function circleSdf(x, y, cx, cy, r) {
  return Math.hypot(x - cx, y - cy) - r;
}

function mix(a, b, t) {
  return a + (b - a) * t;
}

// --- palette ---------------------------------------------------------------
const top = [20, 106, 79]; // #146A4F
const bottom = [11, 61, 46]; // #0B3D2E
const sunInner = [255, 214, 102]; // #FFD666
const sunOuter = [246, 177, 38]; // #F6B126
const ringColor = [255, 255, 255];
const horizonColor = [246, 244, 238]; // #F6F4EE

const W = SIZE * SS;
const rgba = Buffer.alloc(W * W * 4);

const cx = W / 2;
const horizonY = W * 0.66;
const sunCx = W / 2;
const sunCy = horizonY;
const sunR = W * 0.21;
const ringRadius = W * 0.27;
const ringThickness = W * 0.055;

for (let py = 0; py < W; py++) {
  const bgT = py / W;
  for (let px = 0; px < W; px++) {
    let r = mix(top[0], bottom[0], bgT);
    let g = mix(top[1], bottom[1], bgT);
    let b = mix(top[2], bottom[2], bgT);

    // Sun: a circle centered on the horizon, clipped above it.
    const dSun = circleSdf(px, py, sunCx, sunCy, sunR);
    if (dSun <= 0 && py <= horizonY) {
      const t = Math.min(1, Math.abs(dSun) / (sunR * 0.8));
      r = mix(sunInner[0], sunOuter[0], t);
      g = mix(sunInner[1], sunOuter[1], t);
      b = mix(sunInner[2], sunOuter[2], t);
    }

    // Horizon line: a slim cream band across the full width.
    const dBand = Math.abs(py - horizonY) - W * 0.006;
    if (dBand <= 0) {
      r = horizonColor[0];
      g = horizonColor[1];
      b = horizonColor[2];
    }

    // The white "zero" ring, centered slightly above the sun center.
    const dRing = ringSdf(px, py, cx, horizonY - W * 0.10, ringRadius, ringThickness);
    const aa = 0.75; // px of anti-aliasing (pre-supersample units)
    if (dRing <= 0) {
      const alpha = dRing < -aa ? 1 : (aa - dRing) / (2 * aa);
      r = mix(r, ringColor[0], alpha);
      g = mix(g, ringColor[1], alpha);
      b = mix(b, ringColor[2], alpha);
    }

    const idx = (py * W + px) * 4;
    rgba[idx] = r;
    rgba[idx + 1] = g;
    rgba[idx + 2] = b;
    rgba[idx + 3] = 255;
  }
}

// Downsample SS×SS → SIZE×SIZE.
const out = Buffer.alloc(SIZE * SIZE * 4);
for (let y = 0; y < SIZE; y++) {
  for (let x = 0; x < SIZE; x++) {
    let r = 0, g = 0, b = 0;
    for (let sy = 0; sy < SS; sy++) {
      for (let sx = 0; sx < SS; sx++) {
        const idx = ((y * SS + sy) * W + (x * SS + sx)) * 4;
        r += rgba[idx];
        g += rgba[idx + 1];
        b += rgba[idx + 2];
      }
    }
    const n = SS * SS;
    const dst = (y * SIZE + x) * 4;
    out[dst] = r / n;
    out[dst + 1] = g / n;
    out[dst + 2] = b / n;
    out[dst + 3] = 255;
  }
}

const outDir = path.resolve(__dirname, '..', 'assets', 'icon');
fs.mkdirSync(outDir, { recursive: true });
const outPath = path.join(outDir, 'icon_1024.png');
fs.writeFileSync(outPath, encodePng(SIZE, SIZE, out));
console.log('wrote', outPath);
