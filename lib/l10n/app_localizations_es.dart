// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'Tu compañero privado para dejarlo';

  @override
  String get onboardingWelcomeTitle => 'Un nuevo comienzo empieza hoy';

  @override
  String get onboardingWelcomeBody =>
      'Sigue tu camino en privado. Sin cuenta, sin anuncios, sin nube. Todo se queda en tu dispositivo.';

  @override
  String get onboardingChooseTitle => '¿Qué quieres dejar?';

  @override
  String get onboardingChooseBody =>
      'Elige uno o varios hábitos. Puedes añadir más después.';

  @override
  String get onboardingDateTitle => '¿Cuándo es tu día cero?';

  @override
  String get onboardingDateBody =>
      'Puedes empezar hoy o elegir una fecha futura. Si empiezas ahora, el contador corre desde que pulsas Empezar.';

  @override
  String get onboardingSpendTitle => '¿Cuánto te costaba al día?';

  @override
  String get onboardingSpendBody =>
      'Opcional: lo usamos para calcular el dinero que ahorras. Puedes cambiarlo después.';

  @override
  String get perDay => 'al día';

  @override
  String get currencyPlaceholder => 'Importe';

  @override
  String get onboardingReasonsTitle => '¿Por qué quieres dejarlo?';

  @override
  String get onboardingReasonsBody =>
      'Escribe tus motivos. Te los mostraremos cuando llegue el antojo.';

  @override
  String get reasonPlaceholder => 'Ej.: Por mi familia…';

  @override
  String get addReason => 'Añadir otro motivo';

  @override
  String get startJourney => 'Empezar mi camino';

  @override
  String get skip => 'Saltar';

  @override
  String get notMedicalAdvice =>
      'DayZero solo ofrece motivación y seguimiento; no es consejo médico. Ante un síndrome de abstinencia grave, consulta a un médico.';

  @override
  String get habit_alcohol => 'Alcohol';

  @override
  String get habit_smoking => 'Tabaco';

  @override
  String get habit_vaping => 'Vapeo';

  @override
  String get habit_sugar => 'Azúcar';

  @override
  String get habit_caffeine => 'Cafeína';

  @override
  String get habit_social => 'Redes sociales';

  @override
  String get habit_custom => 'Mi propio hábito';

  @override
  String get customHabitName => '¿Cómo se llama el hábito?';

  @override
  String get homeDaysSince => 'días libre';

  @override
  String get homeDaysSinceOne => 'día libre';

  @override
  String get homeTimeFree => 'libre';

  @override
  String homeHoursFree(Object hours, Object minutes) {
    return 'Libre desde hace $hours h y $minutes min';
  }

  @override
  String homeDayN(Object n) {
    return 'Día $n';
  }

  @override
  String get timerBrokenHint => 'Regístrate ya para reiniciar desde cero';

  @override
  String get pattern444 => '4-4-4 Caja';

  @override
  String get pattern55 => '5-5 Equilibrada';

  @override
  String get pattern478 => '4-7-8 Profunda';

  @override
  String get pattern446 => '4-4-6 Calma';

  @override
  String get timerBroken => 'Racha interrumpida';

  @override
  String get timerNotStarted => 'Regístrate para iniciar tu cronómetro';

  @override
  String get secondUnit => 's';

  @override
  String get homeMoneySaved => 'ahorrado';

  @override
  String get homeCheckIn => 'Registrarme hoy';

  @override
  String get homeSOS => 'SOS antojo';

  @override
  String get homeHealthTimeline => 'Tu cronología de recuperación';

  @override
  String get homeNextMilestone => 'Próximo hito';

  @override
  String get homeIn => 'en';

  @override
  String get homeRelapse => 'He recaído';

  @override
  String get homeAddHabit => 'Añadir hábito';

  @override
  String get checkinTitle => 'Registro diario';

  @override
  String get checkinMood => '¿Cómo te sientes?';

  @override
  String get checkinCraving => 'Intensidad del antojo';

  @override
  String get checkinTrigger => '¿Cuál fue el mayor desencadenante?';

  @override
  String get trigger_none => 'Nada en particular';

  @override
  String get trigger_stress => 'Estrés';

  @override
  String get trigger_social => 'Situaciones sociales';

  @override
  String get trigger_boredom => 'Aburrimiento';

  @override
  String get trigger_habit_loop => 'Rutina de siempre';

  @override
  String get trigger_negative => 'Bajón de ánimo';

  @override
  String get trigger_celebration => 'Celebraciones';

  @override
  String get checkinNote => 'Nota (opcional)';

  @override
  String get checkinDone => 'Guardado. ¡Hasta mañana!';

  @override
  String get checkinEditLabel => 'Editar el registro de hoy';

  @override
  String get sosTitle => 'SOS antojo';

  @override
  String get sosBody =>
      'El antojo alcanza su pico en unos minutos y luego pasa. Puedes superarlo.';

  @override
  String get sosBreathing => 'Respira conmigo';

  @override
  String get sosBreatheIn => 'Inspira';

  @override
  String get sosBreatheOut => 'Espira';

  @override
  String get sosHold => 'Aguanta';

  @override
  String get sosReasons => 'Recuerda por qué empezaste';

  @override
  String get sosDistract => 'Distracción de 90 segundos';

  @override
  String get sosDistractBody => 'Toca el objetivo en movimiento 10 veces';

  @override
  String get sosTapsLeft => 'restantes';

  @override
  String get sosDone => 'Lo lograste. El antojo ha pasado.';

  @override
  String get sosAgain => 'Otra vez';

  @override
  String get audioUnavailable =>
      'El audio no está disponible en este dispositivo';

  @override
  String get chooseAtLeastOne => 'Elige al menos un hábito';

  @override
  String get dailyAmountLabel => '¿Cuántos al día?';

  @override
  String homeStreak(Object days) {
    return 'Racha de $days días';
  }

  @override
  String get rateLater => 'Más tarde';

  @override
  String get statsView7 => 'Vista de 7 días';

  @override
  String get sosAmbient => 'Ambiente relajante';

  @override
  String get ambientFire => 'Hoguera';

  @override
  String get ambientForest => 'Bosque';

  @override
  String get ambientOcean => 'Olas del mar';

  @override
  String get ambientRain => 'Lluvia';

  @override
  String get ambientMusic => 'Caja de música';

  @override
  String premiumSaveAmount(Object amount) {
    return 'Ahorra $amount';
  }

  @override
  String get surfingStep3 => 'Alcanza su pico y luego pasa. Sigues aquí.';

  @override
  String get surfingStep2 =>
      'Mírala subir como una ola. No luches, no juzgues.';

  @override
  String get surfingStep1 =>
      'Encuentra la sensación en tu cuerpo. ¿Dónde está? Solo nótala.';

  @override
  String get surfingTitle => 'Surfea la ola';

  @override
  String identityLine(Object days, Object identity) {
    return 'Eres $identity, día $days';
  }

  @override
  String get identity_social => 'libre de redes';

  @override
  String get identity_caffeine => 'libre de cafeína';

  @override
  String get identity_sugar => 'libre de azúcar';

  @override
  String get identity_vaping => 'libre de vapeo';

  @override
  String get identity_alcohol => 'no bebedor';

  @override
  String get identity_smoking => 'no fumador';

  @override
  String get relapseRecordRestart =>
      'Registrar el desliz y reiniciar el contador';

  @override
  String get relapseRecordKeep => 'Registrar el desliz y seguir';

  @override
  String onboardingStep(Object step, Object total) {
    return 'Paso $step/$total';
  }

  @override
  String get plansAction => 'Voy a…';

  @override
  String get plansWhen => 'Cuando…';

  @override
  String get plansAdd => 'Añadir un plan';

  @override
  String get plansEmpty =>
      'Escribe qué harás en tus momentos de riesgo — lo mostraremos cuando lo necesites';

  @override
  String get plansTitle => 'Mis planes de acción';

  @override
  String insightNoCompare(Object now) {
    return 'Antojo medio esta semana: $now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return 'Antojo medio $now/5 vs $prev/5 la pasada — presentarte a diario es lo que cuenta';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return 'Antojo medio $now/5 esta semana vs $prev/5 la pasada — mejorando';
  }

  @override
  String get textAuto => 'Automático';

  @override
  String get theme_violet => 'Violeta';

  @override
  String get theme_sunset => 'Atardecer';

  @override
  String get theme_rose => 'Rosa';

  @override
  String get theme_ocean => 'Océano';

  @override
  String get theme_forest => 'Bosque';

  @override
  String get theme_sage => 'Salvia';

  @override
  String get theme_custom => 'Personalizado';

  @override
  String get settingsTextColor => 'Color del texto';

  @override
  String get settingsFont => 'Fuente';

  @override
  String get settingsThemes => 'Temas';

  @override
  String get statsView30 => 'Vista de 30 días';

  @override
  String get premiumFreeTrial => '7 días de prueba gratis';

  @override
  String get deleteAllConfirm =>
      '¿Eliminar TODOS los hábitos y todo su historial? No se puede deshacer.';

  @override
  String get rateAction => 'Valorar en la App Store';

  @override
  String get rateBody =>
      'Tu valoración ayuda a otras personas a encontrar este apoyo.';

  @override
  String get rateTitle => '¿Te gusta DayZero?';

  @override
  String settingsNotificationsTime(Object hour) {
    return 'Un empujoncito cada día a las $hour:00';
  }

  @override
  String get notifBody =>
      '¿Qué tal tu día? Un registro rápido mantiene viva tu racha.';

  @override
  String get checkinOfferSos =>
      'Ese antojo parece fuerte. ¿Necesitas ayuda ahora?';

  @override
  String get settingsReasons => 'Mis motivos';

  @override
  String get statsTitle => 'Tu progreso';

  @override
  String get statsMood => 'Ánimo';

  @override
  String get statsCraving => 'Intensidad del antojo';

  @override
  String get statsWeek => 'Esta semana';

  @override
  String get statsMonth => 'Este mes';

  @override
  String get statsAll => 'Todo el tiempo';

  @override
  String get statsCheckins => 'registros';

  @override
  String get statsStreak => 'días seguidos registrando';

  @override
  String get statsBestStreak => 'mejor racha';

  @override
  String get statsTotalFree => 'días libres en total';

  @override
  String get statsWeeklyReport => 'Informe semanal';

  @override
  String get statsNoData =>
      'Aún no hay datos suficientes. Regístrate a diario para ver tus tendencias.';

  @override
  String get milestonesTitle => 'Hitos';

  @override
  String get milestonesUnlocked => 'Conseguidos';

  @override
  String get milestonesLocked => 'Próximamente';

  @override
  String get milestone_1h => 'Primera hora';

  @override
  String get milestone_1d => 'Primer día';

  @override
  String get milestone_3d => '3 días';

  @override
  String get milestone_1w => '1 semana';

  @override
  String get milestone_2w => '2 semanas';

  @override
  String get milestone_1m => '1 mes';

  @override
  String get milestone_3m => '3 meses';

  @override
  String get milestone_6m => '6 meses';

  @override
  String get milestone_1y => '1 año';

  @override
  String get milestone_streak7 => '7 días seguidos registrando';

  @override
  String get milestone_streak30 => '30 días seguidos registrando';

  @override
  String get milestone_money1 => 'Primeros 100 ahorrados';

  @override
  String get milestone_money2 => '1.000 ahorrados';

  @override
  String get milestone_money3 => '10.000 ahorrados';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsHabits => 'Mis hábitos';

  @override
  String get settingsEditHabit => 'Editar';

  @override
  String get settingsDeleteHabit => 'Eliminar';

  @override
  String get settingsNotifications => 'Recordatorio diario';

  @override
  String get settingsNotificationsDesc => 'Un empujoncito a las 20:00';

  @override
  String get settingsExport => 'Exportar mis datos';

  @override
  String get settingsExportDesc => 'Copia JSON de todo, guardada en Archivos';

  @override
  String get settingsPremium => 'DayZero Premium';

  @override
  String get settingsPremiumActive =>
      'Premium activo: gracias por apoyar una app independiente';

  @override
  String get settingsRestore => 'Restaurar compras';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get settingsTerms => 'Condiciones de uso';

  @override
  String get settingsSupport => 'Soporte';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsAboutBody =>
      'DayZero está hecho por un desarrollador independiente. 100 % sin conexión: tus datos nunca salen de este dispositivo.';

  @override
  String get settingsReset => 'Restablecer fecha de inicio';

  @override
  String get settingsRelapseReset => 'Reiniciar el contador';

  @override
  String get settingsDeleteData => 'Borrar todos los datos';

  @override
  String get deleteHabitConfirm => '¿Eliminar este hábito y todo su historial?';

  @override
  String get relapseTitle => '¿Has recaído?';

  @override
  String get relapseBody =>
      'Un desliz no borra tu progreso. Puedes reiniciar el contador o solo registrar el antojo y seguir adelante.';

  @override
  String get relapseRestart => 'Reiniciar contador';

  @override
  String get relapseKeep => 'Seguir adelante';

  @override
  String get premiumTitle => 'DayZero Premium';

  @override
  String get premiumSubtitle => 'Todo lo que necesitas para seguir libre';

  @override
  String get premiumFeature1 => 'Hábitos ilimitados';

  @override
  String get premiumFeature2 => 'Biblioteca completa de audio de respiración';

  @override
  String get premiumFeature3 => 'Temas, fuentes y colores de texto';

  @override
  String get premiumFeature4 => 'Ceremonias de celebración de hitos';

  @override
  String get premiumFreeNote =>
      'La versión gratuita sigue 2 hábitos con estadísticas básicas, para siempre y sin anuncios.';

  @override
  String get premiumWeekly => 'Semanal';

  @override
  String get premiumMonthly => 'Mensual';

  @override
  String get premiumYearly => 'Anual';

  @override
  String get premiumLifetime => 'De por vida';

  @override
  String get premiumBestValue => 'MEJOR OFERTA';

  @override
  String get premiumPerWeek => '/semana';

  @override
  String get premiumPerMonth => '/mes';

  @override
  String get premiumPerYear => '/año';

  @override
  String get premiumOnce => 'una vez';

  @override
  String get premiumSubscribe => 'Continuar';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumAutoRenew =>
      'La suscripción se renueva automáticamente y puede cancelarse en cualquier momento en los ajustes de tu ID de Apple, al menos 24 horas antes de que termine el periodo actual.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'Al continuar aceptas nuestros $terms y nuestra $privacy.';
  }

  @override
  String get termsLink => 'Condiciones de uso';

  @override
  String get privacyLink => 'Política de privacidad';

  @override
  String get buying => 'Procesando…';

  @override
  String get buyError => 'La compra ha fallado. Inténtalo de nuevo.';

  @override
  String get restoreDone => 'Compras restauradas';

  @override
  String get restoreNothing => 'No se encontraron compras anteriores';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get done => 'Hecho';

  @override
  String get close => 'Cerrar';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get demoMode => 'Modo demo web: Premium desbloqueado para pruebas';

  @override
  String get exportDone => 'Exportación guardada';

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
      'La tensión y el pulso empiezan a normalizarse';

  @override
  String get health_smoking_8h =>
      'El monóxido de carbono en sangre baja a la mitad';

  @override
  String get health_smoking_24h => 'El riesgo de infarto empieza a bajar';

  @override
  String get health_smoking_48h =>
      'El gusto y el olfato empiezan a recuperarse';

  @override
  String get health_smoking_72h => 'Respirar es mucho más fácil';

  @override
  String get health_smoking_1m =>
      'Mejoran la circulación y la función pulmonar';

  @override
  String get health_smoking_1y =>
      'El riesgo de enfermedad cardíaca se reduce a la mitad';

  @override
  String get health_vaping_24h => 'El antojo de nicotina empieza a remitir';

  @override
  String get health_vaping_48h => 'La respiración y el gusto se recuperan';

  @override
  String get health_vaping_72h => 'La inflamación pulmonar empieza a bajar';

  @override
  String get health_vaping_1w =>
      'El síndrome de abstinencia físico se desvanece';

  @override
  String get health_vaping_1m => 'Mejoran la energía y la capacidad pulmonar';

  @override
  String get health_alcohol_24h => 'Sueño más profundo y reparador';

  @override
  String get health_alcohol_48h =>
      'El cuerpo se rehidrata y la mente se aclara';

  @override
  String get health_alcohol_1w =>
      'Las enzimas hepáticas empiezan a recuperarse';

  @override
  String get health_alcohol_2w => 'La digestión y el ánimo se estabilizan';

  @override
  String get health_alcohol_1m => 'Piel más fresca y mejor sueño';

  @override
  String get health_alcohol_3m => 'La grasa del hígado empieza a disminuir';

  @override
  String get health_alcohol_1y => 'La recuperación del hígado avanza mucho';

  @override
  String get health_sugar_1d => 'El azúcar en sangre se estabiliza';

  @override
  String get health_sugar_3d => 'Los antojos empiezan a desvanecerse';

  @override
  String get health_sugar_2w => 'Las papilas se vuelven más sensibles';

  @override
  String get health_sugar_1m => 'Mejora la sensibilidad a la insulina';

  @override
  String get health_sugar_3m => 'Mejoran la energía y la piel';

  @override
  String get health_caffeine_1d =>
      'El síndrome de abstinencia llega a su pico: aguanta';

  @override
  String get health_caffeine_3d => 'Los dolores de cabeza empiezan a remitir';

  @override
  String get health_caffeine_1w => 'Mejora la calidad del sueño';

  @override
  String get health_caffeine_2w => 'La energía se mantiene estable todo el día';

  @override
  String get health_caffeine_1m => 'Baja la tensión arterial';

  @override
  String get health_social_1d =>
      'La capacidad de atención empieza a recuperarse';

  @override
  String get health_social_3d => 'Baja la ansiedad';

  @override
  String get health_social_1w => 'Mejora el sueño';

  @override
  String get health_social_2w => 'El ánimo se estabiliza';

  @override
  String get health_social_1m => 'Aumentan la concentración y la productividad';

  @override
  String get dayUnit => 'd';

  @override
  String get hourUnit => 'h';

  @override
  String get minuteUnit => 'min';
}
