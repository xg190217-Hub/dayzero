# DayZero — Private Quit-Habit Tracker

Quit drinking, smoking or vaping — and watch your life come back, one day at a time. DayZero is a 100% offline, privacy-first companion for the quit journey: no account, no ads, no cloud, no analytics.

## Features

- **Day counter** — every hour free counts from the moment you start
- **Money saved** — daily spend → growing savings
- **Recovery timeline** — how your body heals (per habit type)
- **Daily check-in** — mood, craving level, triggers (10 seconds)
- **Craving SOS** — 4-4-6 breathing guide with synthesized calming audio, your own reasons, 90-second distraction game
- **Milestones & streaks** — badges from 1 hour to 1 year
- **Relapse-safe** — restart the counter or keep going
- **JSON export** — your data is yours
- **12 languages** — en, zh, ja, de, fr, es, pt, ru, ko, it, ar, tr

## Business model

Free download + Premium subscription (weekly/monthly/yearly) + Lifetime unlock. Free tier: 2 habits with core stats, no ads, forever.

## Tech

Flutter single codebase (iOS + Web demo). Local SQLite storage, StoreKit 2 via `in_app_purchase`, `audioplayers`, `fl_chart`, `flutter_local_notifications`. All audio is synthesized programmatically (`tools/gen_dayzero_sounds.js`); the icon is procedurally rendered (`tools/gen_dayzero_icon.js`).

## Development

**VS Code:** double-click `DayZero.code-workspace` at the repo root to open the
project (recommended extensions: Dart & Flutter). Debug configs for Edge /
Chrome / web-server live in `.vscode/launch.json` (F5).

```bash
# First time (China mirrors):
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

flutter pub get
flutter test test/progress_logic_test.dart test/widget_test.dart   # functional tests (CI-safe)

# Web demo (Edge):
flutter build web --release --dart-define=FLUTTER_WEB_CANVASKIT_URL=/canvaskit/
node tools/serve.js          # serves build/web at http://localhost:8090
node tools/launch_edge.js    # opens Edge on the demo

# Store screenshots (local only, golden output is platform-sensitive):
GEN_SCREENSHOTS=1 node tools/fj.js test --update-goldens test/screenshots_test.dart

# Icon:
node tools/gen_dayzero_icon.js && dart run flutter_launcher_icons
```

**Windows note:** `flutter analyze` (LSP) crashes on paths with non-ASCII characters. Run `node tools/mk_link.js` once to create the ASCII junction `C:\dev\dayzero_link`, then use `node tools/fj.js analyze` instead.

## Store assets

- `store/STORE-METADATA.md` — every App Store Connect field + six-part review notes template
- `store/STORE-LOCALIZATIONS.md` — 12-language store metadata pack
- `store/privacy-policy.md` / `terms.md` / `support.md` — hosted on GitHub Pages (`xg190217-hub.github.io/dayzero/…`)
- `docs/上架清单.md` — the full submission runbook
- `test/screenshots/` — generated store screenshots (6.9" and 6.5", EN + ZH)

## CI

Codemagic (`codemagic.yaml`) — manual signing recipe verified across two previous projects. Variable group: `dayzero-app` (ASC issuer/key/api + reused certificate private key).
