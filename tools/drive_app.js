// drive_app.js — 试运行驱动器:通过 Chrome DevTools Protocol (CDP) 驱动无头
// Edge 打开应用、真实点击按钮、逐状态截图并收集控制台错误。零依赖(Node 22+
// 自带 WebSocket)。
//
// 用法:
//   1. 启动无头 Edge:
//      msedge --headless=new --remote-debugging-port=9222 \
//        --user-data-dir=C:/Users/Administrator/AppData/Local/Temp/edge_cdp about:blank
//   2. node tools/drive_app.js
//   输出: /tmp/app_open.png /tmp/app_covered.png /tmp/app_open2.png + 控制台错误
'use strict';
const fs = require('fs');
const http = require('http');

const DEBUG_PORT = 9222;
const APP_URL = 'http://localhost:8090/';
const OUT_DIR = process.env.TEMP || 'C:/Windows/Temp';
const out = (name) => `${OUT_DIR}\\${name}`;

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function getJSON(url) {
  return new Promise((resolve, reject) => {
    http
      .get(url, (res) => {
        let d = '';
        res.on('data', (c) => (d += c));
        res.on('end', () => {
          try {
            resolve(JSON.parse(d));
          } catch (e) {
            reject(e);
          }
        });
      })
      .on('error', reject);
  });
}

async function main() {
  // 1. Find the page target.
  let targets;
  for (let i = 0; i < 20; i++) {
    try {
      targets = await getJSON(`http://127.0.0.1:${DEBUG_PORT}/json`);
      break;
    } catch (e) {
      await sleep(500);
    }
  }
  if (!targets) {
    console.error('CDP not reachable — start headless Edge with --remote-debugging-port=9222 first.');
    process.exit(1);
  }
  const page = targets.find((t) => t.type === 'page');
  if (!page) {
    console.error('no page target found');
    process.exit(1);
  }

  // 2. Connect.
  const ws = new WebSocket(page.webSocketDebuggerUrl);
  const pending = new Map();
  let nextId = 1;
  const consoleErrors = [];
  let loadResolve;

  ws.onmessage = (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id !== undefined && pending.has(msg.id)) {
      const { resolve, reject } = pending.get(msg.id);
      pending.delete(msg.id);
      if (msg.error) reject(new Error(msg.error.message));
      else resolve(msg.result);
    } else if (msg.method === 'Page.loadEventFired') {
      if (loadResolve) {
        loadResolve();
        loadResolve = null;
      }
    } else if (msg.method === 'Runtime.consoleAPICalled') {
      const text = (msg.params.args || [])
        .map((a) => a.value ?? a.description ?? '')
        .join(' ');
      if (msg.params.type === 'error' || /error/i.test(text)) {
        consoleErrors.push(text);
      }
    } else if (msg.method === 'Runtime.exceptionThrown') {
      consoleErrors.push(
        msg.params.exceptionDetails?.exception?.description ||
          msg.params.exceptionDetails?.text ||
          'exception',
      );
    }
  };

  await new Promise((resolve, reject) => {
    ws.onopen = resolve;
    ws.onerror = reject;
  });
  const send = (method, params = {}) =>
    new Promise((resolve, reject) => {
      const id = nextId++;
      pending.set(id, { resolve, reject });
      ws.send(JSON.stringify({ id, method, params }));
    });

  // 3. Configure the viewport and navigate.
  await send('Page.enable');
  await send('Runtime.enable');
  await send('Emulation.setDeviceMetricsOverride', {
    width: 420,
    height: 850,
    deviceScaleFactor: 1,
    mobile: true,
  });
  const loaded = new Promise((r) => (loadResolve = r));
  await send('Page.navigate', { url: APP_URL });
  await Promise.race([loaded, sleep(15000)]);

  // 4. Wait for Flutter to mount (poll for the flutter view element).
  let mounted = false;
  for (let i = 0; i < 60 && !mounted; i++) {
    await sleep(500);
    try {
      const r = await send('Runtime.evaluate', {
        expression:
          "!!document.querySelector('flt-glass-pane, flutter-view, flt-scene-host, canvas')",
        returnByValue: true,
      });
      mounted = !!r.result?.value;
    } catch (e) {
      /* retry */
    }
  }
  if (!mounted) {
    console.error('app did not mount within 30s');
    process.exit(1);
  }
  await sleep(2000); // let the first frame settle

  const shot = async (name) => {
    const r = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync(out(name), Buffer.from(r.data, 'base64'));
    console.log('saved', out(name));
  };
  const click = async (x, y) => {
    await send('Input.dispatchMouseEvent', {
      type: 'mousePressed', x, y, button: 'left', clickCount: 1,
    });
    await send('Input.dispatchMouseEvent', {
      type: 'mouseReleased', x, y, button: 'left', clickCount: 1,
    });
    console.log(`clicked (${x},${y})`);
  };

  // 5. The trial run: initial state → 摇一摇 → covered → 开 → open again.
  await shot('app_open.png');
  await click(210, 800); // 摇一摇 button
  await sleep(2600); // four-stage shake sequence (~2.1s)
  await shot('app_covered.png');
  await click(210, 800); // 开 button
  await sleep(800); // lift animation (~0.5s)
  await shot('app_open2.png');

  console.log('console errors:', consoleErrors.length);
  for (const e of consoleErrors) console.log('  -', e.slice(0, 200));
  ws.close();
  process.exit(0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
