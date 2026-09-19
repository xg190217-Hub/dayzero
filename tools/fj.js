// fj.js — "flutter via junction": runs the Flutter tool with the working
// directory set to the ASCII junction of this project (see tools/mk_link.js
// for why). Call it exactly like `flutter`:
//
//   node tools/fj.js analyze
//   node tools/fj.js test
//   node tools/fj.js build web --release
//
// Run `node tools/mk_link.js` once before using this.
'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');

const LINK = 'C:\\dev\\dayzero_link';
const FLUTTER = 'C:\\flutter\\bin\\flutter.bat';

if (!fs.existsSync(LINK)) {
  console.error('junction missing — run `node tools/mk_link.js` first.');
  process.exit(1);
}

const args = process.argv.slice(2);
// Spawn cmd.exe directly with an argv array: Node quotes each argument
// properly, so args containing spaces or cmd metacharacters (>, &, |)
// survive intact — shell:true would re-parse them.
const r = spawnSync('cmd.exe', ['/c', FLUTTER, ...args], {
  cwd: LINK,
  encoding: 'utf8',
  maxBuffer: 64 * 1024 * 1024,
});
if (r.stdout) process.stdout.write(r.stdout);
if (r.stderr) process.stderr.write(r.stderr);
process.exit(r.status === null ? 1 : r.status);
