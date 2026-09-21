// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'あなた専用のやめるためのパートナー';

  @override
  String get onboardingWelcomeTitle => '新しいスタートは今日から';

  @override
  String get onboardingWelcomeBody =>
      'やめたい習慣への挑戦を、プライベートに記録。アカウント不要・広告なし・クラウドなし。データはすべて端末の中だけ。';

  @override
  String get onboardingChooseTitle => '何をやめたいですか？';

  @override
  String get onboardingChooseBody => '一つ以上選べます。あとから追加もできます。';

  @override
  String get onboardingDateTitle => 'やめる日はいつですか？';

  @override
  String get onboardingDateBody =>
      '今日からでも、未来の日付でも。今日始める場合は「スタート」を押した瞬間からカウントします。';

  @override
  String get onboardingSpendTitle => '1日いくら使っていましたか？';

  @override
  String get onboardingSpendBody => '任意です。節約できた金額の計算に使います。あとから変更できます。';

  @override
  String get perDay => '1日あたり';

  @override
  String get currencyPlaceholder => '金額';

  @override
  String get onboardingReasonsTitle => 'なぜやめたいのですか？';

  @override
  String get onboardingReasonsBody => '理由を書いてください。欲求が来たときに表示します。';

  @override
  String get reasonPlaceholder => '例：家族のために…';

  @override
  String get addReason => '理由を追加';

  @override
  String get startJourney => '旅を始める';

  @override
  String get skip => 'スキップ';

  @override
  String get notMedicalAdvice =>
      'DayZeroはモチベーションと記録のサポートのみを提供し、医療アドバイスではありません。強い離脱症状がある場合は医師に相談してください。';

  @override
  String get habit_alcohol => 'お酒';

  @override
  String get habit_smoking => 'タバコ';

  @override
  String get habit_vaping => '電子タバコ';

  @override
  String get habit_sugar => '砂糖';

  @override
  String get habit_caffeine => 'カフェイン';

  @override
  String get habit_social => 'SNS';

  @override
  String get habit_custom => '自分で決める習慣';

  @override
  String get customHabitName => '習慣の名前は？';

  @override
  String get homeDaysSince => '日フリー';

  @override
  String get homeDaysSinceOne => '日フリー';

  @override
  String get homeTimeFree => 'フリー';

  @override
  String homeHoursFree(Object hours, Object minutes) {
    return '自由になって $hours時間 $minutes分';
  }

  @override
  String homeDayN(Object n) {
    return '$n日目';
  }

  @override
  String get timerBrokenHint => '今チェックインしてゼロから再スタート';

  @override
  String get timerBroken => '途切れています';

  @override
  String get timerNotStarted => 'チェックインするとタイマーが始まります';

  @override
  String get secondUnit => '秒';

  @override
  String get homeMoneySaved => '節約';

  @override
  String get homeCheckIn => '今日のチェックイン';

  @override
  String get homeSOS => '欲求SOS';

  @override
  String get homeHealthTimeline => '回復タイムライン';

  @override
  String get homeNextMilestone => '次のマイルストーン';

  @override
  String get homeIn => 'あと';

  @override
  String get homeRelapse => '失敗してしまった';

  @override
  String get homeAddHabit => '習慣を追加';

  @override
  String get checkinTitle => '毎日のチェックイン';

  @override
  String get checkinMood => '今日の気分は？';

  @override
  String get checkinCraving => '欲求の強さ';

  @override
  String get checkinTrigger => '一番のきっかけは？';

  @override
  String get trigger_none => '特にない';

  @override
  String get trigger_stress => 'ストレス';

  @override
  String get trigger_social => '人付き合い';

  @override
  String get trigger_boredom => '退屈';

  @override
  String get trigger_habit_loop => '昔の習慣の流れ';

  @override
  String get trigger_negative => '気分の落ち込み';

  @override
  String get trigger_celebration => 'お祝いの場';

  @override
  String get checkinNote => 'メモ（任意）';

  @override
  String get checkinDone => '保存しました——また明日';

  @override
  String get checkinEditLabel => '今日のチェックインを編集';

  @override
  String get sosTitle => '欲求SOS';

  @override
  String get sosBody => '欲求は数分でピークを迎え、やがて消えていきます。あなたなら乗り越えられます。';

  @override
  String get sosBreathing => 'いっしょに呼吸しましょう';

  @override
  String get sosBreatheIn => '吸って';

  @override
  String get sosBreatheOut => '吐いて';

  @override
  String get sosHold => '止めて';

  @override
  String get sosReasons => '始めた理由を思い出して';

  @override
  String get sosDistract => '90秒の気そらし';

  @override
  String get sosDistractBody => '動く的を10回タップ';

  @override
  String get sosTapsLeft => '残り';

  @override
  String get sosDone => '乗り越えました。欲求は去っていきました。';

  @override
  String get sosAgain => 'もう一度';

  @override
  String get audioUnavailable => 'この端末では音声を利用できません';

  @override
  String get chooseAtLeastOne => '習慣を1つ以上選んでください';

  @override
  String get dailyAmountLabel => '1日にどれくらい？（本数など）';

  @override
  String homeStreak(Object days) {
    return '連続$days日';
  }

  @override
  String get rateLater => 'あとで';

  @override
  String get statsView7 => '7日ビュー';

  @override
  String get sosAmbient => '環境音';

  @override
  String premiumSaveAmount(Object amount) {
    return '$amountお得';
  }

  @override
  String get surfingStep3 => 'ピークを過ぎれば、やがて引いていく。あなたはここにいる。';

  @override
  String get surfingStep2 => '波のように高まるのを眺めて。戦わず、裁かず。';

  @override
  String get surfingStep1 => '体のどこに欲求を感じるか探してみて。ただ気づくだけでいい。';

  @override
  String get surfingTitle => '波に乗る';

  @override
  String identityLine(Object days, Object identity) {
    return 'あなたは$identity、$days日目';
  }

  @override
  String get identity_social => 'SNSから離れた人';

  @override
  String get identity_caffeine => 'カフェインを断った人';

  @override
  String get identity_sugar => '砂糖を断った人';

  @override
  String get identity_vaping => '電子タバコを吸わない人';

  @override
  String get identity_alcohol => '飲酒しない人';

  @override
  String get identity_smoking => '非喫煙者';

  @override
  String get relapseRecordRestart => '失敗を記録してカウンターを再スタート';

  @override
  String get relapseRecordKeep => '失敗を記録して続ける';

  @override
  String onboardingStep(Object step, Object total) {
    return '$step/$total ステップ';
  }

  @override
  String get plansAction => 'わたしは…する';

  @override
  String get plansWhen => '…のとき';

  @override
  String get plansAdd => 'プランを追加';

  @override
  String get plansEmpty => '危ない瞬間にどうするか、あらかじめ書いておきましょう——必要なときに表示します';

  @override
  String get plansTitle => 'わたしの対処プラン';

  @override
  String insightNoCompare(Object now) {
    return '今週の平均欲求：$now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return '今週の平均欲求 $now/5（先週 $prev/5）——毎日続けること自体が大切です';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return '今週の平均欲求 $now/5（先週 $prev/5）——改善しています';
  }

  @override
  String get textAuto => '自動';

  @override
  String get theme_violet => 'バイオレット';

  @override
  String get theme_sunset => 'サンセット';

  @override
  String get theme_rose => 'ローズ';

  @override
  String get theme_ocean => 'オーシャン';

  @override
  String get theme_forest => 'フォレスト';

  @override
  String get theme_sage => 'セージ';

  @override
  String get theme_custom => 'カスタム';

  @override
  String get settingsTextColor => '文字の色';

  @override
  String get settingsFont => 'フォント';

  @override
  String get settingsThemes => 'テーマ';

  @override
  String get statsView30 => '30日ビュー';

  @override
  String get premiumFreeTrial => '7日間無料トライアル';

  @override
  String get deleteAllConfirm => 'すべての習慣と履歴を削除しますか？この操作は元に戻せません。';

  @override
  String get rateAction => 'App Storeで評価する';

  @override
  String get rateBody => '評価していただくと、同じように支えを必要とする人に届きます。';

  @override
  String get rateTitle => 'DayZeroを気に入っていますか？';

  @override
  String settingsNotificationsTime(Object hour) {
    return '毎日 $hour時00分にやさしくお知らせ';
  }

  @override
  String get notifBody => '今日はどうでしたか？10秒のチェックインで連続記録を守りましょう。';

  @override
  String get checkinOfferSos => '欲求が強そうですね。今すぐSOSを使いますか？';

  @override
  String get settingsReasons => 'わたしの理由';

  @override
  String get statsTitle => 'あなたの進歩';

  @override
  String get statsMood => '気分';

  @override
  String get statsCraving => '欲求の強さ';

  @override
  String get statsWeek => '今週';

  @override
  String get statsMonth => '今月';

  @override
  String get statsAll => '全期間';

  @override
  String get statsCheckins => '回のチェックイン';

  @override
  String get statsStreak => '日連続チェックイン';

  @override
  String get statsBestStreak => '最長記録';

  @override
  String get statsTotalFree => '累計フリー日数';

  @override
  String get statsWeeklyReport => '週間レポート';

  @override
  String get statsNoData => 'まだデータが足りません。毎日チェックインすると傾向が見えます。';

  @override
  String get milestonesTitle => 'マイルストーン';

  @override
  String get milestonesUnlocked => '達成済み';

  @override
  String get milestonesLocked => 'これから';

  @override
  String get milestone_1h => '最初の1時間';

  @override
  String get milestone_1d => '最初の1日';

  @override
  String get milestone_3d => '3日';

  @override
  String get milestone_1w => '1週間';

  @override
  String get milestone_2w => '2週間';

  @override
  String get milestone_1m => '1か月';

  @override
  String get milestone_3m => '3か月';

  @override
  String get milestone_6m => '6か月';

  @override
  String get milestone_1y => '1年';

  @override
  String get milestone_streak7 => 'チェックイン7日連続';

  @override
  String get milestone_streak30 => 'チェックイン30日連続';

  @override
  String get milestone_money1 => '最初の100節約';

  @override
  String get milestone_money2 => '1,000節約';

  @override
  String get milestone_money3 => '10,000節約';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsHabits => 'わたしの習慣';

  @override
  String get settingsEditHabit => '編集';

  @override
  String get settingsDeleteHabit => '削除';

  @override
  String get settingsNotifications => '毎日のチェックインリマインダー';

  @override
  String get settingsNotificationsDesc => '毎晩20時にやさしくお知らせ';

  @override
  String get settingsExport => 'データを書き出す';

  @override
  String get settingsExportDesc => '全データのJSONバックアップをファイルに保存';

  @override
  String get settingsPremium => 'DayZeroプレミアム';

  @override
  String get settingsPremiumActive => 'プレミアム有効——インディーアプリへのご支援ありがとうございます';

  @override
  String get settingsRestore => '購入を復元';

  @override
  String get settingsPrivacy => 'プライバシーポリシー';

  @override
  String get settingsTerms => '利用規約';

  @override
  String get settingsSupport => 'サポート';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsAbout => 'このアプリについて';

  @override
  String get settingsAboutBody =>
      'DayZeroはインディー開発者が作っています。100%オフライン——データが端末の外に出ることはありません。';

  @override
  String get settingsReset => 'やめた日をリセット';

  @override
  String get settingsRelapseReset => 'カウンターを再スタート';

  @override
  String get settingsDeleteData => 'すべてのデータを削除';

  @override
  String get deleteHabitConfirm => 'この習慣とすべての履歴を削除しますか？';

  @override
  String get relapseTitle => '失敗してしまいましたか？';

  @override
  String get relapseBody =>
      '一度の失敗がこれまでの進歩を消すわけではありません。カウンターを再スタートするか、欲求だけ記録して続けるかを選べます。';

  @override
  String get relapseRestart => 'カウンターを再スタート';

  @override
  String get relapseKeep => '続ける';

  @override
  String get premiumTitle => 'DayZeroプレミアム';

  @override
  String get premiumSubtitle => '自由でいるために必要なすべて';

  @override
  String get premiumFeature1 => '無制限の習慣';

  @override
  String get premiumFeature2 => '呼吸音声ライブラリ全種';

  @override
  String get premiumFeature3 => 'テーマ・フォント・文字色';

  @override
  String get premiumFeature4 => 'マイルストーンお祝いセレモニー';

  @override
  String get premiumFreeNote => '無料版は2つの習慣をコア統計付きでずっと使えます。広告もありません。';

  @override
  String get premiumWeekly => '週間';

  @override
  String get premiumMonthly => '月間';

  @override
  String get premiumYearly => '年間';

  @override
  String get premiumLifetime => '買い切り';

  @override
  String get premiumBestValue => '一番お得';

  @override
  String get premiumPerWeek => '/週';

  @override
  String get premiumPerMonth => '/月';

  @override
  String get premiumPerYear => '/年';

  @override
  String get premiumOnce => '一度きり';

  @override
  String get premiumSubscribe => '続ける';

  @override
  String get premiumRestore => '購入を復元';

  @override
  String get premiumAutoRenew =>
      'サブスクリプションは自動更新され、Apple ID設定からいつでも解除できます。解除は現在の期間終了の24時間前までに行ってください。';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return '続行すると$termsと$privacyに同意したことになります。';
  }

  @override
  String get termsLink => '利用規約';

  @override
  String get privacyLink => 'プライバシーポリシー';

  @override
  String get buying => '処理中…';

  @override
  String get buyError => '購入に失敗しました。もう一度お試しください。';

  @override
  String get restoreDone => '購入を復元しました';

  @override
  String get restoreNothing => '復元できる購入が見つかりませんでした';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get save => '保存';

  @override
  String get done => '完了';

  @override
  String get close => '閉じる';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get demoMode => 'Webデモモード——テスト用にプレミアムを解放中';

  @override
  String get exportDone => '書き出しを保存しました';

  @override
  String get language_en => 'English';

  @override
  String get language_zh => '简体中文';

  @override
  String get language_ja => '日本語';

  @override
  String get language_de => 'Deutsch';

  @override
  String get language_fr => 'Français';

  @override
  String get language_es => 'Español';

  @override
  String get language_pt => 'Português';

  @override
  String get language_ru => 'Русский';

  @override
  String get language_ko => '한국어';

  @override
  String get language_it => 'Italiano';

  @override
  String get language_ar => 'العربية';

  @override
  String get language_tr => 'Türkçe';

  @override
  String get language_system => 'システムに合わせる';

  @override
  String get health_smoking_20m => '血圧と心拍数が正常に戻り始めます';

  @override
  String get health_smoking_8h => '血中の一酸化炭素が半減します';

  @override
  String get health_smoking_24h => '心臓発作のリスクが下がり始めます';

  @override
  String get health_smoking_48h => '味覚と嗅覚が戻り始めます';

  @override
  String get health_smoking_72h => '呼吸がはっきりと楽になります';

  @override
  String get health_smoking_1m => '血行と肺機能が改善します';

  @override
  String get health_smoking_1y => '心臓病のリスクが半減します';

  @override
  String get health_vaping_24h => 'ニコチン欲求が和らぎ始めます';

  @override
  String get health_vaping_48h => '呼吸と味覚が回復し始めます';

  @override
  String get health_vaping_72h => '肺の炎症が治まり始めます';

  @override
  String get health_vaping_1w => '身体的な離脱症状がほぼ消えます';

  @override
  String get health_vaping_1m => '活力と肺活量が改善します';

  @override
  String get health_alcohol_24h => '深く落ち着いた睡眠に';

  @override
  String get health_alcohol_48h => '体が潤い、頭がクリアに';

  @override
  String get health_alcohol_1w => '肝酵素の値が回復し始めます';

  @override
  String get health_alcohol_2w => '消化と気分が安定します';

  @override
  String get health_alcohol_1m => '肌がすっきりし、睡眠が改善します';

  @override
  String get health_alcohol_3m => '肝臓の脂肪が減り始めます';

  @override
  String get health_alcohol_1y => '肝臓の回復が大きく進みます';

  @override
  String get health_sugar_1d => '血糖値が安定します';

  @override
  String get health_sugar_3d => '甘いものへの欲求が薄れ始めます';

  @override
  String get health_sugar_2w => '味覚が鋭くなります';

  @override
  String get health_sugar_1m => 'インスリン感受性が改善します';

  @override
  String get health_sugar_3m => '活力と肌が改善します';

  @override
  String get health_caffeine_1d => '離脱症状のピーク——ここを乗り切って';

  @override
  String get health_caffeine_3d => '頭痛が和らぎ始めます';

  @override
  String get health_caffeine_1w => '睡眠の質が改善します';

  @override
  String get health_caffeine_2w => '一日中エネルギーが安定します';

  @override
  String get health_caffeine_1m => '血圧が下がります';

  @override
  String get health_social_1d => '集中力が戻り始めます';

  @override
  String get health_social_3d => '不安が減ります';

  @override
  String get health_social_1w => '睡眠が改善します';

  @override
  String get health_social_2w => '気分が安定します';

  @override
  String get health_social_1m => '集中力と生産性が上がります';

  @override
  String get dayUnit => '日';

  @override
  String get hourUnit => '時間';

  @override
  String get minuteUnit => '分';
}
