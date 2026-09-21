// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'Il tuo compagno privato per smettere';

  @override
  String get onboardingWelcomeTitle => 'Un nuovo inizio parte da oggi';

  @override
  String get onboardingWelcomeBody =>
      'Segui il tuo percorso in privato. Niente account, niente pubblicità, niente cloud. Tutto resta sul tuo dispositivo.';

  @override
  String get onboardingChooseTitle => 'Cosa vuoi smettere?';

  @override
  String get onboardingChooseBody =>
      'Scegli una o più abitudini. Potrai aggiungerne altre in seguito.';

  @override
  String get onboardingDateTitle => 'Quando è il tuo giorno zero?';

  @override
  String get onboardingDateBody =>
      'Puoi iniziare oggi o scegliere una data futura. Se inizi ora, il contatore parte dal momento in cui premi Inizia.';

  @override
  String get onboardingSpendTitle => 'Quanto ti costava al giorno?';

  @override
  String get onboardingSpendBody =>
      'Facoltativo: serve a calcolare i soldi risparmiati. Puoi modificarlo più tardi.';

  @override
  String get perDay => 'al giorno';

  @override
  String get currencyPlaceholder => 'Importo';

  @override
  String get onboardingReasonsTitle => 'Perché vuoi smettere?';

  @override
  String get onboardingReasonsBody =>
      'Scrivi i tuoi motivi. Te li mostreremo quando arriva il desiderio.';

  @override
  String get reasonPlaceholder => 'Es.: Per la mia famiglia…';

  @override
  String get addReason => 'Aggiungi un altro motivo';

  @override
  String get startJourney => 'Inizia il mio percorso';

  @override
  String get skip => 'Salta';

  @override
  String get notMedicalAdvice =>
      'DayZero offre solo motivazione e monitoraggio: non è un consiglio medico. In caso di astinenza grave, consulta un medico.';

  @override
  String get habit_alcohol => 'Alcol';

  @override
  String get habit_smoking => 'Fumo';

  @override
  String get habit_vaping => 'Svapo';

  @override
  String get habit_sugar => 'Zucchero';

  @override
  String get habit_caffeine => 'Caffeina';

  @override
  String get habit_social => 'Social media';

  @override
  String get habit_custom => 'Una mia abitudine';

  @override
  String get customHabitName => 'Come si chiama l\'abitudine?';

  @override
  String get homeDaysSince => 'giorni libero';

  @override
  String get homeDaysSinceOne => 'giorno libero';

  @override
  String get homeTimeFree => 'libero';

  @override
  String get homeMoneySaved => 'risparmiati';

  @override
  String get homeCheckIn => 'Check-in di oggi';

  @override
  String get homeSOS => 'SOS desiderio';

  @override
  String get homeHealthTimeline => 'La tua linea di recupero';

  @override
  String get homeNextMilestone => 'Prossimo traguardo';

  @override
  String get homeIn => 'tra';

  @override
  String get homeRelapse => 'Ho avuto una ricaduta';

  @override
  String get homeAddHabit => 'Aggiungi abitudine';

  @override
  String get checkinTitle => 'Check-in giornaliero';

  @override
  String get checkinMood => 'Come ti senti?';

  @override
  String get checkinCraving => 'Intensità del desiderio';

  @override
  String get checkinTrigger => 'Qual è stato il fattore scatenante?';

  @override
  String get trigger_none => 'Niente in particolare';

  @override
  String get trigger_stress => 'Stress';

  @override
  String get trigger_social => 'Situazioni sociali';

  @override
  String get trigger_boredom => 'Noia';

  @override
  String get trigger_habit_loop => 'Vecchia routine';

  @override
  String get trigger_negative => 'Umore giù';

  @override
  String get trigger_celebration => 'Feste';

  @override
  String get checkinNote => 'Nota (facoltativa)';

  @override
  String get checkinDone => 'Salvato: a domani';

  @override
  String get checkinEditLabel => 'Modifica il check-in di oggi';

  @override
  String get sosTitle => 'SOS desiderio';

  @override
  String get sosBody =>
      'Il desiderio raggiunge il picco in pochi minuti e poi passa. Puoi farcela.';

  @override
  String get sosBreathing => 'Respira con me';

  @override
  String get sosBreatheIn => 'Inspira';

  @override
  String get sosBreatheOut => 'Espira';

  @override
  String get sosHold => 'Trattieni';

  @override
  String get sosReasons => 'Ricorda perché hai iniziato';

  @override
  String get sosDistract => 'Distrazione di 90 secondi';

  @override
  String get sosDistractBody => 'Tocca il bersaglio in movimento 10 volte';

  @override
  String get sosTapsLeft => 'rimasti';

  @override
  String get sosDone => 'Ce l\'hai fatta. Il desiderio è passato.';

  @override
  String get sosAgain => 'Ancora';

  @override
  String get audioUnavailable => 'Audio non disponibile su questo dispositivo';

  @override
  String get chooseAtLeastOne => 'Scegli almeno un\'abitudine';

  @override
  String get dailyAmountLabel => 'Quanti al giorno?';

  @override
  String homeStreak(Object days) {
    return 'Serie di $days giorni';
  }

  @override
  String get rateLater => 'Più tardi';

  @override
  String get statsView7 => 'Vista 7 giorni';

  @override
  String get sosAmbient => 'Ambiente rilassante';

  @override
  String premiumSaveAmount(Object amount) {
    return 'Risparmia $amount';
  }

  @override
  String get relapseRecordRestart =>
      'Registra la ricaduta e riavvia il contatore';

  @override
  String get relapseRecordKeep => 'Registra la ricaduta e continua';

  @override
  String onboardingStep(Object step, Object total) {
    return 'Passo $step/$total';
  }

  @override
  String get plansAction => 'Io farò…';

  @override
  String get plansWhen => 'Quando…';

  @override
  String get plansAdd => 'Aggiungi piano';

  @override
  String get plansEmpty =>
      'Scrivi cosa farai nei momenti a rischio — lo mostreremo quando servirà';

  @override
  String get plansTitle => 'I miei piani d\'azione';

  @override
  String insightNoCompare(Object now) {
    return 'Desiderio medio questa settimana: $now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return 'Desiderio medio $now/5 vs $prev/5 — esserci ogni giorno è ciò che conta';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return 'Desiderio medio $now/5 questa settimana vs $prev/5 — meglio';
  }

  @override
  String get textAuto => 'Automatico';

  @override
  String get theme_violet => 'Viola';

  @override
  String get theme_sunset => 'Tramonto';

  @override
  String get theme_rose => 'Rosa';

  @override
  String get theme_ocean => 'Oceano';

  @override
  String get theme_forest => 'Foresta';

  @override
  String get theme_sage => 'Salvia';

  @override
  String get theme_custom => 'Personalizzato';

  @override
  String get settingsTextColor => 'Colore del testo';

  @override
  String get settingsFont => 'Carattere';

  @override
  String get settingsThemes => 'Temi';

  @override
  String get statsView30 => 'Vista 30 giorni';

  @override
  String get premiumFreeTrial => '7 giorni di prova gratuita';

  @override
  String get deleteAllConfirm =>
      'Eliminare TUTTE le abitudini e tutta la loro cronologia? Non è reversibile.';

  @override
  String get rateAction => 'Valuta sull\'App Store';

  @override
  String get rateBody =>
      'La tua valutazione aiuta altre persone a trovare questo supporto.';

  @override
  String get rateTitle => 'Ti piace DayZero?';

  @override
  String settingsNotificationsTime(Object hour) {
    return 'Una spinta gentile ogni giorno alle $hour:00';
  }

  @override
  String get notifBody =>
      'Com\'è andata oggi? Un check-in rapido mantiene viva la tua serie.';

  @override
  String get checkinOfferSos =>
      'Il desiderio sembra forte. Ti serve aiuto adesso?';

  @override
  String get settingsReasons => 'Le mie ragioni';

  @override
  String get statsTitle => 'I tuoi progressi';

  @override
  String get statsMood => 'Umore';

  @override
  String get statsCraving => 'Intensità del desiderio';

  @override
  String get statsWeek => 'Questa settimana';

  @override
  String get statsMonth => 'Questo mese';

  @override
  String get statsAll => 'Sempre';

  @override
  String get statsCheckins => 'check-in';

  @override
  String get statsStreak => 'giorni di check-in consecutivi';

  @override
  String get statsBestStreak => 'record';

  @override
  String get statsTotalFree => 'giorni liberi in totale';

  @override
  String get statsWeeklyReport => 'Report settimanale';

  @override
  String get statsNoData =>
      'Dati non ancora sufficienti. Fai il check-in ogni giorno per vedere le tendenze.';

  @override
  String get milestonesTitle => 'Traguardi';

  @override
  String get milestonesUnlocked => 'Raggiunti';

  @override
  String get milestonesLocked => 'In arrivo';

  @override
  String get milestone_1h => 'Prima ora';

  @override
  String get milestone_1d => 'Primo giorno';

  @override
  String get milestone_3d => '3 giorni';

  @override
  String get milestone_1w => '1 settimana';

  @override
  String get milestone_2w => '2 settimane';

  @override
  String get milestone_1m => '1 mese';

  @override
  String get milestone_3m => '3 mesi';

  @override
  String get milestone_6m => '6 mesi';

  @override
  String get milestone_1y => '1 anno';

  @override
  String get milestone_streak7 => '7 giorni di check-in consecutivi';

  @override
  String get milestone_streak30 => '30 giorni di check-in consecutivi';

  @override
  String get milestone_money1 => 'Primi 100 risparmiati';

  @override
  String get milestone_money2 => '1.000 risparmiati';

  @override
  String get milestone_money3 => '10.000 risparmiati';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsHabits => 'Le mie abitudini';

  @override
  String get settingsEditHabit => 'Modifica';

  @override
  String get settingsDeleteHabit => 'Elimina';

  @override
  String get settingsNotifications => 'Promemoria check-in giornaliero';

  @override
  String get settingsNotificationsDesc => 'Una spinta gentile alle 20:00';

  @override
  String get settingsExport => 'Esporta i miei dati';

  @override
  String get settingsExportDesc => 'Backup JSON di tutto, salvato in File';

  @override
  String get settingsPremium => 'DayZero Premium';

  @override
  String get settingsPremiumActive =>
      'Premium attivo: grazie per sostenere un\'app indipendente';

  @override
  String get settingsRestore => 'Ripristina acquisti';

  @override
  String get settingsPrivacy => 'Informativa sulla privacy';

  @override
  String get settingsTerms => 'Termini di utilizzo';

  @override
  String get settingsSupport => 'Supporto';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get settingsAboutBody =>
      'DayZero è creato da uno sviluppatore indipendente. 100% offline: i tuoi dati non lasciano mai questo dispositivo.';

  @override
  String get settingsReset => 'Reimposta data di inizio';

  @override
  String get settingsRelapseReset => 'Riavvia il contatore';

  @override
  String get settingsDeleteData => 'Elimina tutti i dati';

  @override
  String get deleteHabitConfirm =>
      'Eliminare questa abitudine e tutta la sua cronologia?';

  @override
  String get relapseTitle => 'Hai avuto una ricaduta?';

  @override
  String get relapseBody =>
      'Uno scivolone non cancella i tuoi progressi. Riavvia il contatore o registra solo il desiderio e continua.';

  @override
  String get relapseRestart => 'Riavvia contatore';

  @override
  String get relapseKeep => 'Continua';

  @override
  String get premiumTitle => 'DayZero Premium';

  @override
  String get premiumSubtitle => 'Tutto ciò che serve per restare libero';

  @override
  String get premiumFeature1 => 'Abitudini illimitate';

  @override
  String get premiumFeature2 => 'Libreria audio completa di respirazione';

  @override
  String get premiumFeature3 => 'Temi, font e colori del testo';

  @override
  String get premiumFeature4 => 'Cerimonie di celebrazione';

  @override
  String get premiumFreeNote =>
      'La versione gratuita segue 2 abitudini con le statistiche essenziali, per sempre e senza pubblicità.';

  @override
  String get premiumWeekly => 'Settimanale';

  @override
  String get premiumMonthly => 'Mensile';

  @override
  String get premiumYearly => 'Annuale';

  @override
  String get premiumLifetime => 'A vita';

  @override
  String get premiumBestValue => 'OFFERTA MIGLIORE';

  @override
  String get premiumPerWeek => '/settimana';

  @override
  String get premiumPerMonth => '/mese';

  @override
  String get premiumPerYear => '/anno';

  @override
  String get premiumOnce => 'una volta';

  @override
  String get premiumSubscribe => 'Continua';

  @override
  String get premiumRestore => 'Ripristina acquisti';

  @override
  String get premiumAutoRenew =>
      'L\'abbonamento si rinnova automaticamente e può essere annullato in qualsiasi momento nelle impostazioni del tuo ID Apple, almeno 24 ore prima della fine del periodo corrente.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'Continuando accetti i nostri $terms e la nostra $privacy.';
  }

  @override
  String get termsLink => 'Termini di utilizzo';

  @override
  String get privacyLink => 'Informativa sulla privacy';

  @override
  String get buying => 'Elaborazione…';

  @override
  String get buyError => 'Acquisto non riuscito. Riprova.';

  @override
  String get restoreDone => 'Acquisti ripristinati';

  @override
  String get restoreNothing => 'Nessun acquisto precedente trovato';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get save => 'Salva';

  @override
  String get done => 'Fatto';

  @override
  String get close => 'Chiudi';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get demoMode => 'Modalità demo web: Premium sbloccato per i test';

  @override
  String get exportDone => 'Esportazione salvata';

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
  String get language_system => 'Sistema';

  @override
  String get health_smoking_20m =>
      'Pressione e battito iniziano a normalizzarsi';

  @override
  String get health_smoking_8h =>
      'Il monossido di carbonio nel sangue si dimezza';

  @override
  String get health_smoking_24h => 'Il rischio di infarto inizia a scendere';

  @override
  String get health_smoking_48h => 'Gusto e olfatto iniziano a recuperare';

  @override
  String get health_smoking_72h => 'Respirare diventa notevolmente più facile';

  @override
  String get health_smoking_1m =>
      'Migliorano circolazione e funzione polmonare';

  @override
  String get health_smoking_1y => 'Il rischio di malattie cardiache si dimezza';

  @override
  String get health_vaping_24h => 'Il desiderio di nicotina inizia a diminuire';

  @override
  String get health_vaping_48h => 'Respirazione e gusto iniziano a recuperare';

  @override
  String get health_vaping_72h =>
      'L\'infiammazione polmonare inizia a diminuire';

  @override
  String get health_vaping_1w => 'L\'astinenza fisica svanisce quasi del tutto';

  @override
  String get health_vaping_1m => 'Migliorano energia e capacità polmonare';

  @override
  String get health_alcohol_24h => 'Sonno più profondo e ristoratore';

  @override
  String get health_alcohol_48h =>
      'Il corpo si reidrata, la mente si schiarisce';

  @override
  String get health_alcohol_1w => 'Gli enzimi del fegato iniziano a recuperare';

  @override
  String get health_alcohol_2w => 'Digestione e umore si stabilizzano';

  @override
  String get health_alcohol_1m => 'Pelle più fresca e sonno migliore';

  @override
  String get health_alcohol_3m => 'Il grasso nel fegato inizia a diminuire';

  @override
  String get health_alcohol_1y => 'Il recupero del fegato progredisce molto';

  @override
  String get health_sugar_1d => 'La glicemia si stabilizza';

  @override
  String get health_sugar_3d => 'Il desiderio inizia a svanire';

  @override
  String get health_sugar_2w => 'Le papille gustative tornano sensibili';

  @override
  String get health_sugar_1m => 'Migliora la sensibilità all\'insulina';

  @override
  String get health_sugar_3m => 'Migliorano energia e pelle';

  @override
  String get health_caffeine_1d => 'L\'astinenza raggiunge il picco: resisti';

  @override
  String get health_caffeine_3d => 'Il mal di testa inizia a diminuire';

  @override
  String get health_caffeine_1w => 'Migliora la qualità del sonno';

  @override
  String get health_caffeine_2w => 'L\'energia resta stabile tutto il giorno';

  @override
  String get health_caffeine_1m => 'La pressione si abbassa';

  @override
  String get health_social_1d =>
      'La capacità di attenzione inizia a recuperare';

  @override
  String get health_social_3d => 'L\'ansia diminuisce';

  @override
  String get health_social_1w => 'Il sonno migliora';

  @override
  String get health_social_2w => 'L\'umore si stabilizza';

  @override
  String get health_social_1m => 'Aumentano concentrazione e produttività';

  @override
  String get dayUnit => 'gg';

  @override
  String get hourUnit => 'h';

  @override
  String get minuteUnit => 'min';
}
