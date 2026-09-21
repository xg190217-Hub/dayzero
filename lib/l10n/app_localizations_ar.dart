// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => 'رفيقك الخاص للإقلاع';

  @override
  String get onboardingWelcomeTitle => 'بداية جديدة تبدأ اليوم';

  @override
  String get onboardingWelcomeBody =>
      'تابع رحلتك بخصوصية تامة. لا حساب، لا إعلانات، لا سحابة. كل شيء يبقى على جهازك.';

  @override
  String get onboardingChooseTitle => 'ماذا تريد أن تقلع عنه؟';

  @override
  String get onboardingChooseBody =>
      'اختر عادة واحدة أو أكثر. يمكنك إضافة المزيد لاحقًا.';

  @override
  String get onboardingDateTitle => 'متى هو يومك صفر؟';

  @override
  String get onboardingDateBody =>
      'يمكنك البدء اليوم أو اختيار تاريخ مستقبلي. إذا بدأت الآن، يبدأ العد من لحظة الضغط على ابدأ.';

  @override
  String get onboardingSpendTitle => 'كم كان يكلّفك يوميًا؟';

  @override
  String get onboardingSpendBody =>
      'اختياري — نستخدمه لحساب المال الذي توفّره. يمكنك تعديله لاحقًا.';

  @override
  String get perDay => 'يوميًا';

  @override
  String get currencyPlaceholder => 'المبلغ';

  @override
  String get onboardingReasonsTitle => 'لماذا تريد الإقلاع؟';

  @override
  String get onboardingReasonsBody =>
      'اكتب أسبابك. سنعرضها عليك عند اشتداد الرغبة.';

  @override
  String get reasonPlaceholder => 'مثال: من أجل عائلتي…';

  @override
  String get addReason => 'أضف سببًا آخر';

  @override
  String get startJourney => 'ابدأ رحلتي';

  @override
  String get skip => 'تخطّي';

  @override
  String get notMedicalAdvice =>
      'يقدّم DayZero التحفيز والتتبع فقط وليس نصيحة طبية. عند أعراض انسحاب شديدة، استشر طبيبًا.';

  @override
  String get habit_alcohol => 'الكحول';

  @override
  String get habit_smoking => 'التدخين';

  @override
  String get habit_vaping => 'التدخين الإلكتروني';

  @override
  String get habit_sugar => 'السكر';

  @override
  String get habit_caffeine => 'الكافيين';

  @override
  String get habit_social => 'وسائل التواصل';

  @override
  String get habit_custom => 'عادتي الخاصة';

  @override
  String get customHabitName => 'ما اسم العادة؟';

  @override
  String get homeDaysSince => 'يوم حرية';

  @override
  String get homeDaysSinceOne => 'يوم حرية';

  @override
  String get homeTimeFree => 'حر';

  @override
  String get homeMoneySaved => 'وفّرت';

  @override
  String get homeCheckIn => 'تسجيل اليوم';

  @override
  String get homeSOS => 'إنقاذ الرغبة';

  @override
  String get homeHealthTimeline => 'خط تعافيك الزمني';

  @override
  String get homeNextMilestone => 'الإنجاز التالي';

  @override
  String get homeIn => 'بعد';

  @override
  String get homeRelapse => 'انتكست';

  @override
  String get homeAddHabit => 'أضف عادة';

  @override
  String get checkinTitle => 'التسجيل اليومي';

  @override
  String get checkinMood => 'كيف تشعر؟';

  @override
  String get checkinCraving => 'شدة الرغبة';

  @override
  String get checkinTrigger => 'ما هو أكبر محفّز؟';

  @override
  String get trigger_none => 'لا شيء محدد';

  @override
  String get trigger_stress => 'التوتر';

  @override
  String get trigger_social => 'المناسبات الاجتماعية';

  @override
  String get trigger_boredom => 'الملل';

  @override
  String get trigger_habit_loop => 'الروتين القديم';

  @override
  String get trigger_negative => 'مزاج سيئ';

  @override
  String get trigger_celebration => 'الاحتفالات';

  @override
  String get checkinNote => 'ملاحظة (اختياري)';

  @override
  String get checkinDone => 'تم الحفظ — إلى الغد';

  @override
  String get checkinEditLabel => 'تعديل تسجيل اليوم';

  @override
  String get sosTitle => 'إنقاذ الرغبة';

  @override
  String get sosBody => 'تبلغ الرغبة ذروتها في دقائق ثم تزول. يمكنك الصمود.';

  @override
  String get sosBreathing => 'تنفّس معي';

  @override
  String get sosBreatheIn => 'شهيق';

  @override
  String get sosBreatheOut => 'زفير';

  @override
  String get sosHold => 'احبس';

  @override
  String get sosReasons => 'تذكّر لماذا بدأت';

  @override
  String get sosDistract => 'إلهاء 90 ثانية';

  @override
  String get sosDistractBody => 'المس الهدف المتحرك 10 مرات';

  @override
  String get sosTapsLeft => 'متبقٍ';

  @override
  String get sosDone => 'لقد نجحت. الرغبة زالت.';

  @override
  String get sosAgain => 'مرة أخرى';

  @override
  String get audioUnavailable => 'الصوت غير متاح على هذا الجهاز';

  @override
  String get chooseAtLeastOne => 'يرجى اختيار عادة واحدة على الأقل';

  @override
  String get dailyAmountLabel => 'كم في اليوم؟';

  @override
  String homeStreak(Object days) {
    return '$days أيام متتالية';
  }

  @override
  String get rateLater => 'لاحقًا';

  @override
  String get statsView7 => 'عرض 7 أيام';

  @override
  String get sosAmbient => 'أجواء هادئة';

  @override
  String premiumSaveAmount(Object amount) {
    return 'وفّر $amount';
  }

  @override
  String get surfingStep3 => 'تبلغ ذروتها ثم تمر. ما زلت هنا.';

  @override
  String get surfingStep2 => 'راقبها ترتفع كالموجة. لا تقاومها ولا تحكم عليها.';

  @override
  String get surfingStep1 => 'ابحث عن الإحساس في جسدك. أين هو؟ فقط لاحظه.';

  @override
  String get surfingTitle => 'اركب الموجة';

  @override
  String identityLine(Object days, Object identity) {
    return 'أنت $identity في اليوم $days';
  }

  @override
  String get identity_social => 'متحرر من وسائل التواصل';

  @override
  String get identity_caffeine => 'متحرر من الكافيين';

  @override
  String get identity_sugar => 'متحرر من السكر';

  @override
  String get identity_vaping => 'متحرر من التدخين الإلكتروني';

  @override
  String get identity_alcohol => 'غير شارب';

  @override
  String get identity_smoking => 'غير مدخن';

  @override
  String get relapseRecordRestart => 'سجّل الزلة وأعد تشغيل العداد';

  @override
  String get relapseRecordKeep => 'سجّل الزلة وتابع';

  @override
  String onboardingStep(Object step, Object total) {
    return 'الخطوة $step/$total';
  }

  @override
  String get plansAction => 'سأقوم بـ…';

  @override
  String get plansWhen => 'عندما…';

  @override
  String get plansAdd => 'أضف خطة';

  @override
  String get plansEmpty =>
      'اكتب ما ستفعله في لحظات الخطر — سنعرضه عندما تحتاجه';

  @override
  String get plansTitle => 'خططي للتعامل';

  @override
  String insightNoCompare(Object now) {
    return 'متوسط الرغبة هذا الأسبوع: $now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return 'متوسط الرغبة $now/5 مقابل $prev/5 — الاستمرار اليومي هو الأهم';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return 'متوسط الرغبة $now/5 هذا الأسبوع مقابل $prev/5 — يتحسن';
  }

  @override
  String get textAuto => 'تلقائي';

  @override
  String get theme_violet => 'بنفسجي';

  @override
  String get theme_sunset => 'غروب';

  @override
  String get theme_rose => 'ورد';

  @override
  String get theme_ocean => 'محيط';

  @override
  String get theme_forest => 'غابة';

  @override
  String get theme_sage => 'ميرمية';

  @override
  String get theme_custom => 'مخصص';

  @override
  String get settingsTextColor => 'لون النص';

  @override
  String get settingsFont => 'الخط';

  @override
  String get settingsThemes => 'الثيمات';

  @override
  String get statsView30 => 'عرض 30 يومًا';

  @override
  String get premiumFreeTrial => 'تجربة مجانية 7 أيام';

  @override
  String get deleteAllConfirm =>
      'حذف جميع العادات وكل سجلاتها؟ لا يمكن التراجع عن ذلك.';

  @override
  String get rateAction => 'التقييم في App Store';

  @override
  String get rateBody =>
      'تقييمك يساعد الآخرين في العثور على الدعم الذي يحتاجونه.';

  @override
  String get rateTitle => 'هل يعجبك DayZero؟';

  @override
  String settingsNotificationsTime(Object hour) {
    return 'تنبيه لطيف كل يوم عند الساعة $hour:00';
  }

  @override
  String get notifBody => 'كيف كان يومك؟ تسجيل سريع يحافظ على سلسلتك.';

  @override
  String get checkinOfferSos => 'يبدو أن الرغبة قوية. هل تحتاج مساعدة الآن؟';

  @override
  String get settingsReasons => 'أسبابي';

  @override
  String get statsTitle => 'تقدمك';

  @override
  String get statsMood => 'المزاج';

  @override
  String get statsCraving => 'شدة الرغبة';

  @override
  String get statsWeek => 'هذا الأسبوع';

  @override
  String get statsMonth => 'هذا الشهر';

  @override
  String get statsAll => 'كل الفترة';

  @override
  String get statsCheckins => 'تسجيل';

  @override
  String get statsStreak => 'أيام تسجيل متتالية';

  @override
  String get statsBestStreak => 'أفضل سلسلة';

  @override
  String get statsTotalFree => 'إجمالي أيام الحرية';

  @override
  String get statsWeeklyReport => 'التقرير الأسبوعي';

  @override
  String get statsNoData =>
      'لا توجد بيانات كافية بعد. سجّل يوميًا لترى اتجاهاتك.';

  @override
  String get milestonesTitle => 'الإنجازات';

  @override
  String get milestonesUnlocked => 'تم تحقيقها';

  @override
  String get milestonesLocked => 'قادمة';

  @override
  String get milestone_1h => 'الساعة الأولى';

  @override
  String get milestone_1d => 'اليوم الأول';

  @override
  String get milestone_3d => '3 أيام';

  @override
  String get milestone_1w => 'أسبوع واحد';

  @override
  String get milestone_2w => 'أسبوعان';

  @override
  String get milestone_1m => 'شهر واحد';

  @override
  String get milestone_3m => '3 أشهر';

  @override
  String get milestone_6m => '6 أشهر';

  @override
  String get milestone_1y => 'سنة واحدة';

  @override
  String get milestone_streak7 => '7 أيام تسجيل متتالية';

  @override
  String get milestone_streak30 => '30 يوم تسجيل متتالية';

  @override
  String get milestone_money1 => 'أول 100 موفّرة';

  @override
  String get milestone_money2 => '1,000 موفّرة';

  @override
  String get milestone_money3 => '10,000 موفّرة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsHabits => 'عاداتي';

  @override
  String get settingsEditHabit => 'تعديل';

  @override
  String get settingsDeleteHabit => 'حذف';

  @override
  String get settingsNotifications => 'تذكير التسجيل اليومي';

  @override
  String get settingsNotificationsDesc => 'تنبيه لطيف الساعة 8 مساءً';

  @override
  String get settingsExport => 'تصدير بياناتي';

  @override
  String get settingsExportDesc =>
      'نسخة JSON احتياطية من كل شيء تُحفظ في الملفات';

  @override
  String get settingsPremium => 'DayZero المميز';

  @override
  String get settingsPremiumActive => 'المميز مفعّل — شكرًا لدعم تطبيق مستقل';

  @override
  String get settingsRestore => 'استعادة المشتريات';

  @override
  String get settingsPrivacy => 'سياسة الخصوصية';

  @override
  String get settingsTerms => 'شروط الاستخدام';

  @override
  String get settingsSupport => 'الدعم';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsAbout => 'حول';

  @override
  String get settingsAboutBody =>
      'صُنع DayZero بواسطة مطور مستقل. يعمل دون اتصال بنسبة 100% — بياناتك لا تغادر هذا الجهاز أبدًا.';

  @override
  String get settingsReset => 'إعادة ضبط تاريخ البدء';

  @override
  String get settingsRelapseReset => 'إعادة تشغيل العداد';

  @override
  String get settingsDeleteData => 'حذف جميع البيانات';

  @override
  String get deleteHabitConfirm => 'حذف هذه العادة وكل سجلها؟';

  @override
  String get relapseTitle => 'هل انتكست؟';

  @override
  String get relapseBody =>
      'زلة واحدة لا تمحو تقدمك. أعد تشغيل العداد أو سجّل الرغبة فقط وواصل.';

  @override
  String get relapseRestart => 'إعادة تشغيل العداد';

  @override
  String get relapseKeep => 'المتابعة';

  @override
  String get premiumTitle => 'DayZero المميز';

  @override
  String get premiumSubtitle => 'كل ما تحتاجه لتبقى حرًا';

  @override
  String get premiumFeature1 => 'عادات بلا حدود';

  @override
  String get premiumFeature2 => 'مكتبة صوتية كاملة لتمارين التنفس';

  @override
  String get premiumFeature3 => 'الثيمات والخطوط وألوان النص';

  @override
  String get premiumFeature4 => 'احتفالات الإنجازات';

  @override
  String get premiumFreeNote =>
      'النسخة المجانية تتابع عادتين مع الإحصاءات الأساسية — للأبد وبدون إعلانات.';

  @override
  String get premiumWeekly => 'أسبوعي';

  @override
  String get premiumMonthly => 'شهري';

  @override
  String get premiumYearly => 'سنوي';

  @override
  String get premiumLifetime => 'مدى الحياة';

  @override
  String get premiumBestValue => 'أفضل قيمة';

  @override
  String get premiumPerWeek => '/أسبوع';

  @override
  String get premiumPerMonth => '/شهر';

  @override
  String get premiumPerYear => '/سنة';

  @override
  String get premiumOnce => 'مرة واحدة';

  @override
  String get premiumSubscribe => 'متابعة';

  @override
  String get premiumRestore => 'استعادة المشتريات';

  @override
  String get premiumAutoRenew =>
      'يتجدد الاشتراك تلقائيًا ويمكن إلغاؤه في أي وقت من إعدادات Apple ID، قبل 24 ساعة على الأقل من نهاية الفترة الحالية.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return 'بالمتابعة أنت توافق على $terms و$privacy.';
  }

  @override
  String get termsLink => 'شروط الاستخدام';

  @override
  String get privacyLink => 'سياسة الخصوصية';

  @override
  String get buying => 'جارٍ المعالجة…';

  @override
  String get buyError => 'فشل الشراء. حاول مرة أخرى.';

  @override
  String get restoreDone => 'تمت استعادة المشتريات';

  @override
  String get restoreNothing => 'لم يتم العثور على مشتريات سابقة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get save => 'حفظ';

  @override
  String get done => 'تم';

  @override
  String get close => 'إغلاق';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get demoMode => 'وضع العرض التجريبي على الويب — المميز مفتوح للاختبار';

  @override
  String get exportDone => 'تم حفظ التصدير';

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
  String get language_system => 'النظام';

  @override
  String get health_smoking_20m => 'يبدأ ضغط الدم والنبض بالعودة للطبيعي';

  @override
  String get health_smoking_8h => 'ينخفض أول أكسيد الكربون في الدم إلى النصف';

  @override
  String get health_smoking_24h => 'يبدأ خطر النوبة القلبية بالانخفاض';

  @override
  String get health_smoking_48h => 'يبدأ التذوق والشم بالتعافي';

  @override
  String get health_smoking_72h => 'يصبح التنفس أسهل بوضوح';

  @override
  String get health_smoking_1m => 'تتحسن الدورة الدموية ووظيفة الرئتين';

  @override
  String get health_smoking_1y => 'ينخفض خطر أمراض القلب إلى النصف';

  @override
  String get health_vaping_24h => 'تبدأ الرغبة في النيكوتين بالتراجع';

  @override
  String get health_vaping_48h => 'يبدأ التنفس والتذوق بالتعافي';

  @override
  String get health_vaping_72h => 'يبدأ التهاب الرئتين بالانحسار';

  @override
  String get health_vaping_1w => 'تزول معظم أعراض الانسحاب الجسدية';

  @override
  String get health_vaping_1m => 'تتحسن الطاقة وسعة الرئتين';

  @override
  String get health_alcohol_24h => 'نوم أعمق وأكثر راحة';

  @override
  String get health_alcohol_48h => 'يستعيد الجسم ترطيبه ويصفو الذهن';

  @override
  String get health_alcohol_1w => 'تبدأ إنزيمات الكبد بالتعافي';

  @override
  String get health_alcohol_2w => 'يستقر الهضم والمزاج';

  @override
  String get health_alcohol_1m => 'بشرة أنضر ونوم أفضل';

  @override
  String get health_alcohol_3m => 'تبدأ دهون الكبد بالتناقص';

  @override
  String get health_alcohol_1y => 'يتقدم تعافي الكبد بشكل كبير';

  @override
  String get health_sugar_1d => 'يستقر سكر الدم';

  @override
  String get health_sugar_3d => 'تبدأ الرغبة بالتلاشي';

  @override
  String get health_sugar_2w => 'تصبح براعم التذوق أكثر حساسية';

  @override
  String get health_sugar_1m => 'تتحسن حساسية الأنسولين';

  @override
  String get health_sugar_3m => 'تتحسن الطاقة والبشرة';

  @override
  String get health_caffeine_1d => 'ذروة الانسحاب — اصمد';

  @override
  String get health_caffeine_3d => 'يبدأ الصداع بالتراجع';

  @override
  String get health_caffeine_1w => 'تتحسن جودة النوم';

  @override
  String get health_caffeine_2w => 'تستقر الطاقة طوال اليوم';

  @override
  String get health_caffeine_1m => 'ينخفض ضغط الدم';

  @override
  String get health_social_1d => 'يبدأ مدى الانتباه بالتعافي';

  @override
  String get health_social_3d => 'ينخفض القلق';

  @override
  String get health_social_1w => 'يتحسن النوم';

  @override
  String get health_social_2w => 'يستقر المزاج';

  @override
  String get health_social_1m => 'يرتفع التركيز والإنتاجية';

  @override
  String get dayUnit => 'يوم';

  @override
  String get hourUnit => 'س';

  @override
  String get minuteUnit => 'د';
}
