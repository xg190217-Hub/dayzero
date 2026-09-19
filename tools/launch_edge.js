// launch_edge.js — starts the static server if needed and opens the app in
// Microsoft Edge for local testing.
//
// Usage:
//   node tools/launch_edge.js           (starts server + opens Edge)
// Requires a built web bundle first:  node tools/fj.js build web --release
'use strict';
const { spawn, execFile } = require('child_process');
const http = require('http');
const path = require('path');

const PORT = 8090;
const URL = `http://localhost:${PORT}`;
const EDGE = 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';

function isUp() {
  return new Promise((resolve) => {
    const req = http.get(URL, { timeout: 1500 }, () => resolve(true));
    req.on('error', () => resolve(false));
    req.on('timeout', () => {
      req.destroy();
      resolve(false);
    });
  });
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

(async () => {
  if (!(await isUp())) {
    const child = spawn(
      'node',
      [path.join(__dirname, 'serve.js'), String(PORT)],
      { detached: true, stdio: 'ignore' },
    );
    child.unref();
    for (let i = 0; i < 30 && !(await isUp()); i++) await sleep(200);
    if (!(await isUp())) {
      console.error(
        'server did not come up — run `node tools/serve.js` manually; ' +
          'make sure build/web exists (run `node tools/fj.js build web --release`).',
      );
      process.exit(1);
    }
  }
  console.log(`opening ${URL} in Edge...`);
  execFile(EDGE, [URL], (err) => {
    if (err) {
      console.error('failed to open Edge:', err.message);
      process.exit(1);
    }
  });
})();
