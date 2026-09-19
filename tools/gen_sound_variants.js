// gen_sound_variants.js — generates 4 rattle variants with different
// characters and a comparison page (build/web/snd/ + build/web/compare.html)
// served by tools/serve.js at http://localhost:8090/compare.html.
//
// Usage: node tools/gen_sound_variants.js
'use strict';
const fs = require('fs');
const path = require('path');
const { makeRattle, writeWav, mulberry32 } = require('./gen_sounds.js');

const root = path.join(__dirname, '..');
const outDir = path.join(root, 'build', 'web', 'snd');
fs.mkdirSync(outDir, { recursive: true });

const variants = {
  A: { label: 'A · 当前版(频谱对齐参考)', opts: {} },
  B: { label: 'B · 更低沉厚实', opts: { curveShiftHz: 1200, decay: 1.4, subMin: 3, subMax: 5 } },
  C: { label: 'C · 更密更长', opts: { dur: 2.3, spacingMin: 0.02, spacingMax: 0.05, decay: 1.9 } },
  D: { label: 'D · 弹跳更明显', opts: { subMin: 4, subMax: 6, centerSpread: 16, spacingMin: 0.035, spacingMax: 0.09, decay: 1.5 } },
};

for (const [key, v] of Object.entries(variants)) {
  const wav = makeRattle(mulberry32(20240903), v.opts);
  writeWav(path.join(outDir, `rattle_${key}.wav`), wav);
  console.log(`rattle_${key}.wav  ${(wav.length / 44100).toFixed(2)}s`);
}

// Copy the reference mp3 (comparison only — never ships in the app).
const refSrc = path.join(root, '摇骰子的声音.mp3');
if (fs.existsSync(refSrc)) {
  fs.copyFileSync(refSrc, path.join(outDir, 'reference.mp3'));
  console.log('reference.mp3 copied');
}

// Comparison page.
const rows = Object.entries(variants)
  .map(
    ([key, v]) => `
    <div class="row">
      <audio id="a_${key}" src="snd/rattle_${key}.wav"></audio>
      <button onclick="play('a_${key}')">▶ 播放</button>
      <span>${v.label}</span>
    </div>`
  )
  .join('\n');

const html = `<!DOCTYPE html>
<html lang="zh"><head><meta charset="UTF-8"><title>摇骰音效对比</title>
<style>
body{font-family:sans-serif;background:#111;color:#eee;max-width:560px;margin:40px auto;padding:0 20px}
h1{font-size:20px} .row{margin:14px 0;display:flex;align-items:center;gap:14px}
button{background:#2a7a4f;color:#fff;border:0;border-radius:6px;padding:10px 18px;cursor:pointer;font-size:15px}
button:hover{background:#359a63}
.ref{border:1px solid #555;padding:10px;border-radius:8px;margin-bottom:24px}
.note{color:#aaa;font-size:13px}
</style></head><body>
<h1>摇骰音效对比试听</h1>
<p class="note">先听"参考原声",再听 A~D,选出最接近的一个,告诉我字母即可。参考原声仅用于对比,不会进入 App。</p>
<div class="ref">
  <audio id="ref" src="snd/reference.mp3"></audio>
  <button onclick="play('ref')">▶ 播放</button> <b>参考原声</b>
</div>
${rows}
<script>function play(id){const a=document.getElementById(id);a.currentTime=0;a.play();}</script>
</body></html>`;

fs.writeFileSync(path.join(root, 'build', 'web', 'compare.html'), html);
console.log('compare.html written → http://localhost:8090/compare.html');
