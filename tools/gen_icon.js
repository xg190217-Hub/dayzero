// gen_icon.js — procedurally renders the 1024x1024 app icon as a PNG.
// Pure Node (zlib only), no dependencies, deterministic.
//
// Composition: green felt gradient + cream dice cup with a dark-green lid
// and three tumbling dice (red/white/green) above it. No alpha channel
// (App Store requirement; iOS applies its own mask).
//
// Usage: node tools/gen_icon.js
// Output: assets/icon/icon_1024.png
// Then: dart run flutter_launcher_icons
'use strict';
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const SIZE = 1024;
const SS = 2; // supersampling factor per axis

// ---------------------------------------------------------------------------
// PNG encoding (RGBA, 8-bit, no interlace)
// ---------------------------------------------------------------------------
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
  ihdr[8] = 8; // bit depth
  ihdr[9] = 2; // color type RGB — no alpha channel (App Store rejects alpha)
  ihdr[10] = 0;
  ihdr[11] = 0;
  ihdr[12] = 0;
  const stride = width * 3;
  const raw = Buffer.alloc((stride + 1) * height);
  for (let y = 0; y < height; y++) {
    raw[y * (stride + 1)] = 0; // filter: none
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

// ---------------------------------------------------------------------------
// Geometry helpers
// ---------------------------------------------------------------------------
function roundedRectSdf(px, py, cx, cy, w, h, r) {
  const dx = Math.abs(px - cx) - (w / 2 - r);
  const dy = Math.abs(py - cy) - (h / 2 - r);
  const ax = Math.max(dx, 0);
  const ay = Math.max(dy, 0);
  return Math.hypot(ax, ay) + Math.min(Math.max(dx, dy), 0) - r;
}

function ellipseSdf(px, py, cx, cy, rx, ry) {
  const nx = (px - cx) / rx;
  const ny = (py - cy) / ry;
  return (Math.hypot(nx, ny) - 1) * Math.min(rx, ry);
}

function circleSdf(px, py, cx, cy, r) {
  return Math.hypot(px - cx, py - cy) - r;
}

function rot(px, py, cx, cy, ang) {
  const dx = px - cx;
  const dy = py - cy;
  const c = Math.cos(ang);
  const s = Math.sin(ang);
  return [cx + dx * c - dy * s, cy + dx * s + dy * c];
}

// Blend `fg` (an [r,g,b] triple) over `bg` with coverage in [0,1]
// (coverage = 1 - smoothstep applied to the sdf).
function mixColor(bg, fg, coverage) {
  if (coverage <= 0) return bg;
  if (coverage >= 1) return fg;
  return [
    bg[0] + (fg[0] - bg[0]) * coverage,
    bg[1] + (fg[1] - bg[1]) * coverage,
    bg[2] + (fg[2] - bg[2]) * coverage,
  ];
}

// ---------------------------------------------------------------------------
// Scene
// ---------------------------------------------------------------------------
// Background: vertical gradient + soft radial glow behind the subject.
function bgColor(x, y) {
  const t = y / SIZE;
  let c = [
    14 + (10 - 14) * t, 138 + (92 - 138) * t, 92 + (62 - 92) * t,
  ];
  const dx = x - 512;
  const dy = y - 420;
  const glow = Math.exp(-(dx * dx + dy * dy) / (2 * 330 * 330)) * 0.30;
  c = mixColor(c, [20, 148, 96], glow);
  return c;
}

// The layered shapes, back to front. Each returns the color at a sample
// point or null if the sample is outside (antialiased on the boundary).
const CUP = [246, 239, 226]; // cream bowl
const CUP_DARK = [233, 222, 199];
const RIM = [237, 227, 204];
const INTERIOR = [46, 36, 27];
const LID = [11, 79, 54];
const LID_HI = [18, 107, 73];
const LID_EDGE = [8, 58, 40];
const KNOB = [246, 239, 226];
const OUTLINE = [58, 50, 38];
const RED = [226, 59, 59];
const RED_EDGE = [176, 42, 42];
const WHITE = [250, 250, 247];
const WHITE_EDGE = [216, 213, 204];
const GREEN = [18, 126, 84];
const GREEN_EDGE = [12, 92, 61];
const PIP_DARK = [31, 31, 31];
const PIP_LIGHT = [255, 255, 255];

const DICE = [
  { cx: 300, cy: 240, ang: 15, face: RED, edge: RED_EDGE, pips: PIP_LIGHT, value: 5 },
  { cx: 512, cy: 185, ang: -8, face: WHITE, edge: WHITE_EDGE, pips: PIP_DARK, value: 3 },
  { cx: 724, cy: 240, ang: 12, face: GREEN, edge: GREEN_EDGE, pips: PIP_LIGHT, value: 6 },
];

// Pip offsets (local die coords, die half-size 75).
const PIP_OFFSETS = {
  3: [[-37.5, -37.5], [0, 0], [37.5, 37.5]],
  5: [[-37.5, -37.5], [37.5, -37.5], [0, 0], [-37.5, 37.5], [37.5, 37.5]],
  6: [[-37.5, -37.5], [37.5, -37.5], [-37.5, 0], [37.5, 0], [-37.5, 37.5], [37.5, 37.5]],
};

// Returns {color, cov} for the die at local sample (lx, ly), or null if the
// sample is outside the die's antialiased edge.
function dieColor(d, lx, ly) {
  const half = 75;
  const r = 22;
  const cov = (sdf) => 1 - Math.min(1, Math.max(0, sdf / 1.5 + 0.5));

  const edgeCov = cov(roundedRectSdf(lx, ly, 0, 0, half * 2 + 10, half * 2 + 10, r + 5));
  if (edgeCov <= 0) return null;

  let c = d.edge; // border color as the base
  c = mixColor(c, d.face, cov(roundedRectSdf(lx, ly, 0, 0, half * 2, half * 2, r)));
  for (const [ox, oy] of PIP_OFFSETS[d.value]) {
    c = mixColor(c, d.pips, cov(circleSdf(lx, ly, ox, oy, 12)));
  }
  return { color: c, cov: edgeCov };
}

// The full scene at one sample point.
function sceneColor(x, y) {
  let c = bgColor(x, y);

  // Soft shadow under the cup.
  const shadowCov = 1 - Math.min(1, Math.max(0, ellipseSdf(x, y, 512, 935, 260, 34) / 14 + 0.5));
  c = mixColor(c, [0, 40, 26], shadowCov * 0.30);

  // Foot.
  let cov = 1 - Math.min(1, Math.max(0, roundedRectSdf(x, y, 512, 890, 420, 76, 36) / 1.5 + 0.5));
  if (cov > 0) c = mixColor(c, CUP_DARK, cov);

  // Bowl body.
  cov = 1 - Math.min(1, Math.max(0, roundedRectSdf(x, y, 512, 640, 560, 440, 120) / 1.5 + 0.5));
  if (cov > 0) {
    c = mixColor(c, CUP, cov);
    // Outline.
    const out = 1 - Math.min(1, Math.max(0, Math.abs(roundedRectSdf(x, y, 512, 640, 560, 440, 120) + 6) / 1.5 - 0.5));
    c = mixColor(c, OUTLINE, Math.max(0, out - 0.4) * cov);
  }

  // Rim band.
  cov = 1 - Math.min(1, Math.max(0, roundedRectSdf(x, y, 512, 430, 600, 86, 40) / 1.5 + 0.5));
  if (cov > 0) c = mixColor(c, RIM, cov);

  // Interior opening (peeks around the lid).
  cov = 1 - Math.min(1, Math.max(0, ellipseSdf(x, y, 512, 428, 268, 58) / 1.5 + 0.5));
  if (cov > 0) c = mixColor(c, INTERIOR, cov);

  // Lid disc.
  cov = 1 - Math.min(1, Math.max(0, ellipseSdf(x, y, 512, 398, 262, 82) / 1.5 + 0.5));
  if (cov > 0) {
    c = mixColor(c, LID, cov);
    const out = 1 - Math.min(1, Math.max(0, Math.abs(ellipseSdf(x, y, 512, 398, 262, 82) + 6) / 1.5 - 0.5));
    c = mixColor(c, LID_EDGE, Math.max(0, out - 0.4) * cov);
  }

  // Lid highlight.
  cov = 1 - Math.min(1, Math.max(0, ellipseSdf(x, y, 470, 366, 170, 42) / 1.5 + 0.5));
  if (cov > 0) c = mixColor(c, LID_HI, cov);

  // Knob.
  cov = 1 - Math.min(1, Math.max(0, circleSdf(x, y, 512, 330, 40) / 1.5 + 0.5));
  if (cov > 0) {
    c = mixColor(c, KNOB, cov);
    const out = 1 - Math.min(1, Math.max(0, Math.abs(circleSdf(x, y, 512, 330, 40) + 5) / 1.5 - 0.5));
    c = mixColor(c, OUTLINE, Math.max(0, out - 0.4) * cov);
  }

  // Tumbling dice.
  for (const d of DICE) {
    const [lx, ly] = rot(x, y, d.cx, d.cy, (-d.ang * Math.PI) / 180);
    const res = dieColor(d, lx - d.cx, ly - d.cy);
    if (res !== null) c = mixColor(c, res.color, res.cov);
  }

  return c;
}

// ---------------------------------------------------------------------------
const rgba = Buffer.alloc(SIZE * SIZE * 4);
for (let y = 0; y < SIZE; y++) {
  for (let x = 0; x < SIZE; x++) {
    let r = 0;
    let g = 0;
    let b = 0;
    for (let sy = 0; sy < SS; sy++) {
      for (let sx = 0; sx < SS; sx++) {
        const c = sceneColor(x + (sx + 0.5) / SS, y + (sy + 0.5) / SS);
        r += c[0];
        g += c[1];
        b += c[2];
      }
    }
    const n = SS * SS;
    const idx = (y * SIZE + x) * 4;
    rgba[idx] = Math.round(r / n);
    rgba[idx + 1] = Math.round(g / n);
    rgba[idx + 2] = Math.round(b / n);
    rgba[idx + 3] = 255; // opaque: App Store rejects alpha
  }
}

const outDir = path.join(__dirname, '..', 'assets', 'icon');
fs.mkdirSync(outDir, { recursive: true });
const outPath = path.join(outDir, 'icon_1024.png');
fs.writeFileSync(outPath, encodePng(SIZE, SIZE, rgba));
console.log(`wrote ${outPath} (${(fs.statSync(outPath).size / 1024).toFixed(1)} KB)`);
