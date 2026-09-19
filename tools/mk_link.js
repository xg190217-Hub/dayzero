// mk_link.js — creates an ASCII junction (C:\dev\dayzero_link) pointing at
// this project directory.
//
// Why: the Dart analysis server crashes on Windows when the project path
// contains non-ASCII characters (this project lives in a Chinese-named
// folder). Running the Flutter tool through the ASCII junction works around
// that bug while keeping the project in place.
//
// Usage: node tools/mk_link.js   (run once; see tools/fj.js)
'use strict';
const fs = require('fs');
const path = require('path');

const LINK = 'C:\\dev\\dayzero_link';
const SRC = path.resolve(__dirname, '..');

try {
  const st = fs.lstatSync(LINK);
  if (st.isSymbolicLink()) {
    console.log(`junction already exists: ${LINK}`);
  } else {
    console.log(`refusing to overwrite existing path: ${LINK}`);
    process.exit(1);
  }
} catch (e) {
  fs.symlinkSync(SRC, LINK, 'junction');
  console.log(`created junction ${LINK} -> ${SRC}`);
}
