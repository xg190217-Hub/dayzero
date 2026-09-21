// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'Your private quit companion';

  @override
  String get onboardingWelcomeTitle => 'A fresh start begins today';

  @override
  String get onboardingWelcomeBody =>
      'Track your quit journey privately. No account, no ads, no cloud. Everything stays on your device.';

  @override
  String get onboardingChooseTitle => 'What do you want to quit?';

  @override
  String get onboardingChooseBody =>
      'Pick one or more. You can add more later.';

  @override
  String get onboardingDateTitle => 'When is your quit day?';

  @override
  String get onboardingDateBody =>
      'You can quit today, or pick a date ahead. Starting now counts from the moment you press Start.';

  @override
  String get onboardingSpendTitle => 'How much did it cost you?';

  @override
  String get onboardingSpendBody =>
      'Optional — we use this to count the money you save. You can edit it later.';

  @override
  String get perDay => 'per day';

  @override
  String get currencyPlaceholder => 'Amount';

  @override
  String get onboardingReasonsTitle => 'Why do you want to quit?';

  @override
  String get onboardingReasonsBody =>
      'Write your reasons. We\'ll show them when cravings hit.';

  @override
  String get reasonPlaceholder => 'e.g. For my family…';

  @override
  String get addReason => 'Add another reason';

  @override
  String get startJourney => 'Start my journey';

  @override
  String get skip => 'Skip';

  @override
  String get notMedicalAdvice =>
      'DayZero provides motivation and tracking only — it is not medical advice. For severe withdrawal, please consult a doctor.';

  @override
  String get habit_alcohol => 'Alcohol';

  @override
  String get habit_smoking => 'Smoking';

  @override
  String get habit_vaping => 'Vaping';

  @override
  String get habit_sugar => 'Sugar';

  @override
  String get habit_caffeine => 'Caffeine';

  @override
  String get habit_social => 'Social media';

  @override
  String get habit_custom => 'My own habit';

  @override
  String get customHabitName => 'What\'s the habit called?';

  @override
  String get homeDaysSince => 'days free';

  @override
  String get homeDaysSinceOne => 'day free';

  @override
  String get homeTimeFree => 'free';

  @override
  String homeHoursFree(Object hours, Object minutes) {
    return 'Free for $hours hours $minutes minutes';
  }

  @override
  String homeDayN(Object n) {
    return 'Day $n';
  }

  @override
  String get timerBrokenHint => 'Check in now to restart from zero';

  @override
  String get pattern444 => '4-4-4 Box';

  @override
  String get pattern55 => '5-5 Balanced';

  @override
  String get pattern478 => '4-7-8 Deep';

  @override
  String get pattern446 => '4-4-6 Calm';

  @override
  String get timerBroken => 'Streak broken';

  @override
  String get timerNotStarted => 'Check in to start your timer';

  @override
  String get secondUnit => 's';

  @override
  String get homeMoneySaved => 'saved';

  @override
  String get homeCheckIn => 'Check in today';

  @override
  String get homeSOS => 'Craving SOS';

  @override
  String get homeHealthTimeline => 'Your recovery timeline';

  @override
  String get homeNextMilestone => 'Next milestone';

  @override
  String get homeIn => 'in';

  @override
  String get homeRelapse => 'I slipped';

  @override
  String get homeAddHabit => 'Add a habit';

  @override
  String get checkinTitle => 'Daily check-in';

  @override
  String get checkinMood => 'How do you feel?';

  @override
  String get checkinCraving => 'Craving level';

  @override
  String get checkinTrigger => 'What triggered it most?';

  @override
  String get trigger_none => 'Nothing in particular';

  @override
  String get trigger_stress => 'Stress';

  @override
  String get trigger_social => 'Social occasions';

  @override
  String get trigger_boredom => 'Boredom';

  @override
  String get trigger_habit_loop => 'Old routine';

  @override
  String get trigger_negative => 'Bad mood';

  @override
  String get trigger_celebration => 'Celebration';

  @override
  String get checkinNote => 'Note (optional)';

  @override
  String get checkinDone => 'Saved — see you tomorrow';

  @override
  String get checkinEditLabel => 'Edit today\'s check-in';

  @override
  String get sosTitle => 'Craving SOS';

  @override
  String get sosBody =>
      'Cravings peak for a few minutes and then pass. You can ride it out.';

  @override
  String get sosBreathing => 'Breathe with me';

  @override
  String get sosBreatheIn => 'Breathe in';

  @override
  String get sosBreatheOut => 'Breathe out';

  @override
  String get sosHold => 'Hold';

  @override
  String get sosReasons => 'Remember why you started';

  @override
  String get sosDistract => '90-second distraction';

  @override
  String get sosDistractBody => 'Tap the moving target 10 times';

  @override
  String get sosTapsLeft => 'taps left';

  @override
  String get sosDone => 'You made it through. The craving has passed.';

  @override
  String get sosAgain => 'Do it again';

  @override
  String get audioUnavailable => 'Audio is not available on this device';

  @override
  String get chooseAtLeastOne => 'Please choose at least one habit';

  @override
  String get dailyAmountLabel => 'How many per day?';

  @override
  String homeStreak(Object days) {
    return '$days-day streak';
  }

  @override
  String get rateLater => 'Maybe later';

  @override
  String get statsView7 => '7-day view';

  @override
  String get sosAmbient => 'Calm ambient';

  @override
  String premiumSaveAmount(Object amount) {
    return 'Save $amount';
  }

  @override
  String get surfingStep3 => 'It peaks, then it passes. You\'re still here.';

  @override
  String get surfingStep2 =>
      'Watch it rise like a wave. Don\'t fight it, don\'t judge it.';

  @override
  String get surfingStep1 =>
      'Find the feeling in your body. Where is it? Just notice it.';

  @override
  String get surfingTitle => 'Ride the wave';

  @override
  String identityLine(Object days, Object identity) {
    return 'You are $identity on day $days';
  }

  @override
  String get identity_social => 'screen-free';

  @override
  String get identity_caffeine => 'caffeine-free';

  @override
  String get identity_sugar => 'sugar-free';

  @override
  String get identity_vaping => 'vape-free';

  @override
  String get identity_alcohol => 'a non-drinker';

  @override
  String get identity_smoking => 'a non-smoker';

  @override
  String get relapseRecordRestart => 'Record the slip and restart the counter';

  @override
  String get relapseRecordKeep => 'Record the slip and keep going';

  @override
  String onboardingStep(Object step, Object total) {
    return '$step/$total';
  }

  @override
  String get plansAction => 'I will…';

  @override
  String get plansWhen => 'When…';

  @override
  String get plansAdd => 'Add a plan';

  @override
  String get plansEmpty =>
      'Write down what you\'ll do in your high-risk moments — we\'ll show it when you need it';

  @override
  String get plansTitle => 'My coping plans';

  @override
  String insightNoCompare(Object now) {
    return 'This week\'s average craving: $now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return 'Avg craving $now/5 this week vs $prev/5 last week — showing up daily is what counts';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return 'Avg craving $now/5 this week vs $prev/5 last week — getting better';
  }

  @override
  String get textAuto => 'Auto (default)';

  @override
  String get theme_violet => 'Violet';

  @override
  String get theme_sunset => 'Sunset';

  @override
  String get theme_rose => 'Rose';

  @override
  String get theme_ocean => 'Ocean';

  @override
  String get theme_forest => 'Forest';

  @override
  String get theme_sage => 'Sage';

  @override
  String get theme_custom => 'Custom';

  @override
  String get settingsTextColor => 'Text color';

  @override
  String get settingsFont => 'Font';

  @override
  String get settingsThemes => 'Themes';

  @override
  String get statsView30 => '30-day view';

  @override
  String get premiumFreeTrial => '7-day free trial';

  @override
  String get deleteAllConfirm =>
      'Delete ALL habits and their entire history? This cannot be undone.';

  @override
  String get rateAction => 'Rate on the App Store';

  @override
  String get rateBody =>
      'Your rating helps other people find the support they need.';

  @override
  String get rateTitle => 'Enjoying DayZero?';

  @override
  String settingsNotificationsTime(Object hour) {
    return 'A gentle nudge at $hour:00 every day';
  }

  @override
  String get notifBody =>
      'How was today? A quick check-in keeps your streak alive.';

  @override
  String get checkinOfferSos =>
      'That craving looks strong. Need help right now?';

  @override
  String get settingsReasons => 'My reasons';

  @override
  String get statsTitle => 'Your progress';

  @override
  String get statsMood => 'Mood';

  @override
  String get statsCraving => 'Craving intensity';

  @override
  String get statsWeek => 'This week';

  @override
  String get statsMonth => 'This month';

  @override
  String get statsAll => 'All time';

  @override
  String get statsCheckins => 'check-ins';

  @override
  String get statsStreak => 'day check-in streak';

  @override
  String get statsBestStreak => 'best streak';

  @override
  String get statsTotalFree => 'total days free';

  @override
  String get statsWeeklyReport => 'Weekly report';

  @override
  String get statsNoData =>
      'Not enough data yet. Check in daily to see your trends.';

  @override
  String get milestonesTitle => 'Milestones';

  @override
  String get milestonesUnlocked => 'Unlocked';

  @override
  String get milestonesLocked => 'Coming up';

  @override
  String get milestone_1h => 'First hour';

  @override
  String get milestone_1d => 'First day';

  @override
  String get milestone_3d => '3 days';

  @override
  String get milestone_1w => '1 week';

  @override
  String get milestone_2w => '2 weeks';

  @override
  String get milestone_1m => '1 month';

  @override
  String get milestone_3m => '3 months';

  @override
  String get milestone_6m => '6 months';

  @override
  String get milestone_1y => '1 year';

  @override
  String get milestone_streak7 => '7-day check-in streak';

  @override
  String get milestone_streak30 => '30-day check-in streak';

  @override
  String get milestone_money1 => 'Saved first 100';

  @override
  String get milestone_money2 => 'Saved 1,000';

  @override
  String get milestone_money3 => 'Saved 10,000';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsHabits => 'My habits';

  @override
  String get settingsEditHabit => 'Edit';

  @override
  String get settingsDeleteHabit => 'Delete';

  @override
  String get settingsNotifications => 'Daily check-in reminder';

  @override
  String get settingsNotificationsDesc => 'A gentle nudge at 8 PM';

  @override
  String get settingsExport => 'Export my data';

  @override
  String get settingsExportDesc => 'JSON backup of everything, saved to Files';

  @override
  String get settingsPremium => 'DayZero Premium';

  @override
  String get settingsPremiumActive =>
      'Premium active — thank you for supporting an indie app';

  @override
  String get settingsRestore => 'Restore purchases';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutBody =>
      'DayZero is made by an indie developer. 100% offline — your data never leaves this device.';

  @override
  String get settingsReset => 'Reset quit date';

  @override
  String get settingsRelapseReset => 'Restart the counter';

  @override
  String get settingsDeleteData => 'Delete all data';

  @override
  String get deleteHabitConfirm => 'Delete this habit and all its history?';

  @override
  String get relapseTitle => 'Slipped?';

  @override
  String get relapseBody =>
      'One slip doesn\'t erase your progress. You can restart the counter, or just log the craving and keep going.';

  @override
  String get relapseRestart => 'Restart counter';

  @override
  String get relapseKeep => 'Keep going';

  @override
  String get premiumTitle => 'DayZero Premium';

  @override
  String get premiumSubtitle => 'Everything you need to stay free';

  @override
  String get premiumFeature1 => 'Unlimited habits';

  @override
  String get premiumFeature2 => 'Complete breathing audio library';

  @override
  String get premiumFeature3 => 'Themes, fonts & text colors';

  @override
  String get premiumFeature4 => 'Milestone celebration ceremonies';

  @override
  String get premiumFreeNote =>
      'Free version tracks 2 habits with core stats — forever, no ads.';

  @override
  String get premiumWeekly => 'Weekly';

  @override
  String get premiumMonthly => 'Monthly';

  @override
  String get premiumYearly => 'Yearly';

  @override
  String get premiumLifetime => 'Lifetime';

  @override
  String get premiumBestValue => 'BEST VALUE';

  @override
  String get premiumPerWeek => '/week';

  @override
  String get premiumPerMonth => '/month';

  @override
  String get premiumPerYear => '/year';

  @override
  String get premiumOnce => 'once';

  @override
  String get premiumSubscribe => 'Continue';

  @override
  String get premiumRestore => 'Restore purchases';

  @override
  String get premiumAutoRenew =>
      'Subscription renews automatically and can be cancelled anytime in your Apple ID settings at least 24 hours before the current period ends.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'By continuing you agree to our $terms and $privacy.';
  }

  @override
  String get termsLink => 'Terms of Use';

  @override
  String get privacyLink => 'Privacy Policy';

  @override
  String get buying => 'Processing…';

  @override
  String get buyError => 'Purchase failed. Please try again.';

  @override
  String get restoreDone => 'Purchases restored';

  @override
  String get restoreNothing => 'No previous purchases found';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get demoMode => 'Web demo mode — Premium is unlocked for testing';

  @override
  String get exportDone => 'Export saved';

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
  String get language_system => 'System';

  @override
  String get health_smoking_20m =>
      'Blood pressure and heart rate start to normalize';

  @override
  String get health_smoking_8h => 'Carbon monoxide in blood drops by half';

  @override
  String get health_smoking_24h => 'Heart attack risk begins to drop';

  @override
  String get health_smoking_48h => 'Taste and smell start to recover';

  @override
  String get health_smoking_72h => 'Breathing becomes noticeably easier';

  @override
  String get health_smoking_1m => 'Circulation and lung function improve';

  @override
  String get health_smoking_1y => 'Heart disease risk halves';

  @override
  String get health_vaping_24h => 'Nicotine cravings begin to ease';

  @override
  String get health_vaping_48h => 'Breathing and taste start to recover';

  @override
  String get health_vaping_72h => 'Lung inflammation starts to subside';

  @override
  String get health_vaping_1w => 'Most physical withdrawal fades';

  @override
  String get health_vaping_1m => 'Energy and lung capacity improve';

  @override
  String get health_alcohol_24h => 'Deeper, more restful sleep';

  @override
  String get health_alcohol_48h => 'Body rehydrates, head clears';

  @override
  String get health_alcohol_1w => 'Liver enzymes start to recover';

  @override
  String get health_alcohol_2w => 'Digestion and mood stabilize';

  @override
  String get health_alcohol_1m => 'Skin looks fresher, sleep improves';

  @override
  String get health_alcohol_3m => 'Liver fat begins to decrease';

  @override
  String get health_alcohol_1y => 'Liver healing substantially progresses';

  @override
  String get health_sugar_1d => 'Blood sugar levels stabilize';

  @override
  String get health_sugar_3d => 'Cravings start to fade';

  @override
  String get health_sugar_2w => 'Taste buds re-sensitize';

  @override
  String get health_sugar_1m => 'Insulin sensitivity improves';

  @override
  String get health_sugar_3m => 'Energy and skin improve';

  @override
  String get health_caffeine_1d => 'Withdrawal peaks — hang in there';

  @override
  String get health_caffeine_3d => 'Headaches start to subside';

  @override
  String get health_caffeine_1w => 'Sleep quality improves';

  @override
  String get health_caffeine_2w => 'Energy becomes stable all day';

  @override
  String get health_caffeine_1m => 'Blood pressure drops';

  @override
  String get health_social_1d => 'Attention span begins to recover';

  @override
  String get health_social_3d => 'Anxiety levels drop';

  @override
  String get health_social_1w => 'Sleep improves';

  @override
  String get health_social_2w => 'Mood stabilizes';

  @override
  String get health_social_1m => 'Focus and productivity climb';

  @override
  String get dayUnit => 'd';

  @override
  String get hourUnit => 'h';

  @override
  String get minuteUnit => 'm';
}
