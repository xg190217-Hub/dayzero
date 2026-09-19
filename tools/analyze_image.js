// analyze_image.js — decodes a PNG and prints its color palette + an ASCII
// layout map. Used to study reference images without viewing them directly.
//
// Usage: node tools/analyze_image.js <path-to-png> [ascii-scale]
'use strict';
const fs = require('fs');
const zlib = require('zlib');

const file = process.argv[2];
if (!file) {
  console.error('usage: node tools/analyze_image.js <png> [scale]');
  process.exit(1);
}

const b = fs.readFileSync(file);
let i = 8, idat = [], w = 0, h = 0, ct = 0, bd = 0;
while (i < b.length) {
  const len = b.readUInt32BE(i);
  const t = b.slice(i + 4, i + 8).toString();
  if (t === 'IHDR') {
    w = b.readUInt32BE(i + 8);
    h = b.readUInt32BE(i + 12);
    bd = b[i + 16];
    ct = b[i + 17];
  }
  if (t === 'IDAT') idat.push(b.slice(i + 8, i + 8 + len));
  i += 12 + len;
}
const raw = zlib.inflateSync(Buffer.concat(idat));
const ch = ct === 6 ? 4 : ct === 2 ? 3 : ct === 0 ? 1 : 3;
const stride = w * ch;
const img = Buffer.alloc(h * stride);
// Bytes per pixel: the left-neighbor reference for Sub/Average/Paeth filters.
const bpp = ch * (bd / 8);

function paeth(a, c, d) {
  const p = a + c - d;
  const pa = Math.abs(p - a), pb = Math.abs(p - c), pc = Math.abs(p - d);
  return pa <= pb && pa <= pc ? a : pb <= pc ? c : d;
}
for (let y = 0; y < h; y++) {
  const f = raw[y * (stride + 1)];
  const line = raw.slice(y * (stride + 1) + 1, y * (stride + 1) + 1 + stride);
  for (let x = 0; x < stride; x++) {
    const a = x >= bpp ? img[y * stride + x - bpp] : 0;
    const up = y > 0 ? img[(y - 1) * stride + x] : 0;
    const ul = (y > 0 && x >= bpp) ? img[(y - 1) * stride + x - bpp] : 0;
    let v = line[x];
    if (f === 1) v = (v + a) & 255;
    else if (f === 2) v = (v + up) & 255;
    else if (f === 3) v = (v + ((a + up) >> 1)) & 255;
    else if (f === 4) v = (v + paeth(a, up, ul)) & 255;
    img[y * stride + x] = v;
  }
}
const px = (x, y) => {
  const o = y * stride + x * ch;
  return [img[o], img[o + 1], img[o + 2]];
};

console.log(`size: ${w}x${h}  bitDepth=${bd} colorType=${ct}`);

// --- palette: quantize to 32-level buckets, count, top 25 ---
const counts = new Map();
const step = Math.max(1, Math.floor((w * h) / 60000));
for (let y = 0; y < h; y += step) {
  for (let x = 0; x < w; x += step) {
    const [r, g, bl] = px(x, y);
    const key = `${r >> 3},${g >> 3},${bl >> 3}`;
    counts.set(key, (counts.get(key) || 0) + 1);
  }
}
console.log('\ntop colors (RGB approx, % of sampled pixels):');
const sorted = [...counts.entries()].sort((a, b) => b[1] - a[1]).slice(0, 22);
for (const [k, v] of sorted) {
  const [r, g, bl] = k.split(',').map((n) => (Number(n) << 3) + 4);
  console.log(
    `  rgb(${r},${g},${bl})  ${((v / (w * h / step / step)) * 100).toFixed(1)}%`,
  );
}

// --- point sampler: third arg = "x,y;x,y;..." ---
if (process.argv[4]) {
  console.log('\nsampled points:');
  for (const pt of process.argv[4].split(';')) {
    const [x, y] = pt.split(',').map(Number);
    const [r, g, bl] = px(x, y);
    console.log(`  (${x},${y})  rgb(${r},${g},${bl})  #${[r, g, bl].map((v) => v.toString(16).padStart(2, '0')).join('')}`);
  }
  process.exit(0);
}

// --- ASCII layout map ---
const S = Number(process.argv[3] || Math.max(6, Math.round(w / 110)));
console.log(`\nlayout map (scale ${S}px/char):`);
for (let yy = 0; yy < h; yy += S * 2) {
  let row = '';
  for (let xx = 0; xx < w; xx += S) {
    const [r, g, bl] = px(xx, yy);
    let c = '.';
    const lum = 0.299 * r + 0.587 * g + 0.114 * bl;
    if (r > 200 && g > 170 && bl < 120) c = 'G';          // gold/yellow
    else if (r > 180 && g > 180 && bl > 180) c = 'W';      // white
    else if (r < 45 && g < 45 && bl < 45) c = '#';         // black
    else if (r > 90 && g > 45 && g < 130 && bl < 70) c = 'w'; // wood brown
    else if (r > 150 && g < 90 && bl < 90) c = 'R';        // red
    else if (r < 80 && g > 60 && g < 140 && bl < 90) c = 'g'; // green
    else if (lum > 150) c = ':';                            // light gray
    else if (lum > 80) c = '+';                             // mid gray
    else c = '-';                                           // dark
    row += c;
  }
  console.log(String(yy).padStart(4) + ' ' + row);
}
