// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'Votre compagnon privé pour arrêter';

  @override
  String get onboardingWelcomeTitle =>
      'Un nouveau départ commence aujourd\'hui';

  @override
  String get onboardingWelcomeBody =>
      'Suivez votre parcours en toute confidentialité. Pas de compte, pas de pub, pas de cloud. Tout reste sur votre appareil.';

  @override
  String get onboardingChooseTitle => 'Que voulez-vous arrêter ?';

  @override
  String get onboardingChooseBody =>
      'Choisissez une ou plusieurs habitudes. Vous pourrez en ajouter plus tard.';

  @override
  String get onboardingDateTitle => 'Quel est votre jour J ?';

  @override
  String get onboardingDateBody =>
      'Commencez aujourd\'hui ou choisissez une date future. Si vous démarrez maintenant, le compteur part dès que vous appuyez sur Commencer.';

  @override
  String get onboardingSpendTitle => 'Combien cela vous coûtait-il par jour ?';

  @override
  String get onboardingSpendBody =>
      'Facultatif — sert à calculer votre argent économisé. Modifiable plus tard.';

  @override
  String get perDay => 'par jour';

  @override
  String get currencyPlaceholder => 'Montant';

  @override
  String get onboardingReasonsTitle => 'Pourquoi voulez-vous arrêter ?';

  @override
  String get onboardingReasonsBody =>
      'Écrivez vos raisons. Nous vous les montrerons en cas d\'envie.';

  @override
  String get reasonPlaceholder => 'Ex. : Pour ma famille…';

  @override
  String get addReason => 'Ajouter une autre raison';

  @override
  String get startJourney => 'Commencer mon parcours';

  @override
  String get skip => 'Passer';

  @override
  String get notMedicalAdvice =>
      'DayZero fournit uniquement motivation et suivi — ce n\'est pas un avis médical. En cas de sevrage sévère, consultez un médecin.';

  @override
  String get habit_alcohol => 'Alcool';

  @override
  String get habit_smoking => 'Tabac';

  @override
  String get habit_vaping => 'Vapotage';

  @override
  String get habit_sugar => 'Sucre';

  @override
  String get habit_caffeine => 'Caféine';

  @override
  String get habit_social => 'Réseaux sociaux';

  @override
  String get habit_custom => 'Ma propre habitude';

  @override
  String get customHabitName => 'Comment s\'appelle cette habitude ?';

  @override
  String get homeDaysSince => 'jours libres';

  @override
  String get homeDaysSinceOne => 'jour libre';

  @override
  String get homeTimeFree => 'libre';

  @override
  String get homeMoneySaved => 'économisé';

  @override
  String get homeCheckIn => 'Check-in du jour';

  @override
  String get homeSOS => 'SOS envie';

  @override
  String get homeHealthTimeline => 'Votre chronologie de rétablissement';

  @override
  String get homeNextMilestone => 'Prochain palier';

  @override
  String get homeIn => 'dans';

  @override
  String get homeRelapse => 'J\'ai craqué';

  @override
  String get homeAddHabit => 'Ajouter une habitude';

  @override
  String get checkinTitle => 'Check-in quotidien';

  @override
  String get checkinMood => 'Comment vous sentez-vous ?';

  @override
  String get checkinCraving => 'Intensité de l\'envie';

  @override
  String get checkinTrigger => 'Quel a été le principal déclencheur ?';

  @override
  String get trigger_none => 'Rien de particulier';

  @override
  String get trigger_stress => 'Stress';

  @override
  String get trigger_social => 'Occasions sociales';

  @override
  String get trigger_boredom => 'Ennui';

  @override
  String get trigger_habit_loop => 'Vieille routine';

  @override
  String get trigger_negative => 'Moral en baisse';

  @override
  String get trigger_celebration => 'Fêtes';

  @override
  String get checkinNote => 'Note (facultatif)';

  @override
  String get checkinDone => 'Enregistré — à demain';

  @override
  String get checkinEditLabel => 'Modifier le check-in du jour';

  @override
  String get sosTitle => 'SOS envie';

  @override
  String get sosBody =>
      'L\'envie culmine en quelques minutes puis passe. Vous pouvez tenir.';

  @override
  String get sosBreathing => 'Respirez avec moi';

  @override
  String get sosBreatheIn => 'Inspirez';

  @override
  String get sosBreatheOut => 'Expirez';

  @override
  String get sosHold => 'Retenez';

  @override
  String get sosReasons => 'Souvenez-vous pourquoi vous avez commencé';

  @override
  String get sosDistract => 'Distraction de 90 secondes';

  @override
  String get sosDistractBody => 'Touchez la cible mobile 10 fois';

  @override
  String get sosTapsLeft => 'restants';

  @override
  String get sosDone => 'Vous avez tenu bon. L\'envie est passée.';

  @override
  String get sosAgain => 'Recommencer';

  @override
  String get audioUnavailable => 'Audio indisponible sur cet appareil';

  @override
  String get chooseAtLeastOne => 'Veuillez choisir au moins une habitude';

  @override
  String get dailyAmountLabel => 'Combien par jour ?';

  @override
  String homeStreak(Object days) {
    return 'Série de $days jours';
  }

  @override
  String get rateLater => 'Plus tard';

  @override
  String get statsView7 => 'Vue 7 jours';

  @override
  String get statsView30 => 'Vue 30 jours';

  @override
  String get premiumFreeTrial => '7 jours d\'essai gratuit';

  @override
  String get deleteAllConfirm =>
      'Supprimer TOUTES les habitudes et tout leur historique ? Action irréversible.';

  @override
  String get rateAction => 'Noter sur l\'App Store';

  @override
  String get rateBody =>
      'Votre note aide d\'autres personnes à trouver ce soutien.';

  @override
  String get rateTitle => 'DayZero vous plaît ?';

  @override
  String settingsNotificationsTime(Object hour) {
    return 'Un petit rappel chaque jour à $hour:00';
  }

  @override
  String get notifBody =>
      'Comment s\'est passée votre journée ? Un check-in rapide garde votre série en vie.';

  @override
  String get checkinOfferSos =>
      'Cette envie semble forte. Besoin d\'aide maintenant ?';

  @override
  String get settingsReasons => 'Mes raisons';

  @override
  String get statsTitle => 'Vos progrès';

  @override
  String get statsMood => 'Humeur';

  @override
  String get statsCraving => 'Intensité de l\'envie';

  @override
  String get statsWeek => 'Cette semaine';

  @override
  String get statsMonth => 'Ce mois-ci';

  @override
  String get statsAll => 'Tout';

  @override
  String get statsCheckins => 'check-ins';

  @override
  String get statsStreak => 'jours de check-in consécutifs';

  @override
  String get statsBestStreak => 'meilleure série';

  @override
  String get statsTotalFree => 'jours libres au total';

  @override
  String get statsWeeklyReport => 'Rapport hebdomadaire';

  @override
  String get statsNoData =>
      'Pas encore assez de données. Faites un check-in quotidien pour voir vos tendances.';

  @override
  String get milestonesTitle => 'Paliers';

  @override
  String get milestonesUnlocked => 'Atteints';

  @override
  String get milestonesLocked => 'À venir';

  @override
  String get milestone_1h => 'Première heure';

  @override
  String get milestone_1d => 'Premier jour';

  @override
  String get milestone_3d => '3 jours';

  @override
  String get milestone_1w => '1 semaine';

  @override
  String get milestone_2w => '2 semaines';

  @override
  String get milestone_1m => '1 mois';

  @override
  String get milestone_3m => '3 mois';

  @override
  String get milestone_6m => '6 mois';

  @override
  String get milestone_1y => '1 an';

  @override
  String get milestone_streak7 => '7 jours de check-in consécutifs';

  @override
  String get milestone_streak30 => '30 jours de check-in consécutifs';

  @override
  String get milestone_money1 => '100 économisés';

  @override
  String get milestone_money2 => '1 000 économisés';

  @override
  String get milestone_money3 => '10 000 économisés';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsHabits => 'Mes habitudes';

  @override
  String get settingsEditHabit => 'Modifier';

  @override
  String get settingsDeleteHabit => 'Supprimer';

  @override
  String get settingsNotifications => 'Rappel de check-in quotidien';

  @override
  String get settingsNotificationsDesc => 'Un petit rappel à 20 h';

  @override
  String get settingsExport => 'Exporter mes données';

  @override
  String get settingsExportDesc =>
      'Sauvegarde JSON de tout, enregistrée dans Fichiers';

  @override
  String get settingsPremium => 'DayZero Premium';

  @override
  String get settingsPremiumActive =>
      'Premium actif — merci de soutenir une app indépendante';

  @override
  String get settingsRestore => 'Restaurer les achats';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsSupport => 'Assistance';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsAboutBody =>
      'DayZero est créé par un développeur indépendant. 100 % hors ligne — vos données ne quittent jamais cet appareil.';

  @override
  String get settingsReset => 'Réinitialiser la date de départ';

  @override
  String get settingsRelapseReset => 'Redémarrer le compteur';

  @override
  String get settingsDeleteData => 'Supprimer toutes les données';

  @override
  String get deleteHabitConfirm =>
      'Supprimer cette habitude et tout son historique ?';

  @override
  String get relapseTitle => 'Vous avez craqué ?';

  @override
  String get relapseBody =>
      'Un écart n\'efface pas vos progrès. Redémarrez le compteur, ou notez simplement l\'envie et continuez.';

  @override
  String get relapseRestart => 'Redémarrer le compteur';

  @override
  String get relapseKeep => 'Continuer';

  @override
  String get premiumTitle => 'DayZero Premium';

  @override
  String get premiumSubtitle => 'Tout ce qu\'il faut pour rester libre';

  @override
  String get premiumFeature1 => 'Habitudes illimitées';

  @override
  String get premiumFeature2 =>
      'Statistiques complètes et rapports hebdomadaires';

  @override
  String get premiumFeature3 =>
      'Bibliothèque audio complète d\'exercices de respiration';

  @override
  String get premiumFeature4 => 'Célébrations de paliers et thèmes';

  @override
  String get premiumFreeNote =>
      'La version gratuite suit 2 habitudes avec les statistiques essentielles — pour toujours, sans pub.';

  @override
  String get premiumWeekly => 'Hebdomadaire';

  @override
  String get premiumMonthly => 'Mensuel';

  @override
  String get premiumYearly => 'Annuel';

  @override
  String get premiumLifetime => 'À vie';

  @override
  String get premiumBestValue => 'MEILLEURE OFFRE';

  @override
  String get premiumPerWeek => '/semaine';

  @override
  String get premiumPerMonth => '/mois';

  @override
  String get premiumPerYear => '/an';

  @override
  String get premiumOnce => 'une fois';

  @override
  String get premiumSubscribe => 'Continuer';

  @override
  String get premiumRestore => 'Restaurer les achats';

  @override
  String get premiumAutoRenew =>
      'L\'abonnement se renouvelle automatiquement et peut être annulé à tout moment dans les réglages de votre identifiant Apple, au moins 24 h avant la fin de la période en cours.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'En continuant, vous acceptez nos $terms et notre $privacy.';
  }

  @override
  String get termsLink => 'Conditions d\'utilisation';

  @override
  String get privacyLink => 'Politique de confidentialité';

  @override
  String get buying => 'Traitement…';

  @override
  String get buyError => 'Achat échoué. Veuillez réessayer.';

  @override
  String get restoreDone => 'Achats restaurés';

  @override
  String get restoreNothing => 'Aucun achat antérieur trouvé';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get done => 'Terminé';

  @override
  String get close => 'Fermer';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get demoMode => 'Mode démo web — Premium débloqué pour les tests';

  @override
  String get exportDone => 'Export enregistré';

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
  String get language_system => 'Système';

  @override
  String get health_smoking_20m =>
      'La tension et le rythme cardiaque se normalisent';

  @override
  String get health_smoking_8h =>
      'Le monoxyde de carbone dans le sang diminue de moitié';

  @override
  String get health_smoking_24h =>
      'Le risque de crise cardiaque commence à baisser';

  @override
  String get health_smoking_48h => 'Le goût et l\'odorat se rétablissent';

  @override
  String get health_smoking_72h =>
      'La respiration devient nettement plus facile';

  @override
  String get health_smoking_1m =>
      'La circulation et la fonction pulmonaire s\'améliorent';

  @override
  String get health_smoking_1y =>
      'Le risque de maladie cardiaque est réduit de moitié';

  @override
  String get health_vaping_24h => 'L\'envie de nicotine commence à s\'atténuer';

  @override
  String get health_vaping_48h => 'La respiration et le goût se rétablissent';

  @override
  String get health_vaping_72h =>
      'L\'inflammation pulmonaire commence à diminuer';

  @override
  String get health_vaping_1w => 'L\'essentiel du sevrage physique s\'estompe';

  @override
  String get health_vaping_1m =>
      'L\'énergie et la capacité pulmonaire s\'améliorent';

  @override
  String get health_alcohol_24h => 'Un sommeil plus profond et réparateur';

  @override
  String get health_alcohol_48h =>
      'Le corps se réhydrate, l\'esprit s\'éclaircit';

  @override
  String get health_alcohol_1w =>
      'Les enzymes hépatiques commencent à se rétablir';

  @override
  String get health_alcohol_2w => 'La digestion et l\'humeur se stabilisent';

  @override
  String get health_alcohol_1m => 'Peau plus fraîche, meilleur sommeil';

  @override
  String get health_alcohol_3m => 'La graisse du foie commence à diminuer';

  @override
  String get health_alcohol_1y => 'La guérison du foie progresse nettement';

  @override
  String get health_sugar_1d => 'La glycémie se stabilise';

  @override
  String get health_sugar_3d => 'Les envies commencent à s\'estomper';

  @override
  String get health_sugar_2w => 'Les papilles redeviennent sensibles';

  @override
  String get health_sugar_1m => 'La sensibilité à l\'insuline s\'améliore';

  @override
  String get health_sugar_3m => 'L\'énergie et la peau s\'améliorent';

  @override
  String get health_caffeine_1d => 'Le sevrage est à son pic — tenez bon';

  @override
  String get health_caffeine_3d => 'Les maux de tête s\'atténuent';

  @override
  String get health_caffeine_1w => 'La qualité du sommeil s\'améliore';

  @override
  String get health_caffeine_2w => 'L\'énergie reste stable toute la journée';

  @override
  String get health_caffeine_1m => 'La tension artérielle baisse';

  @override
  String get health_social_1d =>
      'La capacité d\'attention commence à se rétablir';

  @override
  String get health_social_3d => 'L\'anxiété diminue';

  @override
  String get health_social_1w => 'Le sommeil s\'améliore';

  @override
  String get health_social_2w => 'L\'humeur se stabilise';

  @override
  String get health_social_1m =>
      'La concentration et la productivité augmentent';

  @override
  String get dayUnit => 'j';

  @override
  String get hourUnit => 'h';

  @override
  String get minuteUnit => 'min';
}
