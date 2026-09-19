// scan_colors.js — hue-aware full-image color map for understanding what a
// reference image actually looks like.
//
// Usage: node tools/scan_colors.js <png> [scale]
'use strict';
const fs = require('fs');
const zlib = require('zlib');

const file = process.argv[2];
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
const ch = ct === 6 ? 4 : ct === 2 ? 3 : 3;
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

function classify(r, g, bl) {
  const mx = Math.max(r, g, bl), mn = Math.min(r, g, bl);
  const d = mx - mn;
  const lum = (r + g + bl) / 3;
  if (d < 18) {
    if (lum > 235) return 'W';
    if (lum > 195) return 'w';
    if (lum > 130) return ':';
    if (lum > 70) return '+';
    if (lum > 35) return '-';
    return '#';
  }
  // hue in degrees
  let hue;
  if (mx === r) hue = ((g - bl) / d) % 6;
  else if (mx === g) hue = (bl - r) / d + 2;
  else hue = (r - g) / d + 4;
  hue = (hue * 60 + 360) % 360;
  const sat = d / mx;
  if (lum > 150 && sat < 0.35) return 'w';
  if (hue < 15 || hue >= 345) return 'R'; // red
  if (hue < 40) return 'O'; // orange
  if (hue < 65) return 'Y'; // yellow
  if (hue < 160) return 'G'; // green
  if (hue < 200) return 'C'; // cyan
  if (hue < 250) return 'B'; // blue
  if (hue < 300) return 'P'; // purple
  if (hue < 345) return 'M'; // magenta
  return '?';
}

const S = Number(process.argv[3] || Math.max(8, Math.round(w / 100)));
console.log(`size ${w}x${h}, scale ${S}px/char, legend: W/w white, : + - # grays, R red, O orange, Y yellow, G green, C cyan, B blue, P purple, M magenta`);
for (let yy = 0; yy < h; yy += S * 2) {
  let row = '';
  for (let xx = 0; xx < w; xx += S) {
    const o = yy * stride + xx * ch;
    row += classify(img[o], img[o + 1], img[o + 2]);
  }
  console.log(String(yy).padStart(4) + ' ' + row);
}
