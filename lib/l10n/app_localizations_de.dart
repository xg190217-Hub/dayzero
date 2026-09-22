// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'Dein privater Begleiter zum Aufhören';

  @override
  String get onboardingWelcomeTitle => 'Ein Neuanfang beginnt heute';

  @override
  String get onboardingWelcomeBody =>
      'Verfolge deinen Weg privat. Kein Konto, keine Werbung, keine Cloud. Alles bleibt auf deinem Gerät.';

  @override
  String get onboardingChooseTitle => 'Womit möchtest du aufhören?';

  @override
  String get onboardingChooseBody =>
      'Wähle eine oder mehrere Gewohnheiten. Du kannst später weitere hinzufügen.';

  @override
  String get onboardingDateTitle => 'Wann ist dein Tag Null?';

  @override
  String get onboardingDateBody =>
      'Du kannst heute beginnen oder ein Datum wählen. Bei „Heute“ zählt ab dem Moment, in dem du auf Start drückst.';

  @override
  String get onboardingSpendTitle => 'Wie viel hat es dich täglich gekostet?';

  @override
  String get onboardingSpendBody =>
      'Optional – wir berechnen damit dein gespartes Geld. Später änderbar.';

  @override
  String get perDay => 'pro Tag';

  @override
  String get currencyPlaceholder => 'Betrag';

  @override
  String get onboardingReasonsTitle => 'Warum möchtest du aufhören?';

  @override
  String get onboardingReasonsBody =>
      'Schreib deine Gründe auf. Bei Verlangen zeigen wir sie dir.';

  @override
  String get reasonPlaceholder => 'z. B. Für meine Familie…';

  @override
  String get addReason => 'Weiteren Grund hinzufügen';

  @override
  String get startJourney => 'Meine Reise beginnen';

  @override
  String get skip => 'Überspringen';

  @override
  String get notMedicalAdvice =>
      'DayZero bietet nur Motivation und Aufzeichnung – keine medizinische Beratung. Bei starken Entzugserscheinungen bitte einen Arzt aufsuchen.';

  @override
  String get habit_alcohol => 'Alkohol';

  @override
  String get habit_smoking => 'Rauchen';

  @override
  String get habit_vaping => 'Vapen';

  @override
  String get habit_sugar => 'Zucker';

  @override
  String get habit_caffeine => 'Koffein';

  @override
  String get habit_social => 'Soziale Medien';

  @override
  String get habit_custom => 'Eigene Gewohnheit';

  @override
  String get customHabitName => 'Wie heißt die Gewohnheit?';

  @override
  String get homeDaysSince => 'Tage frei';

  @override
  String get homeDaysSinceOne => 'Tag frei';

  @override
  String get homeTimeFree => 'frei';

  @override
  String homeHoursFree(Object hours, Object minutes) {
    return 'Seit $hours Stunden und $minutes Minuten frei';
  }

  @override
  String homeDayN(Object n) {
    return 'Tag $n';
  }

  @override
  String get timerBrokenHint => 'Check-in jetzt — Neustart bei null';

  @override
  String get pattern444 => '4-4-4 Box';

  @override
  String get pattern55 => '5-5 Balance';

  @override
  String get pattern478 => '4-7-8 Tief';

  @override
  String get pattern446 => '4-4-6 Ruhe';

  @override
  String get timerBroken => 'Serie unterbrochen';

  @override
  String get timerNotStarted => 'Check-in startet deinen Timer';

  @override
  String get secondUnit => 'Sek.';

  @override
  String get homeMoneySaved => 'gespart';

  @override
  String get homeCheckIn => 'Heute einchecken';

  @override
  String get homeSOS => 'Verlangen-SOS';

  @override
  String get homeHealthTimeline => 'Deine Erholungs-Zeitachse';

  @override
  String get homeNextMilestone => 'Nächster Meilenstein';

  @override
  String get homeIn => 'in';

  @override
  String get homeRelapse => 'Ich bin rückfällig geworden';

  @override
  String get homeAddHabit => 'Gewohnheit hinzufügen';

  @override
  String get checkinTitle => 'Täglicher Check-in';

  @override
  String get checkinMood => 'Wie fühlst du dich?';

  @override
  String get checkinCraving => 'Verlangen-Stärke';

  @override
  String get checkinTrigger => 'Was war der größte Auslöser?';

  @override
  String get trigger_none => 'Nichts Bestimmtes';

  @override
  String get trigger_stress => 'Stress';

  @override
  String get trigger_social => 'Geselligkeit';

  @override
  String get trigger_boredom => 'Langeweile';

  @override
  String get trigger_habit_loop => 'Alte Routine';

  @override
  String get trigger_negative => 'Schlechte Stimmung';

  @override
  String get trigger_celebration => 'Feiern';

  @override
  String get checkinNote => 'Notiz (optional)';

  @override
  String get checkinDone => 'Gespeichert – bis morgen';

  @override
  String get checkinEditLabel => 'Heutigen Check-in bearbeiten';

  @override
  String get sosTitle => 'Verlangen-SOS';

  @override
  String get sosBody =>
      'Verlangen erreicht nach ein paar Minuten den Höhepunkt und geht vorbei. Du schaffst das.';

  @override
  String get sosBreathing => 'Atme mit mir';

  @override
  String get sosBreatheIn => 'Einatmen';

  @override
  String get sosBreatheOut => 'Ausatmen';

  @override
  String get sosHold => 'Halten';

  @override
  String get sosReasons => 'Erinnere dich, warum du angefangen hast';

  @override
  String get sosDistract => '90-Sekunden-Ablenkung';

  @override
  String get sosDistractBody => 'Tippe das bewegliche Ziel 10-mal';

  @override
  String get sosTapsLeft => 'übrig';

  @override
  String get sosDone => 'Geschafft. Das Verlangen ist vorbei.';

  @override
  String get sosAgain => 'Noch einmal';

  @override
  String get audioUnavailable => 'Audio ist auf diesem Gerät nicht verfügbar';

  @override
  String get chooseAtLeastOne => 'Bitte wähle mindestens eine Gewohnheit';

  @override
  String get dailyAmountLabel => 'Wie viele pro Tag?';

  @override
  String homeStreak(Object days) {
    return '$days Tage Serie';
  }

  @override
  String get rateLater => 'Später';

  @override
  String get statsView7 => '7-Tage-Ansicht';

  @override
  String get sosAmbient => 'Ruhiger Klang';

  @override
  String get ambientFire => 'Lagerfeuer';

  @override
  String get ambientForest => 'Wald';

  @override
  String get ambientOcean => 'Meereswellen';

  @override
  String get ambientRain => 'Regen';

  @override
  String get ambientMusic => 'Spieluhr';

  @override
  String premiumSaveAmount(Object amount) {
    return 'Spare $amount';
  }

  @override
  String get surfingStep3 =>
      'Sie erreicht den Höhepunkt und zieht vorbei. Du bist noch da.';

  @override
  String get surfingStep2 =>
      'Sieh zu, wie es wie eine Welle steigt. Kämpfe nicht, urteile nicht.';

  @override
  String get surfingStep1 =>
      'Spüre das Verlangen in deinem Körper. Wo ist es? Nimm es nur wahr.';

  @override
  String get surfingTitle => 'Auf der Welle reiten';

  @override
  String identityLine(Object days, Object identity) {
    return 'Du bist $identity, Tag $days';
  }

  @override
  String get identity_social => 'frei von Social Media';

  @override
  String get identity_caffeine => 'koffeinfrei';

  @override
  String get identity_sugar => 'zuckerfrei';

  @override
  String get identity_vaping => 'dampffrei';

  @override
  String get identity_alcohol => 'Nichttrinker';

  @override
  String get identity_smoking => 'Nichtraucher';

  @override
  String get relapseRecordRestart =>
      'Ausrutscher notieren und Zähler neu starten';

  @override
  String get relapseRecordKeep => 'Ausrutscher notieren und weitermachen';

  @override
  String onboardingStep(Object step, Object total) {
    return 'Schritt $step/$total';
  }

  @override
  String get plansAction => 'Dann werde ich…';

  @override
  String get plansWhen => 'Wenn…';

  @override
  String get plansAdd => 'Plan hinzufügen';

  @override
  String get plansEmpty =>
      'Schreib auf, was du in Risikomomenten tust — wir zeigen es dir, wenn du es brauchst';

  @override
  String get plansTitle => 'Meine Bewältigungspläne';

  @override
  String insightNoCompare(Object now) {
    return 'Verlangen Ø diese Woche: $now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return 'Verlangen Ø $now/5 vs $prev/5 letzte Woche — täglich dranbleiben zählt';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return 'Verlangen Ø $now/5 diese Woche vs $prev/5 letzte Woche — besser';
  }

  @override
  String get textAuto => 'Automatisch';

  @override
  String get theme_violet => 'Violett';

  @override
  String get theme_sunset => 'Sonnenuntergang';

  @override
  String get theme_rose => 'Rose';

  @override
  String get theme_ocean => 'Ozean';

  @override
  String get theme_forest => 'Wald';

  @override
  String get theme_sage => 'Salbei';

  @override
  String get theme_custom => 'Benutzerdefiniert';

  @override
  String get settingsTextColor => 'Textfarbe';

  @override
  String get settingsFont => 'Schriftart';

  @override
  String get settingsThemes => 'Designs';

  @override
  String get statsView30 => '30-Tage-Ansicht';

  @override
  String get premiumFreeTrial => '7 Tage kostenlos testen';

  @override
  String get deleteAllConfirm =>
      'ALLE Gewohnheiten und ihre gesamte Historie löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get rateAction => 'Im App Store bewerten';

  @override
  String get rateBody =>
      'Deine Bewertung hilft anderen, diese Unterstützung zu finden.';

  @override
  String get rateTitle => 'Gefällt dir DayZero?';

  @override
  String settingsNotificationsTime(Object hour) {
    return 'Ein sanfter Stups täglich um $hour:00 Uhr';
  }

  @override
  String get notifBody =>
      'Wie war dein Tag? Ein kurzer Check-in hält deine Serie am Leben.';

  @override
  String get checkinOfferSos =>
      'Das Verlangen wirkt stark. Brauchst du jetzt Hilfe?';

  @override
  String get settingsReasons => 'Meine Gründe';

  @override
  String get statsTitle => 'Dein Fortschritt';

  @override
  String get statsMood => 'Stimmung';

  @override
  String get statsCraving => 'Verlangen-Stärke';

  @override
  String get statsWeek => 'Diese Woche';

  @override
  String get statsMonth => 'Dieser Monat';

  @override
  String get statsAll => 'Gesamter Zeitraum';

  @override
  String get statsCheckins => 'Check-ins';

  @override
  String get statsStreak => 'Tage Check-in-Serie';

  @override
  String get statsBestStreak => 'beste Serie';

  @override
  String get statsTotalFree => 'freie Tage insgesamt';

  @override
  String get statsWeeklyReport => 'Wochenbericht';

  @override
  String get statsNoData =>
      'Noch nicht genug Daten. Checke täglich ein, um Trends zu sehen.';

  @override
  String get milestonesTitle => 'Meilensteine';

  @override
  String get milestonesUnlocked => 'Erreicht';

  @override
  String get milestonesLocked => 'Kommt noch';

  @override
  String get milestone_1h => 'Erste Stunde';

  @override
  String get milestone_1d => 'Erster Tag';

  @override
  String get milestone_3d => '3 Tage';

  @override
  String get milestone_1w => '1 Woche';

  @override
  String get milestone_2w => '2 Wochen';

  @override
  String get milestone_1m => '1 Monat';

  @override
  String get milestone_3m => '3 Monate';

  @override
  String get milestone_6m => '6 Monate';

  @override
  String get milestone_1y => '1 Jahr';

  @override
  String get milestone_streak7 => '7 Tage Check-in-Serie';

  @override
  String get milestone_streak30 => '30 Tage Check-in-Serie';

  @override
  String get milestone_money1 => 'Erste 100 gespart';

  @override
  String get milestone_money2 => '1.000 gespart';

  @override
  String get milestone_money3 => '10.000 gespart';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsHabits => 'Meine Gewohnheiten';

  @override
  String get settingsEditHabit => 'Bearbeiten';

  @override
  String get settingsDeleteHabit => 'Löschen';

  @override
  String get settingsNotifications => 'Tägliche Check-in-Erinnerung';

  @override
  String get settingsNotificationsDesc => 'Ein sanfter Stups um 20 Uhr';

  @override
  String get settingsExport => 'Meine Daten exportieren';

  @override
  String get settingsExportDesc =>
      'JSON-Backup von allem, gespeichert in Dateien';

  @override
  String get settingsPremium => 'DayZero Premium';

  @override
  String get settingsPremiumActive =>
      'Premium aktiv – danke, dass du eine Indie-App unterstützt';

  @override
  String get settingsRestore => 'Käufe wiederherstellen';

  @override
  String get settingsPrivacy => 'Datenschutzerklärung';

  @override
  String get settingsTerms => 'Nutzungsbedingungen';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsAboutBody =>
      'DayZero wird von einem Indie-Entwickler gemacht. 100 % offline – deine Daten verlassen dieses Gerät nie.';

  @override
  String get settingsReset => 'Startdatum zurücksetzen';

  @override
  String get settingsRelapseReset => 'Zähler neu starten';

  @override
  String get settingsDeleteData => 'Alle Daten löschen';

  @override
  String get deleteHabitConfirm =>
      'Diese Gewohnheit und ihre gesamte Historie löschen?';

  @override
  String get relapseTitle => 'Rückfällig geworden?';

  @override
  String get relapseBody =>
      'Ein Ausrutscher löscht deinen Fortschritt nicht. Starte den Zähler neu oder protokolliere nur das Verlangen und mach weiter.';

  @override
  String get relapseRestart => 'Zähler neu starten';

  @override
  String get relapseKeep => 'Weitermachen';

  @override
  String get premiumTitle => 'DayZero Premium';

  @override
  String get premiumSubtitle => 'Alles, was du brauchst, um frei zu bleiben';

  @override
  String get premiumFeature1 => 'Unbegrenzte Gewohnheiten';

  @override
  String get premiumFeature2 => 'Klanglandschaften (Regen, Meer, Lagerfeuer)';

  @override
  String get premiumFeature3 => 'Designs, Schriftarten & Textfarben';

  @override
  String get premiumFeature4 => 'Auslöser-Analyse: was dich am meisten reizt';

  @override
  String get premiumFreeNote =>
      'Die Gratisversion trackt 2 Gewohnheiten mit Kernstatistiken – für immer, ohne Werbung.';

  @override
  String get premiumWeekly => 'Wöchentlich';

  @override
  String get premiumMonthly => 'Monatlich';

  @override
  String get premiumYearly => 'Jährlich';

  @override
  String get premiumLifetime => 'Lebenslang';

  @override
  String get premiumBestValue => 'BESTES ANGEBOT';

  @override
  String get premiumPerWeek => '/Woche';

  @override
  String get premiumPerMonth => '/Monat';

  @override
  String get premiumPerYear => '/Jahr';

  @override
  String get premiumOnce => 'einmalig';

  @override
  String get premiumSubscribe => 'Weiter';

  @override
  String get premiumRestore => 'Käufe wiederherstellen';

  @override
  String get premiumAutoRenew =>
      'Das Abo verlängert sich automatisch und kann jederzeit in deinen Apple-ID-Einstellungen gekündigt werden – mindestens 24 Stunden vor Ablauf des aktuellen Zeitraums.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'Mit der Fortsetzung stimmst du unseren $terms und der $privacy zu.';
  }

  @override
  String get termsLink => 'Nutzungsbedingungen';

  @override
  String get privacyLink => 'Datenschutzerklärung';

  @override
  String get buying => 'Wird verarbeitet…';

  @override
  String get buyError => 'Kauf fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get restoreDone => 'Käufe wiederhergestellt';

  @override
  String get restoreNothing => 'Keine früheren Käufe gefunden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get save => 'Speichern';

  @override
  String get done => 'Fertig';

  @override
  String get close => 'Schließen';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get demoMode =>
      'Web-Demomodus – Premium ist zum Testen freigeschaltet';

  @override
  String get exportDone => 'Export gespeichert';

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
  String get health_smoking_20m => 'Blutdruck und Puls normalisieren sich';

  @override
  String get health_smoking_8h => 'Kohlenmonoxid im Blut halbiert sich';

  @override
  String get health_smoking_24h => 'Herzinfarktrisiko beginnt zu sinken';

  @override
  String get health_smoking_48h => 'Geschmack und Geruch erholen sich';

  @override
  String get health_smoking_72h => 'Atmen wird spürbar leichter';

  @override
  String get health_smoking_1m =>
      'Durchblutung und Lungenfunktion verbessern sich';

  @override
  String get health_smoking_1y => 'Herzkrankheitsrisiko halbiert sich';

  @override
  String get health_vaping_24h => 'Nikotinverlangen lässt nach';

  @override
  String get health_vaping_48h => 'Atmung und Geschmack erholen sich';

  @override
  String get health_vaping_72h => 'Lungenentzündung klingt ab';

  @override
  String get health_vaping_1w => 'Der körperliche Entzug klingt ab';

  @override
  String get health_vaping_1m => 'Energie und Lungenvolumen verbessern sich';

  @override
  String get health_alcohol_24h => 'Tieferer, erholsamerer Schlaf';

  @override
  String get health_alcohol_48h => 'Der Körper rehydriert, der Kopf wird klar';

  @override
  String get health_alcohol_1w => 'Leberwerte erholen sich';

  @override
  String get health_alcohol_2w => 'Verdauung und Stimmung stabilisieren sich';

  @override
  String get health_alcohol_1m => 'Frischere Haut, besserer Schlaf';

  @override
  String get health_alcohol_3m => 'Leberfett beginnt abzunehmen';

  @override
  String get health_alcohol_1y => 'Die Leber erholt sich deutlich';

  @override
  String get health_sugar_1d => 'Der Blutzucker stabilisiert sich';

  @override
  String get health_sugar_3d => 'Das Verlangen lässt nach';

  @override
  String get health_sugar_2w => 'Die Geschmacksnerven werden empfindlicher';

  @override
  String get health_sugar_1m => 'Die Insulinempfindlichkeit verbessert sich';

  @override
  String get health_sugar_3m => 'Energie und Haut verbessern sich';

  @override
  String get health_caffeine_1d =>
      'Entzug erreicht den Höhepunkt – halte durch';

  @override
  String get health_caffeine_3d => 'Kopfschmerzen lassen nach';

  @override
  String get health_caffeine_1w => 'Schlafqualität verbessert sich';

  @override
  String get health_caffeine_2w => 'Energie bleibt den ganzen Tag stabil';

  @override
  String get health_caffeine_1m => 'Blutdruck sinkt';

  @override
  String get health_social_1d => 'Die Aufmerksamkeitsspanne erholt sich';

  @override
  String get health_social_3d => 'Ängste nehmen ab';

  @override
  String get health_social_1w => 'Schlaf verbessert sich';

  @override
  String get health_social_2w => 'Die Stimmung stabilisiert sich';

  @override
  String get health_social_1m => 'Fokus und Produktivität steigen';

  @override
  String get dayUnit => 'T';

  @override
  String get hourUnit => 'Std.';

  @override
  String get minuteUnit => 'Min.';

  @override
  String get statsTriggerTitle => 'Häufigste Auslöser';

  @override
  String get statsTriggerLocked => 'Premium schaltet die Auslöser-Analyse frei';
}
