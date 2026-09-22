import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DayZero'**
  String get appTitle;

  /// Short selling line shown on onboarding
  ///
  /// In en, this message translates to:
  /// **'Your private quit companion'**
  String get appTagline;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'A fresh start begins today'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Track your quit journey privately. No account, no ads, no cloud. Everything stays on your device.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to quit?'**
  String get onboardingChooseTitle;

  /// No description provided for @onboardingChooseBody.
  ///
  /// In en, this message translates to:
  /// **'Pick one or more. You can add more later.'**
  String get onboardingChooseBody;

  /// No description provided for @onboardingDateTitle.
  ///
  /// In en, this message translates to:
  /// **'When is your quit day?'**
  String get onboardingDateTitle;

  /// No description provided for @onboardingDateBody.
  ///
  /// In en, this message translates to:
  /// **'You can quit today, or pick a date ahead. Starting now counts from the moment you press Start.'**
  String get onboardingDateBody;

  /// No description provided for @onboardingSpendTitle.
  ///
  /// In en, this message translates to:
  /// **'How much did it cost you?'**
  String get onboardingSpendTitle;

  /// No description provided for @onboardingSpendBody.
  ///
  /// In en, this message translates to:
  /// **'Optional — we use this to count the money you save. You can edit it later.'**
  String get onboardingSpendBody;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get perDay;

  /// No description provided for @currencyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get currencyPlaceholder;

  /// No description provided for @onboardingReasonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to quit?'**
  String get onboardingReasonsTitle;

  /// No description provided for @onboardingReasonsBody.
  ///
  /// In en, this message translates to:
  /// **'Write your reasons. We\'ll show them when cravings hit.'**
  String get onboardingReasonsBody;

  /// No description provided for @reasonPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. For my family…'**
  String get reasonPlaceholder;

  /// No description provided for @addReason.
  ///
  /// In en, this message translates to:
  /// **'Add another reason'**
  String get addReason;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start my journey'**
  String get startJourney;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @notMedicalAdvice.
  ///
  /// In en, this message translates to:
  /// **'DayZero provides motivation and tracking only — it is not medical advice. For severe withdrawal, please consult a doctor.'**
  String get notMedicalAdvice;

  /// No description provided for @habit_alcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get habit_alcohol;

  /// No description provided for @habit_smoking.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get habit_smoking;

  /// No description provided for @habit_vaping.
  ///
  /// In en, this message translates to:
  /// **'Vaping'**
  String get habit_vaping;

  /// No description provided for @habit_sugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get habit_sugar;

  /// No description provided for @habit_caffeine.
  ///
  /// In en, this message translates to:
  /// **'Caffeine'**
  String get habit_caffeine;

  /// No description provided for @habit_social.
  ///
  /// In en, this message translates to:
  /// **'Social media'**
  String get habit_social;

  /// No description provided for @habit_custom.
  ///
  /// In en, this message translates to:
  /// **'My own habit'**
  String get habit_custom;

  /// No description provided for @customHabitName.
  ///
  /// In en, this message translates to:
  /// **'What\'s the habit called?'**
  String get customHabitName;

  /// No description provided for @homeDaysSince.
  ///
  /// In en, this message translates to:
  /// **'days free'**
  String get homeDaysSince;

  /// No description provided for @homeDaysSinceOne.
  ///
  /// In en, this message translates to:
  /// **'day free'**
  String get homeDaysSinceOne;

  /// No description provided for @homeTimeFree.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get homeTimeFree;

  /// No description provided for @homeHoursFree.
  ///
  /// In en, this message translates to:
  /// **'Free for {hours} hours {minutes} minutes'**
  String homeHoursFree(Object hours, Object minutes);

  /// No description provided for @homeDayN.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String homeDayN(Object n);

  /// No description provided for @timerBrokenHint.
  ///
  /// In en, this message translates to:
  /// **'Check in now to restart from zero'**
  String get timerBrokenHint;

  /// No description provided for @pattern444.
  ///
  /// In en, this message translates to:
  /// **'4-4-4 Box'**
  String get pattern444;

  /// No description provided for @pattern55.
  ///
  /// In en, this message translates to:
  /// **'5-5 Balanced'**
  String get pattern55;

  /// No description provided for @pattern478.
  ///
  /// In en, this message translates to:
  /// **'4-7-8 Deep'**
  String get pattern478;

  /// No description provided for @pattern446.
  ///
  /// In en, this message translates to:
  /// **'4-4-6 Calm'**
  String get pattern446;

  /// No description provided for @timerBroken.
  ///
  /// In en, this message translates to:
  /// **'Streak broken'**
  String get timerBroken;

  /// No description provided for @timerNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Check in to start your timer'**
  String get timerNotStarted;

  /// No description provided for @secondUnit.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondUnit;

  /// No description provided for @homeMoneySaved.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get homeMoneySaved;

  /// No description provided for @homeCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in today'**
  String get homeCheckIn;

  /// No description provided for @homeSOS.
  ///
  /// In en, this message translates to:
  /// **'Craving SOS'**
  String get homeSOS;

  /// No description provided for @homeHealthTimeline.
  ///
  /// In en, this message translates to:
  /// **'Your recovery timeline'**
  String get homeHealthTimeline;

  /// No description provided for @homeNextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Next milestone'**
  String get homeNextMilestone;

  /// No description provided for @homeIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get homeIn;

  /// No description provided for @homeRelapse.
  ///
  /// In en, this message translates to:
  /// **'I slipped'**
  String get homeRelapse;

  /// No description provided for @homeAddHabit.
  ///
  /// In en, this message translates to:
  /// **'Add a habit'**
  String get homeAddHabit;

  /// No description provided for @checkinTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get checkinTitle;

  /// No description provided for @checkinMood.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get checkinMood;

  /// No description provided for @checkinCraving.
  ///
  /// In en, this message translates to:
  /// **'Craving level'**
  String get checkinCraving;

  /// No description provided for @checkinTrigger.
  ///
  /// In en, this message translates to:
  /// **'What triggered it most?'**
  String get checkinTrigger;

  /// No description provided for @trigger_none.
  ///
  /// In en, this message translates to:
  /// **'Nothing in particular'**
  String get trigger_none;

  /// No description provided for @trigger_stress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get trigger_stress;

  /// No description provided for @trigger_social.
  ///
  /// In en, this message translates to:
  /// **'Social occasions'**
  String get trigger_social;

  /// No description provided for @trigger_boredom.
  ///
  /// In en, this message translates to:
  /// **'Boredom'**
  String get trigger_boredom;

  /// No description provided for @trigger_habit_loop.
  ///
  /// In en, this message translates to:
  /// **'Old routine'**
  String get trigger_habit_loop;

  /// No description provided for @trigger_negative.
  ///
  /// In en, this message translates to:
  /// **'Bad mood'**
  String get trigger_negative;

  /// No description provided for @trigger_celebration.
  ///
  /// In en, this message translates to:
  /// **'Celebration'**
  String get trigger_celebration;

  /// No description provided for @checkinNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get checkinNote;

  /// No description provided for @checkinDone.
  ///
  /// In en, this message translates to:
  /// **'Saved — see you tomorrow'**
  String get checkinDone;

  /// No description provided for @checkinEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit today\'s check-in'**
  String get checkinEditLabel;

  /// No description provided for @sosTitle.
  ///
  /// In en, this message translates to:
  /// **'Craving SOS'**
  String get sosTitle;

  /// No description provided for @sosBody.
  ///
  /// In en, this message translates to:
  /// **'Cravings peak for a few minutes and then pass. You can ride it out.'**
  String get sosBody;

  /// No description provided for @sosBreathing.
  ///
  /// In en, this message translates to:
  /// **'Breathe with me'**
  String get sosBreathing;

  /// No description provided for @sosBreatheIn.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get sosBreatheIn;

  /// No description provided for @sosBreatheOut.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get sosBreatheOut;

  /// No description provided for @sosHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get sosHold;

  /// No description provided for @sosReasons.
  ///
  /// In en, this message translates to:
  /// **'Remember why you started'**
  String get sosReasons;

  /// No description provided for @sosDistract.
  ///
  /// In en, this message translates to:
  /// **'90-second distraction'**
  String get sosDistract;

  /// No description provided for @sosDistractBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the moving target 10 times'**
  String get sosDistractBody;

  /// No description provided for @sosTapsLeft.
  ///
  /// In en, this message translates to:
  /// **'taps left'**
  String get sosTapsLeft;

  /// No description provided for @sosDone.
  ///
  /// In en, this message translates to:
  /// **'You made it through. The craving has passed.'**
  String get sosDone;

  /// No description provided for @sosAgain.
  ///
  /// In en, this message translates to:
  /// **'Do it again'**
  String get sosAgain;

  /// No description provided for @audioUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Audio is not available on this device'**
  String get audioUnavailable;

  /// No description provided for @chooseAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please choose at least one habit'**
  String get chooseAtLeastOne;

  /// No description provided for @dailyAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'How many per day?'**
  String get dailyAmountLabel;

  /// No description provided for @homeStreak.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String homeStreak(Object days);

  /// No description provided for @rateLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get rateLater;

  /// No description provided for @statsView7.
  ///
  /// In en, this message translates to:
  /// **'7-day view'**
  String get statsView7;

  /// No description provided for @sosAmbient.
  ///
  /// In en, this message translates to:
  /// **'Calm ambient'**
  String get sosAmbient;

  /// No description provided for @ambientFire.
  ///
  /// In en, this message translates to:
  /// **'Campfire'**
  String get ambientFire;

  /// No description provided for @ambientForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get ambientForest;

  /// No description provided for @ambientOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean waves'**
  String get ambientOcean;

  /// No description provided for @ambientRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get ambientRain;

  /// No description provided for @ambientMusic.
  ///
  /// In en, this message translates to:
  /// **'Music box'**
  String get ambientMusic;

  /// No description provided for @premiumSaveAmount.
  ///
  /// In en, this message translates to:
  /// **'Save {amount}'**
  String premiumSaveAmount(Object amount);

  /// No description provided for @surfingStep3.
  ///
  /// In en, this message translates to:
  /// **'It peaks, then it passes. You\'re still here.'**
  String get surfingStep3;

  /// No description provided for @surfingStep2.
  ///
  /// In en, this message translates to:
  /// **'Watch it rise like a wave. Don\'t fight it, don\'t judge it.'**
  String get surfingStep2;

  /// No description provided for @surfingStep1.
  ///
  /// In en, this message translates to:
  /// **'Find the feeling in your body. Where is it? Just notice it.'**
  String get surfingStep1;

  /// No description provided for @surfingTitle.
  ///
  /// In en, this message translates to:
  /// **'Ride the wave'**
  String get surfingTitle;

  /// No description provided for @identityLine.
  ///
  /// In en, this message translates to:
  /// **'You are {identity} on day {days}'**
  String identityLine(Object days, Object identity);

  /// No description provided for @identity_social.
  ///
  /// In en, this message translates to:
  /// **'screen-free'**
  String get identity_social;

  /// No description provided for @identity_caffeine.
  ///
  /// In en, this message translates to:
  /// **'caffeine-free'**
  String get identity_caffeine;

  /// No description provided for @identity_sugar.
  ///
  /// In en, this message translates to:
  /// **'sugar-free'**
  String get identity_sugar;

  /// No description provided for @identity_vaping.
  ///
  /// In en, this message translates to:
  /// **'vape-free'**
  String get identity_vaping;

  /// No description provided for @identity_alcohol.
  ///
  /// In en, this message translates to:
  /// **'a non-drinker'**
  String get identity_alcohol;

  /// No description provided for @identity_smoking.
  ///
  /// In en, this message translates to:
  /// **'a non-smoker'**
  String get identity_smoking;

  /// No description provided for @relapseRecordRestart.
  ///
  /// In en, this message translates to:
  /// **'Record the slip and restart the counter'**
  String get relapseRecordRestart;

  /// No description provided for @relapseRecordKeep.
  ///
  /// In en, this message translates to:
  /// **'Record the slip and keep going'**
  String get relapseRecordKeep;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'{step}/{total}'**
  String onboardingStep(Object step, Object total);

  /// No description provided for @plansAction.
  ///
  /// In en, this message translates to:
  /// **'I will…'**
  String get plansAction;

  /// No description provided for @plansWhen.
  ///
  /// In en, this message translates to:
  /// **'When…'**
  String get plansWhen;

  /// No description provided for @plansAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a plan'**
  String get plansAdd;

  /// No description provided for @plansEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write down what you\'ll do in your high-risk moments — we\'ll show it when you need it'**
  String get plansEmpty;

  /// No description provided for @plansTitle.
  ///
  /// In en, this message translates to:
  /// **'My coping plans'**
  String get plansTitle;

  /// No description provided for @insightNoCompare.
  ///
  /// In en, this message translates to:
  /// **'This week\'s average craving: {now}/5'**
  String insightNoCompare(Object now);

  /// No description provided for @insightWorse.
  ///
  /// In en, this message translates to:
  /// **'Avg craving {now}/5 this week vs {prev}/5 last week — showing up daily is what counts'**
  String insightWorse(Object now, Object prev);

  /// No description provided for @insightBetter.
  ///
  /// In en, this message translates to:
  /// **'Avg craving {now}/5 this week vs {prev}/5 last week — getting better'**
  String insightBetter(Object now, Object prev);

  /// No description provided for @textAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto (default)'**
  String get textAuto;

  /// No description provided for @theme_violet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get theme_violet;

  /// No description provided for @theme_sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get theme_sunset;

  /// No description provided for @theme_rose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get theme_rose;

  /// No description provided for @theme_ocean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get theme_ocean;

  /// No description provided for @theme_forest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get theme_forest;

  /// No description provided for @theme_sage.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get theme_sage;

  /// No description provided for @theme_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get theme_custom;

  /// No description provided for @settingsTextColor.
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get settingsTextColor;

  /// No description provided for @settingsFont.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get settingsFont;

  /// No description provided for @settingsThemes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get settingsThemes;

  /// No description provided for @statsView30.
  ///
  /// In en, this message translates to:
  /// **'30-day view'**
  String get statsView30;

  /// No description provided for @premiumFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'7-day free trial'**
  String get premiumFreeTrial;

  /// No description provided for @deleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete ALL habits and their entire history? This cannot be undone.'**
  String get deleteAllConfirm;

  /// No description provided for @rateAction.
  ///
  /// In en, this message translates to:
  /// **'Rate on the App Store'**
  String get rateAction;

  /// No description provided for @rateBody.
  ///
  /// In en, this message translates to:
  /// **'Your rating helps other people find the support they need.'**
  String get rateBody;

  /// No description provided for @rateTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying DayZero?'**
  String get rateTitle;

  /// No description provided for @settingsNotificationsTime.
  ///
  /// In en, this message translates to:
  /// **'A gentle nudge at {hour}:00 every day'**
  String settingsNotificationsTime(Object hour);

  /// No description provided for @notifBody.
  ///
  /// In en, this message translates to:
  /// **'How was today? A quick check-in keeps your streak alive.'**
  String get notifBody;

  /// No description provided for @checkinOfferSos.
  ///
  /// In en, this message translates to:
  /// **'That craving looks strong. Need help right now?'**
  String get checkinOfferSos;

  /// No description provided for @settingsReasons.
  ///
  /// In en, this message translates to:
  /// **'My reasons'**
  String get settingsReasons;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get statsTitle;

  /// No description provided for @statsMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get statsMood;

  /// No description provided for @statsCraving.
  ///
  /// In en, this message translates to:
  /// **'Craving intensity'**
  String get statsCraving;

  /// No description provided for @statsWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get statsWeek;

  /// No description provided for @statsMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get statsMonth;

  /// No description provided for @statsAll.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get statsAll;

  /// No description provided for @statsCheckins.
  ///
  /// In en, this message translates to:
  /// **'check-ins'**
  String get statsCheckins;

  /// No description provided for @statsStreak.
  ///
  /// In en, this message translates to:
  /// **'day check-in streak'**
  String get statsStreak;

  /// No description provided for @statsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'best streak'**
  String get statsBestStreak;

  /// No description provided for @statsTotalFree.
  ///
  /// In en, this message translates to:
  /// **'total days free'**
  String get statsTotalFree;

  /// No description provided for @statsWeeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly report'**
  String get statsWeeklyReport;

  /// No description provided for @statsNoData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet. Check in daily to see your trends.'**
  String get statsNoData;

  /// No description provided for @milestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestonesTitle;

  /// No description provided for @milestonesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get milestonesUnlocked;

  /// No description provided for @milestonesLocked.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get milestonesLocked;

  /// No description provided for @milestone_1h.
  ///
  /// In en, this message translates to:
  /// **'First hour'**
  String get milestone_1h;

  /// No description provided for @milestone_1d.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get milestone_1d;

  /// No description provided for @milestone_3d.
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get milestone_3d;

  /// No description provided for @milestone_1w.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get milestone_1w;

  /// No description provided for @milestone_2w.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get milestone_2w;

  /// No description provided for @milestone_1m.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get milestone_1m;

  /// No description provided for @milestone_3m.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get milestone_3m;

  /// No description provided for @milestone_6m.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get milestone_6m;

  /// No description provided for @milestone_1y.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get milestone_1y;

  /// No description provided for @milestone_streak7.
  ///
  /// In en, this message translates to:
  /// **'7-day check-in streak'**
  String get milestone_streak7;

  /// No description provided for @milestone_streak30.
  ///
  /// In en, this message translates to:
  /// **'30-day check-in streak'**
  String get milestone_streak30;

  /// No description provided for @milestone_money1.
  ///
  /// In en, this message translates to:
  /// **'Saved first 100'**
  String get milestone_money1;

  /// No description provided for @milestone_money2.
  ///
  /// In en, this message translates to:
  /// **'Saved 1,000'**
  String get milestone_money2;

  /// No description provided for @milestone_money3.
  ///
  /// In en, this message translates to:
  /// **'Saved 10,000'**
  String get milestone_money3;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsHabits.
  ///
  /// In en, this message translates to:
  /// **'My habits'**
  String get settingsHabits;

  /// No description provided for @settingsEditHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get settingsEditHabit;

  /// No description provided for @settingsDeleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDeleteHabit;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in reminder'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'A gentle nudge at 8 PM'**
  String get settingsNotificationsDesc;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get settingsExport;

  /// No description provided for @settingsExportDesc.
  ///
  /// In en, this message translates to:
  /// **'JSON backup of everything, saved to Files'**
  String get settingsExportDesc;

  /// No description provided for @settingsPremium.
  ///
  /// In en, this message translates to:
  /// **'DayZero Premium'**
  String get settingsPremium;

  /// No description provided for @settingsPremiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium active — thank you for supporting an indie app'**
  String get settingsPremiumActive;

  /// No description provided for @settingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsRestore;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTerms;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'DayZero is made by an indie developer. 100% offline — your data never leaves this device.'**
  String get settingsAboutBody;

  /// No description provided for @settingsReset.
  ///
  /// In en, this message translates to:
  /// **'Reset quit date'**
  String get settingsReset;

  /// No description provided for @settingsRelapseReset.
  ///
  /// In en, this message translates to:
  /// **'Restart the counter'**
  String get settingsRelapseReset;

  /// No description provided for @settingsDeleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsDeleteData;

  /// No description provided for @deleteHabitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this habit and all its history?'**
  String get deleteHabitConfirm;

  /// No description provided for @relapseTitle.
  ///
  /// In en, this message translates to:
  /// **'Slipped?'**
  String get relapseTitle;

  /// No description provided for @relapseBody.
  ///
  /// In en, this message translates to:
  /// **'One slip doesn\'t erase your progress. You can restart the counter, or just log the craving and keep going.'**
  String get relapseBody;

  /// No description provided for @relapseRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart counter'**
  String get relapseRestart;

  /// No description provided for @relapseKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get relapseKeep;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'DayZero Premium'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to stay free'**
  String get premiumSubtitle;

  /// No description provided for @premiumFeature1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited habits'**
  String get premiumFeature1;

  /// No description provided for @premiumFeature2.
  ///
  /// In en, this message translates to:
  /// **'Ambient soundscape library (rain, ocean, campfire)'**
  String get premiumFeature2;

  /// No description provided for @premiumFeature3.
  ///
  /// In en, this message translates to:
  /// **'Themes, fonts & text colors'**
  String get premiumFeature3;

  /// No description provided for @premiumFeature4.
  ///
  /// In en, this message translates to:
  /// **'Trigger insights: see what tempts you most'**
  String get premiumFeature4;

  /// No description provided for @premiumFreeNote.
  ///
  /// In en, this message translates to:
  /// **'Free version tracks 2 habits with core stats — forever, no ads.'**
  String get premiumFreeNote;

  /// No description provided for @premiumWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get premiumWeekly;

  /// No description provided for @premiumMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get premiumMonthly;

  /// No description provided for @premiumYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get premiumYearly;

  /// No description provided for @premiumLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get premiumLifetime;

  /// No description provided for @premiumBestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get premiumBestValue;

  /// No description provided for @premiumPerWeek.
  ///
  /// In en, this message translates to:
  /// **'/week'**
  String get premiumPerWeek;

  /// No description provided for @premiumPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get premiumPerMonth;

  /// No description provided for @premiumPerYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get premiumPerYear;

  /// No description provided for @premiumOnce.
  ///
  /// In en, this message translates to:
  /// **'once'**
  String get premiumOnce;

  /// No description provided for @premiumSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get premiumSubscribe;

  /// No description provided for @premiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get premiumRestore;

  /// No description provided for @premiumAutoRenew.
  ///
  /// In en, this message translates to:
  /// **'Subscription renews automatically and can be cancelled anytime in your Apple ID settings at least 24 hours before the current period ends.'**
  String get premiumAutoRenew;

  /// No description provided for @premiumTermsLinks.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our {terms} and {privacy}.'**
  String premiumTermsLinks(Object privacy, Object terms);

  /// No description provided for @termsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsLink;

  /// No description provided for @privacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyLink;

  /// No description provided for @buying.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get buying;

  /// No description provided for @buyError.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get buyError;

  /// No description provided for @restoreDone.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get restoreDone;

  /// No description provided for @restoreNothing.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found'**
  String get restoreNothing;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Web demo mode — Premium is unlocked for testing'**
  String get demoMode;

  /// No description provided for @exportDone.
  ///
  /// In en, this message translates to:
  /// **'Export saved'**
  String get exportDone;

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_zh.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get language_zh;

  /// No description provided for @language_ja.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get language_ja;

  /// No description provided for @language_de.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get language_de;

  /// No description provided for @language_fr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get language_fr;

  /// No description provided for @language_es.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get language_es;

  /// No description provided for @language_pt.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get language_pt;

  /// No description provided for @language_ru.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get language_ru;

  /// No description provided for @language_ko.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get language_ko;

  /// No description provided for @language_it.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get language_it;

  /// No description provided for @language_ar.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get language_ar;

  /// No description provided for @language_tr.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get language_tr;

  /// No description provided for @language_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get language_system;

  /// No description provided for @health_smoking_20m.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure and heart rate start to normalize'**
  String get health_smoking_20m;

  /// No description provided for @health_smoking_8h.
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide in blood drops by half'**
  String get health_smoking_8h;

  /// No description provided for @health_smoking_24h.
  ///
  /// In en, this message translates to:
  /// **'Heart attack risk begins to drop'**
  String get health_smoking_24h;

  /// No description provided for @health_smoking_48h.
  ///
  /// In en, this message translates to:
  /// **'Taste and smell start to recover'**
  String get health_smoking_48h;

  /// No description provided for @health_smoking_72h.
  ///
  /// In en, this message translates to:
  /// **'Breathing becomes noticeably easier'**
  String get health_smoking_72h;

  /// No description provided for @health_smoking_1m.
  ///
  /// In en, this message translates to:
  /// **'Circulation and lung function improve'**
  String get health_smoking_1m;

  /// No description provided for @health_smoking_1y.
  ///
  /// In en, this message translates to:
  /// **'Heart disease risk halves'**
  String get health_smoking_1y;

  /// No description provided for @health_vaping_24h.
  ///
  /// In en, this message translates to:
  /// **'Nicotine cravings begin to ease'**
  String get health_vaping_24h;

  /// No description provided for @health_vaping_48h.
  ///
  /// In en, this message translates to:
  /// **'Breathing and taste start to recover'**
  String get health_vaping_48h;

  /// No description provided for @health_vaping_72h.
  ///
  /// In en, this message translates to:
  /// **'Lung inflammation starts to subside'**
  String get health_vaping_72h;

  /// No description provided for @health_vaping_1w.
  ///
  /// In en, this message translates to:
  /// **'Most physical withdrawal fades'**
  String get health_vaping_1w;

  /// No description provided for @health_vaping_1m.
  ///
  /// In en, this message translates to:
  /// **'Energy and lung capacity improve'**
  String get health_vaping_1m;

  /// No description provided for @health_alcohol_24h.
  ///
  /// In en, this message translates to:
  /// **'Deeper, more restful sleep'**
  String get health_alcohol_24h;

  /// No description provided for @health_alcohol_48h.
  ///
  /// In en, this message translates to:
  /// **'Body rehydrates, head clears'**
  String get health_alcohol_48h;

  /// No description provided for @health_alcohol_1w.
  ///
  /// In en, this message translates to:
  /// **'Liver enzymes start to recover'**
  String get health_alcohol_1w;

  /// No description provided for @health_alcohol_2w.
  ///
  /// In en, this message translates to:
  /// **'Digestion and mood stabilize'**
  String get health_alcohol_2w;

  /// No description provided for @health_alcohol_1m.
  ///
  /// In en, this message translates to:
  /// **'Skin looks fresher, sleep improves'**
  String get health_alcohol_1m;

  /// No description provided for @health_alcohol_3m.
  ///
  /// In en, this message translates to:
  /// **'Liver fat begins to decrease'**
  String get health_alcohol_3m;

  /// No description provided for @health_alcohol_1y.
  ///
  /// In en, this message translates to:
  /// **'Liver healing substantially progresses'**
  String get health_alcohol_1y;

  /// No description provided for @health_sugar_1d.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar levels stabilize'**
  String get health_sugar_1d;

  /// No description provided for @health_sugar_3d.
  ///
  /// In en, this message translates to:
  /// **'Cravings start to fade'**
  String get health_sugar_3d;

  /// No description provided for @health_sugar_2w.
  ///
  /// In en, this message translates to:
  /// **'Taste buds re-sensitize'**
  String get health_sugar_2w;

  /// No description provided for @health_sugar_1m.
  ///
  /// In en, this message translates to:
  /// **'Insulin sensitivity improves'**
  String get health_sugar_1m;

  /// No description provided for @health_sugar_3m.
  ///
  /// In en, this message translates to:
  /// **'Energy and skin improve'**
  String get health_sugar_3m;

  /// No description provided for @health_caffeine_1d.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal peaks — hang in there'**
  String get health_caffeine_1d;

  /// No description provided for @health_caffeine_3d.
  ///
  /// In en, this message translates to:
  /// **'Headaches start to subside'**
  String get health_caffeine_3d;

  /// No description provided for @health_caffeine_1w.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality improves'**
  String get health_caffeine_1w;

  /// No description provided for @health_caffeine_2w.
  ///
  /// In en, this message translates to:
  /// **'Energy becomes stable all day'**
  String get health_caffeine_2w;

  /// No description provided for @health_caffeine_1m.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure drops'**
  String get health_caffeine_1m;

  /// No description provided for @health_social_1d.
  ///
  /// In en, this message translates to:
  /// **'Attention span begins to recover'**
  String get health_social_1d;

  /// No description provided for @health_social_3d.
  ///
  /// In en, this message translates to:
  /// **'Anxiety levels drop'**
  String get health_social_3d;

  /// No description provided for @health_social_1w.
  ///
  /// In en, this message translates to:
  /// **'Sleep improves'**
  String get health_social_1w;

  /// No description provided for @health_social_2w.
  ///
  /// In en, this message translates to:
  /// **'Mood stabilizes'**
  String get health_social_2w;

  /// No description provided for @health_social_1m.
  ///
  /// In en, this message translates to:
  /// **'Focus and productivity climb'**
  String get health_social_1m;

  /// No description provided for @dayUnit.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get dayUnit;

  /// No description provided for @hourUnit.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hourUnit;

  /// No description provided for @minuteUnit.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minuteUnit;

  /// No description provided for @statsTriggerTitle.
  ///
  /// In en, this message translates to:
  /// **'Top triggers'**
  String get statsTriggerTitle;

  /// No description provided for @statsTriggerLocked.
  ///
  /// In en, this message translates to:
  /// **'Unlock trigger insights with Premium'**
  String get statsTriggerLocked;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
