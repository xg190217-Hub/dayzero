// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'Ваш личный помощник, чтобы бросить';

  @override
  String get onboardingWelcomeTitle => 'Новое начало — сегодня';

  @override
  String get onboardingWelcomeBody =>
      'Отслеживайте свой путь приватно. Без аккаунта, без рекламы, без облака. Всё остаётся на вашем устройстве.';

  @override
  String get onboardingChooseTitle => 'Что вы хотите бросить?';

  @override
  String get onboardingChooseBody =>
      'Выберите одну или несколько привычек. Можно добавить ещё позже.';

  @override
  String get onboardingDateTitle => 'Когда ваш день «ноль»?';

  @override
  String get onboardingDateBody =>
      'Можно начать сегодня или выбрать дату в будущем. Если начать сейчас, отсчёт идёт с момента нажатия «Начать».';

  @override
  String get onboardingSpendTitle => 'Сколько это стоило в день?';

  @override
  String get onboardingSpendBody =>
      'Необязательно — используется для подсчёта сэкономленных денег. Можно изменить позже.';

  @override
  String get perDay => 'в день';

  @override
  String get currencyPlaceholder => 'Сумма';

  @override
  String get onboardingReasonsTitle => 'Почему вы хотите бросить?';

  @override
  String get onboardingReasonsBody =>
      'Запишите свои причины. Мы покажем их, когда придёт тяга.';

  @override
  String get reasonPlaceholder => 'Например: ради семьи…';

  @override
  String get addReason => 'Добавить ещё причину';

  @override
  String get startJourney => 'Начать мой путь';

  @override
  String get skip => 'Пропустить';

  @override
  String get notMedicalAdvice =>
      'DayZero даёт только мотивацию и учёт — это не медицинская рекомендация. При тяжёлой абстиненции обратитесь к врачу.';

  @override
  String get habit_alcohol => 'Алкоголь';

  @override
  String get habit_smoking => 'Курение';

  @override
  String get habit_vaping => 'Вейпинг';

  @override
  String get habit_sugar => 'Сахар';

  @override
  String get habit_caffeine => 'Кофеин';

  @override
  String get habit_social => 'Соцсети';

  @override
  String get habit_custom => 'Своя привычка';

  @override
  String get customHabitName => 'Как называется привычка?';

  @override
  String get homeDaysSince => 'дней свободы';

  @override
  String get homeDaysSinceOne => 'день свободы';

  @override
  String get homeTimeFree => 'свободен';

  @override
  String get homeMoneySaved => 'сэкономлено';

  @override
  String get homeCheckIn => 'Отметиться сегодня';

  @override
  String get homeSOS => 'SOS при тяге';

  @override
  String get homeHealthTimeline => 'Ваша шкала восстановления';

  @override
  String get homeNextMilestone => 'Следующая веха';

  @override
  String get homeIn => 'через';

  @override
  String get homeRelapse => 'Я сорвался';

  @override
  String get homeAddHabit => 'Добавить привычку';

  @override
  String get checkinTitle => 'Ежедневная отметка';

  @override
  String get checkinMood => 'Как вы себя чувствуете?';

  @override
  String get checkinCraving => 'Сила тяги';

  @override
  String get checkinTrigger => 'Что стало главным триггером?';

  @override
  String get trigger_none => 'Ничего особенного';

  @override
  String get trigger_stress => 'Стресс';

  @override
  String get trigger_social => 'Общение и компании';

  @override
  String get trigger_boredom => 'Скука';

  @override
  String get trigger_habit_loop => 'Старая рутина';

  @override
  String get trigger_negative => 'Плохое настроение';

  @override
  String get trigger_celebration => 'Праздники';

  @override
  String get checkinNote => 'Заметка (необязательно)';

  @override
  String get checkinDone => 'Сохранено — до завтра';

  @override
  String get checkinEditLabel => 'Изменить отметку за сегодня';

  @override
  String get sosTitle => 'SOS при тяге';

  @override
  String get sosBody =>
      'Тяга достигает пика за несколько минут, а затем проходит. Вы справитесь.';

  @override
  String get sosBreathing => 'Подышите со мной';

  @override
  String get sosBreatheIn => 'Вдох';

  @override
  String get sosBreatheOut => 'Выдох';

  @override
  String get sosHold => 'Задержите';

  @override
  String get sosReasons => 'Вспомните, зачем вы начали';

  @override
  String get sosDistract => 'Отвлечение на 90 секунд';

  @override
  String get sosDistractBody => 'Нажмите на движущуюся цель 10 раз';

  @override
  String get sosTapsLeft => 'осталось';

  @override
  String get sosDone => 'Вы справились. Тяга прошла.';

  @override
  String get sosAgain => 'Ещё раз';

  @override
  String get audioUnavailable => 'Аудио недоступно на этом устройстве';

  @override
  String get chooseAtLeastOne => 'Выберите хотя бы одну привычку';

  @override
  String get dailyAmountLabel => 'Сколько в день?';

  @override
  String homeStreak(Object days) {
    return '$days дней подряд';
  }

  @override
  String get rateLater => 'Позже';

  @override
  String get statsView7 => 'Вид за 7 дней';

  @override
  String get sosAmbient => 'Спокойный фон';

  @override
  String premiumSaveAmount(Object amount) {
    return 'Экономьте $amount';
  }

  @override
  String get surfingStep3 =>
      'Оно достигает пика, потом отступает. Вы всё ещё здесь.';

  @override
  String get surfingStep2 =>
      'Смотрите, как оно поднимается волной. Не боритесь, не судите.';

  @override
  String get surfingStep1 =>
      'Найдите это ощущение в теле. Где оно? Просто заметьте его.';

  @override
  String get surfingTitle => 'Оседлайте волну';

  @override
  String identityLine(Object days, Object identity) {
    return 'Вы $identity, день $days';
  }

  @override
  String get identity_social => 'свободный от соцсетей';

  @override
  String get identity_caffeine => 'свободный от кофеина';

  @override
  String get identity_sugar => 'свободный от сахара';

  @override
  String get identity_vaping => 'свободный от вейпа';

  @override
  String get identity_alcohol => 'непьющий человек';

  @override
  String get identity_smoking => 'некурящий человек';

  @override
  String get relapseRecordRestart => 'Записать срыв и перезапустить счётчик';

  @override
  String get relapseRecordKeep => 'Записать срыв и продолжать';

  @override
  String onboardingStep(Object step, Object total) {
    return 'Шаг $step/$total';
  }

  @override
  String get plansAction => 'Я сделаю…';

  @override
  String get plansWhen => 'Когда…';

  @override
  String get plansAdd => 'Добавить план';

  @override
  String get plansEmpty =>
      'Запишите, что вы сделаете в рискованные моменты — покажем, когда понадобится';

  @override
  String get plansTitle => 'Мои планы на случай срыва';

  @override
  String insightNoCompare(Object now) {
    return 'Средняя тяга на этой неделе: $now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return 'Средняя тяга $now/5 против $prev/5 — важна сама ежедневная отметка';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return 'Средняя тяга $now/5 на этой неделе против $prev/5 — лучше';
  }

  @override
  String get textAuto => 'Авто';

  @override
  String get theme_violet => 'Фиолетовый';

  @override
  String get theme_sunset => 'Закат';

  @override
  String get theme_rose => 'Роза';

  @override
  String get theme_ocean => 'Океан';

  @override
  String get theme_forest => 'Лес';

  @override
  String get theme_sage => 'Шалфей';

  @override
  String get theme_custom => 'Свой';

  @override
  String get settingsTextColor => 'Цвет текста';

  @override
  String get settingsFont => 'Шрифт';

  @override
  String get settingsThemes => 'Темы';

  @override
  String get statsView30 => 'Вид за 30 дней';

  @override
  String get premiumFreeTrial => '7 дней бесплатно';

  @override
  String get deleteAllConfirm =>
      'Удалить ВСЕ привычки и всю их историю? Это действие необратимо.';

  @override
  String get rateAction => 'Оценить в App Store';

  @override
  String get rateBody => 'Ваша оценка поможет другим найти эту поддержку.';

  @override
  String get rateTitle => 'Нравится DayZero?';

  @override
  String settingsNotificationsTime(Object hour) {
    return 'Мягкое напоминание каждый день в $hour:00';
  }

  @override
  String get notifBody =>
      'Как прошёл день? Быстрая отметка сохранит вашу серию.';

  @override
  String get checkinOfferSos =>
      'Тяга выглядит сильной. Нужна помощь прямо сейчас?';

  @override
  String get settingsReasons => 'Мои причины';

  @override
  String get statsTitle => 'Ваш прогресс';

  @override
  String get statsMood => 'Настроение';

  @override
  String get statsCraving => 'Сила тяги';

  @override
  String get statsWeek => 'Эта неделя';

  @override
  String get statsMonth => 'Этот месяц';

  @override
  String get statsAll => 'Всё время';

  @override
  String get statsCheckins => 'отметок';

  @override
  String get statsStreak => 'дней отметок подряд';

  @override
  String get statsBestStreak => 'лучшая серия';

  @override
  String get statsTotalFree => 'всего дней свободы';

  @override
  String get statsWeeklyReport => 'Недельный отчёт';

  @override
  String get statsNoData =>
      'Данных пока мало. Отмечайтесь ежедневно, чтобы видеть тенденции.';

  @override
  String get milestonesTitle => 'Вехи';

  @override
  String get milestonesUnlocked => 'Достигнуты';

  @override
  String get milestonesLocked => 'Впереди';

  @override
  String get milestone_1h => 'Первый час';

  @override
  String get milestone_1d => 'Первый день';

  @override
  String get milestone_3d => '3 дня';

  @override
  String get milestone_1w => '1 неделя';

  @override
  String get milestone_2w => '2 недели';

  @override
  String get milestone_1m => '1 месяц';

  @override
  String get milestone_3m => '3 месяца';

  @override
  String get milestone_6m => '6 месяцев';

  @override
  String get milestone_1y => '1 год';

  @override
  String get milestone_streak7 => '7 дней отметок подряд';

  @override
  String get milestone_streak30 => '30 дней отметок подряд';

  @override
  String get milestone_money1 => 'Первые 100 сэкономлены';

  @override
  String get milestone_money2 => '1 000 сэкономлено';

  @override
  String get milestone_money3 => '10 000 сэкономлено';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsHabits => 'Мои привычки';

  @override
  String get settingsEditHabit => 'Изменить';

  @override
  String get settingsDeleteHabit => 'Удалить';

  @override
  String get settingsNotifications => 'Ежедневное напоминание';

  @override
  String get settingsNotificationsDesc => 'Мягкий толчок в 20:00';

  @override
  String get settingsExport => 'Экспорт моих данных';

  @override
  String get settingsExportDesc =>
      'JSON-резервная копия всего, сохранена в Файлы';

  @override
  String get settingsPremium => 'DayZero Premium';

  @override
  String get settingsPremiumActive =>
      'Premium активен — спасибо за поддержку независимого приложения';

  @override
  String get settingsRestore => 'Восстановить покупки';

  @override
  String get settingsPrivacy => 'Политика конфиденциальности';

  @override
  String get settingsTerms => 'Условия использования';

  @override
  String get settingsSupport => 'Поддержка';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get settingsAboutBody =>
      'DayZero создан независимым разработчиком. 100% офлайн — ваши данные никогда не покидают это устройство.';

  @override
  String get settingsReset => 'Сбросить дату начала';

  @override
  String get settingsRelapseReset => 'Перезапустить счётчик';

  @override
  String get settingsDeleteData => 'Удалить все данные';

  @override
  String get deleteHabitConfirm => 'Удалить эту привычку и всю её историю?';

  @override
  String get relapseTitle => 'Сорвались?';

  @override
  String get relapseBody =>
      'Один срыв не стирает ваш прогресс. Перезапустите счётчик или просто запишите тягу и продолжайте.';

  @override
  String get relapseRestart => 'Перезапустить счётчик';

  @override
  String get relapseKeep => 'Продолжать';

  @override
  String get premiumTitle => 'DayZero Premium';

  @override
  String get premiumSubtitle => 'Всё, что нужно, чтобы оставаться свободным';

  @override
  String get premiumFeature1 => 'Неограниченные привычки';

  @override
  String get premiumFeature2 => 'Полная аудиотека дыхательных упражнений';

  @override
  String get premiumFeature3 => 'Темы, шрифты и цвета текста';

  @override
  String get premiumFeature4 => 'Церемонии празднования вех';

  @override
  String get premiumFreeNote =>
      'Бесплатная версия отслеживает 2 привычки с базовой статистикой — навсегда, без рекламы.';

  @override
  String get premiumWeekly => 'Неделя';

  @override
  String get premiumMonthly => 'Месяц';

  @override
  String get premiumYearly => 'Год';

  @override
  String get premiumLifetime => 'Навсегда';

  @override
  String get premiumBestValue => 'ВЫГОДНО';

  @override
  String get premiumPerWeek => '/нед';

  @override
  String get premiumPerMonth => '/мес';

  @override
  String get premiumPerYear => '/год';

  @override
  String get premiumOnce => 'разово';

  @override
  String get premiumSubscribe => 'Продолжить';

  @override
  String get premiumRestore => 'Восстановить покупки';

  @override
  String get premiumAutoRenew =>
      'Подписка продлевается автоматически и может быть отменена в любой момент в настройках вашего Apple ID, минимум за 24 часа до окончания текущего периода.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'Продолжая, вы соглашаетесь с нашими $terms и $privacy.';
  }

  @override
  String get termsLink => 'Условиями использования';

  @override
  String get privacyLink => 'Политикой конфиденциальности';

  @override
  String get buying => 'Обработка…';

  @override
  String get buyError => 'Покупка не удалась. Попробуйте ещё раз.';

  @override
  String get restoreDone => 'Покупки восстановлены';

  @override
  String get restoreNothing => 'Предыдущие покупки не найдены';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get save => 'Сохранить';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрыть';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get demoMode => 'Веб-демо — Premium разблокирован для тестирования';

  @override
  String get exportDone => 'Экспорт сохранён';

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
  String get language_system => 'Системный';

  @override
  String get health_smoking_20m => 'Давление и пульс начинают нормализоваться';

  @override
  String get health_smoking_8h => 'Угарный газ в крови снижается вдвое';

  @override
  String get health_smoking_24h => 'Риск инфаркта начинает снижаться';

  @override
  String get health_smoking_48h => 'Вкус и обоняние начинают восстанавливаться';

  @override
  String get health_smoking_72h => 'Дышать становится заметно легче';

  @override
  String get health_smoking_1m => 'Улучшаются кровообращение и функция лёгких';

  @override
  String get health_smoking_1y => 'Риск болезней сердца снижается вдвое';

  @override
  String get health_vaping_24h => 'Тяга к никотину начинает ослабевать';

  @override
  String get health_vaping_48h => 'Дыхание и вкус восстанавливаются';

  @override
  String get health_vaping_72h => 'Воспаление лёгких начинает спадать';

  @override
  String get health_vaping_1w => 'Физическая абстиненция в основном проходит';

  @override
  String get health_vaping_1m => 'Улучшаются энергия и объём лёгких';

  @override
  String get health_alcohol_24h => 'Более глубокий и спокойный сон';

  @override
  String get health_alcohol_48h => 'Организм восполняет воду, голова яснеет';

  @override
  String get health_alcohol_1w => 'Ферменты печени начинают восстанавливаться';

  @override
  String get health_alcohol_2w => 'Пищеварение и настроение стабилизируются';

  @override
  String get health_alcohol_1m => 'Свежее кожа, лучше сон';

  @override
  String get health_alcohol_3m => 'Жир в печени начинает уменьшаться';

  @override
  String get health_alcohol_1y =>
      'Восстановление печени значительно прогрессирует';

  @override
  String get health_sugar_1d => 'Уровень сахара в крови стабилизируется';

  @override
  String get health_sugar_3d => 'Тяга к сладкому начинает уходить';

  @override
  String get health_sugar_2w => 'Вкусовые рецепторы обостряются';

  @override
  String get health_sugar_1m => 'Улучшается чувствительность к инсулину';

  @override
  String get health_sugar_3m => 'Улучшаются энергия и кожа';

  @override
  String get health_caffeine_1d => 'Пик абстиненции — держитесь';

  @override
  String get health_caffeine_3d => 'Головные боли начинают отступать';

  @override
  String get health_caffeine_1w => 'Улучшается качество сна';

  @override
  String get health_caffeine_2w => 'Энергия стабильна весь день';

  @override
  String get health_caffeine_1m => 'Снижается артериальное давление';

  @override
  String get health_social_1d =>
      'Концентрация внимания начинает восстанавливаться';

  @override
  String get health_social_3d => 'Снижается тревожность';

  @override
  String get health_social_1w => 'Улучшается сон';

  @override
  String get health_social_2w => 'Настроение стабилизируется';

  @override
  String get health_social_1m => 'Растут концентрация и продуктивность';

  @override
  String get dayUnit => 'дн';

  @override
  String get hourUnit => 'ч';

  @override
  String get minuteUnit => 'мин';
}
