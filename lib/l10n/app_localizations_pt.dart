// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'Seu companheiro privado para parar';

  @override
  String get onboardingWelcomeTitle => 'Um recomeço começa hoje';

  @override
  String get onboardingWelcomeBody =>
      'Acompanhe sua jornada com privacidade. Sem conta, sem anúncios, sem nuvem. Tudo fica no seu dispositivo.';

  @override
  String get onboardingChooseTitle => 'O que você quer parar?';

  @override
  String get onboardingChooseBody =>
      'Escolha um ou mais hábitos. Você pode adicionar mais depois.';

  @override
  String get onboardingDateTitle => 'Quando é o seu dia zero?';

  @override
  String get onboardingDateBody =>
      'Você pode começar hoje ou escolher uma data futura. Começando agora, o contador vale a partir do toque em Começar.';

  @override
  String get onboardingSpendTitle => 'Quanto isso custava por dia?';

  @override
  String get onboardingSpendBody =>
      'Opcional — usamos para calcular o dinheiro economizado. Dá para editar depois.';

  @override
  String get perDay => 'por dia';

  @override
  String get currencyPlaceholder => 'Valor';

  @override
  String get onboardingReasonsTitle => 'Por que você quer parar?';

  @override
  String get onboardingReasonsBody =>
      'Escreva seus motivos. Mostraremos quando a fissura vier.';

  @override
  String get reasonPlaceholder => 'Ex.: Pela minha família…';

  @override
  String get addReason => 'Adicionar outro motivo';

  @override
  String get startJourney => 'Começar minha jornada';

  @override
  String get skip => 'Pular';

  @override
  String get notMedicalAdvice =>
      'O DayZero oferece apenas motivação e registro — não é aconselhamento médico. Em caso de abstinência grave, consulte um médico.';

  @override
  String get habit_alcohol => 'Álcool';

  @override
  String get habit_smoking => 'Cigarro';

  @override
  String get habit_vaping => 'Vape';

  @override
  String get habit_sugar => 'Açúcar';

  @override
  String get habit_caffeine => 'Cafeína';

  @override
  String get habit_social => 'Redes sociais';

  @override
  String get habit_custom => 'Meu próprio hábito';

  @override
  String get customHabitName => 'Qual é o nome do hábito?';

  @override
  String get homeDaysSince => 'dias livre';

  @override
  String get homeDaysSinceOne => 'dia livre';

  @override
  String get homeTimeFree => 'livre';

  @override
  String get homeMoneySaved => 'economizado';

  @override
  String get homeCheckIn => 'Registrar hoje';

  @override
  String get homeSOS => 'SOS fissura';

  @override
  String get homeHealthTimeline => 'Sua linha do tempo de recuperação';

  @override
  String get homeNextMilestone => 'Próximo marco';

  @override
  String get homeIn => 'em';

  @override
  String get homeRelapse => 'Tive uma recaída';

  @override
  String get homeAddHabit => 'Adicionar hábito';

  @override
  String get checkinTitle => 'Registro diário';

  @override
  String get checkinMood => 'Como você se sente?';

  @override
  String get checkinCraving => 'Intensidade da fissura';

  @override
  String get checkinTrigger => 'Qual foi o maior gatilho?';

  @override
  String get trigger_none => 'Nada em especial';

  @override
  String get trigger_stress => 'Estresse';

  @override
  String get trigger_social => 'Situações sociais';

  @override
  String get trigger_boredom => 'Tédio';

  @override
  String get trigger_habit_loop => 'Rotina antiga';

  @override
  String get trigger_negative => 'Mau humor';

  @override
  String get trigger_celebration => 'Comemorações';

  @override
  String get checkinNote => 'Nota (opcional)';

  @override
  String get checkinDone => 'Salvo — até amanhã';

  @override
  String get sosTitle => 'SOS fissura';

  @override
  String get sosBody =>
      'A fissura atinge o pico em poucos minutos e depois passa. Você consegue aguentar.';

  @override
  String get sosBreathing => 'Respire comigo';

  @override
  String get sosBreatheIn => 'Inspire';

  @override
  String get sosBreatheOut => 'Expire';

  @override
  String get sosHold => 'Segure';

  @override
  String get sosReasons => 'Lembre por que você começou';

  @override
  String get sosDistract => 'Distração de 90 segundos';

  @override
  String get sosDistractBody => 'Toque no alvo em movimento 10 vezes';

  @override
  String get sosTapsLeft => 'restantes';

  @override
  String get sosDone => 'Você conseguiu. A fissura passou.';

  @override
  String get sosAgain => 'De novo';

  @override
  String get statsTitle => 'Seu progresso';

  @override
  String get statsMood => 'Humor';

  @override
  String get statsCraving => 'Intensidade da fissura';

  @override
  String get statsWeek => 'Esta semana';

  @override
  String get statsMonth => 'Este mês';

  @override
  String get statsAll => 'Todo o período';

  @override
  String get statsCheckins => 'registros';

  @override
  String get statsStreak => 'dias de registro consecutivos';

  @override
  String get statsBestStreak => 'melhor sequência';

  @override
  String get statsTotalFree => 'dias livres no total';

  @override
  String get statsWeeklyReport => 'Relatório semanal';

  @override
  String get statsNoData =>
      'Ainda não há dados suficientes. Registre diariamente para ver suas tendências.';

  @override
  String get milestonesTitle => 'Marcos';

  @override
  String get milestonesUnlocked => 'Conquistados';

  @override
  String get milestonesLocked => 'Em breve';

  @override
  String get milestone_1h => 'Primeira hora';

  @override
  String get milestone_1d => 'Primeiro dia';

  @override
  String get milestone_3d => '3 dias';

  @override
  String get milestone_1w => '1 semana';

  @override
  String get milestone_2w => '2 semanas';

  @override
  String get milestone_1m => '1 mês';

  @override
  String get milestone_3m => '3 meses';

  @override
  String get milestone_6m => '6 meses';

  @override
  String get milestone_1y => '1 ano';

  @override
  String get milestone_streak7 => '7 dias de registro consecutivos';

  @override
  String get milestone_streak30 => '30 dias de registro consecutivos';

  @override
  String get milestone_money1 => 'Primeiros 100 economizados';

  @override
  String get milestone_money2 => '1.000 economizados';

  @override
  String get milestone_money3 => '10.000 economizados';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsHabits => 'Meus hábitos';

  @override
  String get settingsEditHabit => 'Editar';

  @override
  String get settingsDeleteHabit => 'Excluir';

  @override
  String get settingsNotifications => 'Lembrete diário de registro';

  @override
  String get settingsNotificationsDesc => 'Um toque gentil às 20h';

  @override
  String get settingsExport => 'Exportar meus dados';

  @override
  String get settingsExportDesc => 'Backup JSON de tudo, salvo em Arquivos';

  @override
  String get settingsPremium => 'DayZero Premium';

  @override
  String get settingsPremiumActive =>
      'Premium ativo — obrigado por apoiar um app independente';

  @override
  String get settingsRestore => 'Restaurar compras';

  @override
  String get settingsPrivacy => 'Política de privacidade';

  @override
  String get settingsTerms => 'Termos de uso';

  @override
  String get settingsSupport => 'Suporte';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsAboutBody =>
      'O DayZero é feito por um desenvolvedor independente. 100% offline — seus dados nunca saem deste dispositivo.';

  @override
  String get settingsReset => 'Redefinir data de início';

  @override
  String get settingsRelapseReset => 'Reiniciar o contador';

  @override
  String get settingsDeleteData => 'Apagar todos os dados';

  @override
  String get deleteHabitConfirm => 'Excluir este hábito e todo o histórico?';

  @override
  String get relapseTitle => 'Recaiu?';

  @override
  String get relapseBody =>
      'Um deslize não apaga seu progresso. Reinicie o contador ou apenas registre a fissura e siga em frente.';

  @override
  String get relapseRestart => 'Reiniciar contador';

  @override
  String get relapseKeep => 'Seguir em frente';

  @override
  String get premiumTitle => 'DayZero Premium';

  @override
  String get premiumSubtitle => 'Tudo o que você precisa para continuar livre';

  @override
  String get premiumFeature1 => 'Hábitos ilimitados';

  @override
  String get premiumFeature2 => 'Estatísticas completas e relatórios semanais';

  @override
  String get premiumFeature3 => 'Biblioteca completa de áudios de respiração';

  @override
  String get premiumFeature4 => 'Celebrações de marcos e temas';

  @override
  String get premiumFreeNote =>
      'A versão gratuita acompanha 2 hábitos com estatísticas essenciais — para sempre, sem anúncios.';

  @override
  String get premiumWeekly => 'Semanal';

  @override
  String get premiumMonthly => 'Mensal';

  @override
  String get premiumYearly => 'Anual';

  @override
  String get premiumLifetime => 'Vitalício';

  @override
  String get premiumBestValue => 'MELHOR OFERTA';

  @override
  String get premiumPerWeek => '/semana';

  @override
  String get premiumPerMonth => '/mês';

  @override
  String get premiumPerYear => '/ano';

  @override
  String get premiumOnce => 'uma vez';

  @override
  String get premiumSubscribe => 'Continuar';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumAutoRenew =>
      'A assinatura renova automaticamente e pode ser cancelada a qualquer momento nos ajustes do seu ID Apple, pelo menos 24 horas antes do fim do período atual.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'Ao continuar, você concorda com nossos $terms e nossa $privacy.';
  }

  @override
  String get termsLink => 'Termos de uso';

  @override
  String get privacyLink => 'Política de privacidade';

  @override
  String get buying => 'Processando…';

  @override
  String get buyError => 'Falha na compra. Tente novamente.';

  @override
  String get restoreDone => 'Compras restauradas';

  @override
  String get restoreNothing => 'Nenhuma compra anterior encontrada';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Salvar';

  @override
  String get done => 'Concluído';

  @override
  String get close => 'Fechar';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get demoMode => 'Modo demo web — Premium desbloqueado para testes';

  @override
  String get exportDone => 'Exportação salva';

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
      'A pressão e os batimentos começam a normalizar';

  @override
  String get health_smoking_8h =>
      'O monóxido de carbono no sangue cai pela metade';

  @override
  String get health_smoking_24h => 'O risco de infarto começa a cair';

  @override
  String get health_smoking_48h => 'O paladar e o olfato começam a voltar';

  @override
  String get health_smoking_72h => 'Respirar fica bem mais fácil';

  @override
  String get health_smoking_1m => 'Melhoram a circulação e a função pulmonar';

  @override
  String get health_smoking_1y => 'O risco de doença cardíaca cai pela metade';

  @override
  String get health_vaping_24h => 'A fissura de nicotina começa a diminuir';

  @override
  String get health_vaping_48h => 'A respiração e o paladar se recuperam';

  @override
  String get health_vaping_72h => 'A inflamação pulmonar começa a diminuir';

  @override
  String get health_vaping_1w => 'A maior parte da abstinência física passa';

  @override
  String get health_vaping_1m => 'Melhoram a energia e a capacidade pulmonar';

  @override
  String get health_alcohol_24h => 'Sono mais profundo e reparador';

  @override
  String get health_alcohol_48h => 'O corpo se reidrata e a mente clareia';

  @override
  String get health_alcohol_1w => 'As enzimas do fígado começam a se recuperar';

  @override
  String get health_alcohol_2w => 'A digestão e o humor se estabilizam';

  @override
  String get health_alcohol_1m => 'Pele mais fresca e sono melhor';

  @override
  String get health_alcohol_3m => 'A gordura do fígado começa a diminuir';

  @override
  String get health_alcohol_1y => 'A recuperação do fígado avança bastante';

  @override
  String get health_sugar_1d => 'O açúcar no sangue se estabiliza';

  @override
  String get health_sugar_3d => 'A fissura começa a diminuir';

  @override
  String get health_sugar_2w => 'O paladar fica mais sensível';

  @override
  String get health_sugar_1m => 'Melhora a sensibilidade à insulina';

  @override
  String get health_sugar_3m => 'Melhoram a energia e a pele';

  @override
  String get health_caffeine_1d =>
      'A abstinência atinge o pico — aguente firme';

  @override
  String get health_caffeine_3d => 'As dores de cabeça começam a passar';

  @override
  String get health_caffeine_1w => 'Melhora a qualidade do sono';

  @override
  String get health_caffeine_2w => 'A energia fica estável o dia todo';

  @override
  String get health_caffeine_1m => 'A pressão arterial cai';

  @override
  String get health_social_1d => 'A capacidade de atenção começa a voltar';

  @override
  String get health_social_3d => 'A ansiedade diminui';

  @override
  String get health_social_1w => 'O sono melhora';

  @override
  String get health_social_2w => 'O humor se estabiliza';

  @override
  String get health_social_1m => 'Aumentam o foco e a produtividade';

  @override
  String get dayUnit => 'd';

  @override
  String get hourUnit => 'h';

  @override
  String get minuteUnit => 'min';
}
