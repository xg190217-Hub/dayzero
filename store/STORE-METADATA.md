# DayZero — App Store Connect 表单数据（提审当天照抄）

> 所有字段一次填完（清单驱动，不靠苹果报错驱动——前两个项目的血泪教训）。

## 基本信息

| 字段 | 值 |
|---|---|
| 名称（主语言，≤30字符） | `DayZero: Quit Drinking Tracker` |
| 副标题（≤30字符） | `Sober Day Counter & Habits` |
| 中国区名称 | `归零: 戒酒戒烟打卡` |
| Bundle ID | `io.dayzero.app` |
| SKU | `dayzero` |
| 主分类 / 次分类 | Health & Fitness / Lifestyle |
| 版权 | `© 2026 DayZero` |
| 年龄分级 | 12+（含酒精/烟草相关内容的引用） |
| 上架地区 | 除中国大陆外的全部（中国大陆等 ICP 豁免批复后再开） |
| 定价 | 免费（含 IAP） |

## 年龄分级问卷答案（2026 版）

- 全部选「无 / 否」——除了：「吸烟、电子烟或烟草使用」→ **偶尔/轻度**；「酒精、毒品或药物滥用」→ **偶尔/轻度**（App 内容为戒断支持，非美化滥用）
- 结果应为 **12+**

## 关键词（≤100 字符，含逗号）

```
quit,drinking,sober,smoking,vaping,stop,addiction,counter,days,since,streak,habit,tracker
```

## 描述（英文版，其余 11 语言见 STORE-LOCALIZATIONS.md）

```
Quit drinking, smoking or vaping — and watch your life come back, one day at a time.

DayZero is the private companion for your quit journey. No account, no ads, no cloud: everything you track stays on your device. 100% offline.

• DAY COUNTER — see every hour and day you've been free, from the moment you start.
• MONEY SAVED — set what the habit cost you per day and watch the savings grow.
• RECOVERY TIMELINE — see how your body heals over time (blood pressure, lungs, liver, sleep…).
• DAILY CHECK-IN — 10 seconds: mood, craving level and triggers. Trends appear within days.
• CRAVING SOS — a guided 4-4-6 breathing exercise with calming audio, your own reasons, and a 90-second distraction game to ride out the urge.
• MILESTONES — celebrate 1 hour, 1 day, 1 week, 1 month… and the money milestones along the way.
• RELAPSE-SAFE — one slip doesn't erase your progress. Restart the counter or keep going — your choice.
• EXPORT — your data is yours: export it as JSON anytime.

WHY DAYZERO
• 100% private: no account, no analytics, no tracking. Your data never leaves your device.
• Works offline, forever.
• 12 languages, one honest price. Free tier tracks 2 habits with core stats — no ads, ever. Premium unlocks unlimited habits, full charts, the complete breathing audio library and more.

DayZero provides motivation and tracking only — it is not medical advice. For severe withdrawal, please consult a doctor.

Privacy policy: https://xg190217-hub.github.io/dayzero/privacy
Terms of use: https://xg190217-hub.github.io/dayzero/terms
```

## IAP 产品（4 个，创建后不可改）

| 产品 ID | 类型 | 组 | 价格（人民币基准，全球自动换算） |
|---|---|---|---|
| `dayzero_weekly` | 自动续订订阅 | DayZero Premium | ¥18 |
| `dayzero_monthly` | 自动续订订阅 | DayZero Premium | ¥45 |
| `dayzero_yearly` | 自动续订订阅 | DayZero Premium | ¥268 |
| `dayzero_lifetime` | 非消耗型 | （无组） | ¥598 |

每个订阅产品必配 6 项（前两个项目被卡的根因）：
1. 审核信息截图（用 `test/screenshots/6.9_en/06_paywall.png`）
2. 供应情况：全选
3. 价格规则校验：年付 ≤ 月付×12（268 ≤ 45×12=540 ✓）；周付×52 ≥ 年付×1.5（18×52=936 ≥ 402 ✓）
4. 本地化显示名 + 描述（≤55 字符）
5. 订阅组：三档同组 "DayZero Premium"（订阅组也要本地化）
6. 付费 App 协议已同意（账号级，两项目前已激活）

## 审核信息（App Review Information）六段式备注模板

```
1. Screen recording: [网盘永久链接] — full flow on a real iPhone from app icon tap: onboarding, adding a habit, check-in, SOS breathing, stats, paywall and a sandbox purchase.

2. Purpose: DayZero is a private quit-habit tracker (alcohol, smoking, vaping, sugar, caffeine, social media, custom). It counts sober days, tracks money saved, shows recovery timelines, and helps users ride out cravings with breathing exercises. Everything is stored on device; the app works fully offline.

3. Test steps (no login required — the app has no account system):
   a. Launch → onboarding → pick "Alcohol" → Start my journey.
   b. Home shows the day counter and money saved.
   c. Tap "Check in today" → pick a mood → Save.
   d. Tap "Craving SOS" → breathing exercise + distraction game.
   e. Bottom tabs: Your progress (weekly charts), Milestones (badges).
   f. Settings → DayZero Premium → paywall with 4 tiers.

4. External services: none. 100% offline, no network calls except Apple StoreKit. No analytics, no ads, no tracking. App Privacy label: Data Not Collected.

5. Regional differences: none. UI is localized in 12 languages.

6. Regulated industry / protected content: N/A. Alcohol/tobacco references are quit-support content only, not promotion of use.

In-app purchases: the paywall is at Settings → DayZero Premium (also reachable from Stats). Product IDs: dayzero_weekly / dayzero_monthly / dayzero_yearly (subscriptions, group "DayZero Premium") and dayzero_lifetime (non-consumable). Free tier: 2 habits with core stats. Premium: unlimited habits, full charts, full audio library, themes. Restore Purchases is on the paywall and in Settings. Sandbox account: available on request.
```

## 隐私营养标签（App Privacy）

- **Data Not Collected**（全部三类：不收集、不用于追踪、不关联）
- 与隐私政策一致：App 内无账号、无 SDK、无网络请求（StoreKit 除外）

## 提审前自查清单（提交当天过一遍）

- [ ] 隐私政策 / 条款 / 支持页已托管且 curl 可达，无占位符
- [ ] 付费墙截图已上传到全部 4 个 IAP 产品的审核信息
- [ ] 订阅组本地化完成
- [ ] 年龄分级问卷完成（12+）
- [ ] 出口合规：`ITSAppUsesNonExemptEncryption=false`（代码里已配置）
- [ ] 版权字段 `© 2026 DayZero`
- [ ] 联系信息电话带 +86 国家码
- [ ] 真机录屏已录好（从点图标开始，含付费墙与沙盒购买）并传网盘拿永久链接
- [ ] 截图 6.9"（1320×2868）×6 张已上传（test/screenshots/6.9_en/）
- [ ] TestFlight 内部测试：真机全流程走一遍
