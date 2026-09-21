// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'DayZero';

  @override
  String get appTagline => '끊기 위한 당신만의 프라이빗 동반자';

  @override
  String get onboardingWelcomeTitle => '새로운 시작은 오늘부터';

  @override
  String get onboardingWelcomeBody =>
      '끊기 여정을 비공개로 기록하세요. 계정도, 광고도, 클라우드도 없습니다. 모든 데이터는 기기 안에만 남습니다.';

  @override
  String get onboardingChooseTitle => '무엇을 끊고 싶나요?';

  @override
  String get onboardingChooseBody => '하나 이상 선택할 수 있어요. 나중에 추가할 수도 있습니다.';

  @override
  String get onboardingDateTitle => '끊는 날은 언제인가요?';

  @override
  String get onboardingDateBody =>
      '오늘 시작하거나 미래의 날짜를 정할 수 있어요. 지금 시작하면 시작 버튼을 누르는 순간부터 카운트됩니다.';

  @override
  String get onboardingSpendTitle => '하루에 얼마나 썼나요?';

  @override
  String get onboardingSpendBody =>
      '선택 사항 — 절약한 돈을 계산하는 데 쓰여요. 나중에 수정할 수 있습니다.';

  @override
  String get perDay => '하루';

  @override
  String get currencyPlaceholder => '금액';

  @override
  String get onboardingReasonsTitle => '왜 끊고 싶나요?';

  @override
  String get onboardingReasonsBody => '이유를 적어보세요. 갈망이 올 때 보여드릴게요.';

  @override
  String get reasonPlaceholder => '예: 가족을 위해…';

  @override
  String get addReason => '이유 추가하기';

  @override
  String get startJourney => '여정 시작하기';

  @override
  String get skip => '건너뛰기';

  @override
  String get notMedicalAdvice =>
      'DayZero는 동기 부여와 기록만 제공하며 의학적 조언이 아닙니다. 심한 금단 증상이 있으면 의사와 상담하세요.';

  @override
  String get habit_alcohol => '술';

  @override
  String get habit_smoking => '흡연';

  @override
  String get habit_vaping => '베이핑';

  @override
  String get habit_sugar => '설탕';

  @override
  String get habit_caffeine => '카페인';

  @override
  String get habit_social => '소셜 미디어';

  @override
  String get habit_custom => '나만의 습관';

  @override
  String get customHabitName => '습관 이름이 뭔가요?';

  @override
  String get homeDaysSince => '일 자유';

  @override
  String get homeDaysSinceOne => '일 자유';

  @override
  String get homeTimeFree => '자유';

  @override
  String homeHoursFree(Object hours, Object minutes) {
    return '$hours시간 $minutes분 자유';
  }

  @override
  String homeDayN(Object n) {
    return '$n일째';
  }

  @override
  String get timerBrokenHint => '지금 체크인하고 0부터 다시 시작하세요';

  @override
  String get pattern444 => '4-4-4 박스';

  @override
  String get pattern55 => '5-5 균형';

  @override
  String get pattern478 => '4-7-8 심호흡';

  @override
  String get pattern446 => '4-4-6 이완';

  @override
  String get timerBroken => '연속 기록 중단됨';

  @override
  String get timerNotStarted => '체크인하면 타이머가 시작됩니다';

  @override
  String get secondUnit => '초';

  @override
  String get homeMoneySaved => '절약';

  @override
  String get homeCheckIn => '오늘 체크인';

  @override
  String get homeSOS => '갈망 SOS';

  @override
  String get homeHealthTimeline => '회복 타임라인';

  @override
  String get homeNextMilestone => '다음 이정표';

  @override
  String get homeIn => '까지';

  @override
  String get homeRelapse => '다시 하게 됐어요';

  @override
  String get homeAddHabit => '습관 추가';

  @override
  String get checkinTitle => '매일 체크인';

  @override
  String get checkinMood => '오늘 기분이 어때요?';

  @override
  String get checkinCraving => '갈망 강도';

  @override
  String get checkinTrigger => '가장 큰 유발 요인은?';

  @override
  String get trigger_none => '특별히 없음';

  @override
  String get trigger_stress => '스트레스';

  @override
  String get trigger_social => '사람들과의 자리';

  @override
  String get trigger_boredom => '지루함';

  @override
  String get trigger_habit_loop => '옛 습관 패턴';

  @override
  String get trigger_negative => '우울한 기분';

  @override
  String get trigger_celebration => '축하 자리';

  @override
  String get checkinNote => '메모 (선택)';

  @override
  String get checkinDone => '저장됐어요 — 내일 봐요';

  @override
  String get checkinEditLabel => '오늘 체크인 수정';

  @override
  String get sosTitle => '갈망 SOS';

  @override
  String get sosBody => '갈망은 몇 분 안에 정점을 찍고 지나갑니다. 충분히 버틸 수 있어요.';

  @override
  String get sosBreathing => '저와 함께 호흡해요';

  @override
  String get sosBreatheIn => '들이쉬기';

  @override
  String get sosBreatheOut => '내쉬기';

  @override
  String get sosHold => '멈추기';

  @override
  String get sosReasons => '시작한 이유를 기억하세요';

  @override
  String get sosDistract => '90초 딴짓하기';

  @override
  String get sosDistractBody => '움직이는 표적을 10번 터치';

  @override
  String get sosTapsLeft => '남음';

  @override
  String get sosDone => '해냈어요. 갈망은 지나갔습니다.';

  @override
  String get sosAgain => '한 번 더';

  @override
  String get audioUnavailable => '이 기기에서는 오디오를 사용할 수 없습니다';

  @override
  String get chooseAtLeastOne => '습관을 하나 이상 선택해 주세요';

  @override
  String get dailyAmountLabel => '하루에 얼마나? (개수)';

  @override
  String homeStreak(Object days) {
    return '$days일 연속';
  }

  @override
  String get rateLater => '나중에';

  @override
  String get statsView7 => '7일 보기';

  @override
  String get sosAmbient => '평온한 배경음';

  @override
  String premiumSaveAmount(Object amount) {
    return '$amount 절약';
  }

  @override
  String get surfingStep3 => '정점에 이르면, 결국 지나갑니다. 당신은 여전히 여기 있어요.';

  @override
  String get surfingStep2 => '파도처럼 올라오는 것을 지켜보세요. 맞서지도, 판단하지도 마세요.';

  @override
  String get surfingStep1 => '몸 안에서 갈망의 느낌을 찾아보세요. 어디에 있나요? 그저 알아차리기만 하세요.';

  @override
  String get surfingTitle => '파도 타기';

  @override
  String identityLine(Object days, Object identity) {
    return '당신은 $days일째 $identity';
  }

  @override
  String get identity_social => 'SNS에서 자유로운 사람';

  @override
  String get identity_caffeine => '카페인에서 자유로운 사람';

  @override
  String get identity_sugar => '설탕에서 자유로운 사람';

  @override
  String get identity_vaping => '베이핑에서 자유로운 사람';

  @override
  String get identity_alcohol => '비음주자';

  @override
  String get identity_smoking => '비흡연자';

  @override
  String get relapseRecordRestart => '실수를 기록하고 카운터 다시 시작';

  @override
  String get relapseRecordKeep => '실수를 기록하고 계속하기';

  @override
  String onboardingStep(Object step, Object total) {
    return '$step/$total단계';
  }

  @override
  String get plansAction => '나는 …할 것이다';

  @override
  String get plansWhen => '…할 때';

  @override
  String get plansAdd => '계획 추가';

  @override
  String get plansEmpty => '위험한 순간에 무엇을 할지 미리 적어두세요 — 필요할 때 보여드립니다';

  @override
  String get plansTitle => '나의 대처 계획';

  @override
  String insightNoCompare(Object now) {
    return '이번 주 평균 갈망: $now/5';
  }

  @override
  String insightWorse(Object now, Object prev) {
    return '이번 주 평균 갈망 $now/5 (지난주 $prev/5) — 매일 기록하는 것 자체가 중요해요';
  }

  @override
  String insightBetter(Object now, Object prev) {
    return '이번 주 평균 갈망 $now/5 (지난주 $prev/5) — 좋아지고 있어요';
  }

  @override
  String get textAuto => '자동';

  @override
  String get theme_violet => '보라';

  @override
  String get theme_sunset => '노을';

  @override
  String get theme_rose => '로즈';

  @override
  String get theme_ocean => '바다';

  @override
  String get theme_forest => '숲';

  @override
  String get theme_sage => '세이지';

  @override
  String get theme_custom => '사용자 지정';

  @override
  String get settingsTextColor => '글자 색';

  @override
  String get settingsFont => '글꼴';

  @override
  String get settingsThemes => '테마';

  @override
  String get statsView30 => '30일 보기';

  @override
  String get premiumFreeTrial => '7일 무료 체험';

  @override
  String get deleteAllConfirm => '모든 습관과 전체 기록을 삭제할까요? 되돌릴 수 없습니다.';

  @override
  String get rateAction => 'App Store에서 평가하기';

  @override
  String get rateBody => '평점을 남기면 도움이 필요한 다른 사람들이 이 앱을 찾을 수 있어요.';

  @override
  String get rateTitle => 'DayZero가 마음에 드시나요?';

  @override
  String settingsNotificationsTime(Object hour) {
    return '매일 $hour시에 살짝 알려드려요';
  }

  @override
  String get notifBody => '오늘은 어땠나요? 10초 체크인으로 연속 기록을 지켜보세요.';

  @override
  String get checkinOfferSos => '갈망이 강해 보여요. 지금 도움이 필요하세요?';

  @override
  String get settingsReasons => '나의 이유';

  @override
  String get statsTitle => '나의 진전';

  @override
  String get statsMood => '기분';

  @override
  String get statsCraving => '갈망 강도';

  @override
  String get statsWeek => '이번 주';

  @override
  String get statsMonth => '이번 달';

  @override
  String get statsAll => '전체 기간';

  @override
  String get statsCheckins => '회 체크인';

  @override
  String get statsStreak => '일 연속 체크인';

  @override
  String get statsBestStreak => '최장 연속';

  @override
  String get statsTotalFree => '누적 자유 일수';

  @override
  String get statsWeeklyReport => '주간 리포트';

  @override
  String get statsNoData => '아직 데이터가 부족해요. 매일 체크인하면 추세가 보입니다.';

  @override
  String get milestonesTitle => '이정표';

  @override
  String get milestonesUnlocked => '달성';

  @override
  String get milestonesLocked => '다가오는';

  @override
  String get milestone_1h => '첫 1시간';

  @override
  String get milestone_1d => '첫 하루';

  @override
  String get milestone_3d => '3일';

  @override
  String get milestone_1w => '1주';

  @override
  String get milestone_2w => '2주';

  @override
  String get milestone_1m => '1개월';

  @override
  String get milestone_3m => '3개월';

  @override
  String get milestone_6m => '6개월';

  @override
  String get milestone_1y => '1년';

  @override
  String get milestone_streak7 => '7일 연속 체크인';

  @override
  String get milestone_streak30 => '30일 연속 체크인';

  @override
  String get milestone_money1 => '첫 100 절약';

  @override
  String get milestone_money2 => '1,000 절약';

  @override
  String get milestone_money3 => '10,000 절약';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsHabits => '내 습관';

  @override
  String get settingsEditHabit => '편집';

  @override
  String get settingsDeleteHabit => '삭제';

  @override
  String get settingsNotifications => '매일 체크인 알림';

  @override
  String get settingsNotificationsDesc => '매일 저녁 8시에 살짝 알려드려요';

  @override
  String get settingsExport => '내 데이터 내보내기';

  @override
  String get settingsExportDesc => '전체 데이터의 JSON 백업을 파일로 저장';

  @override
  String get settingsPremium => 'DayZero 프리미엄';

  @override
  String get settingsPremiumActive => '프리미엄 활성 — 인디 앱을 응원해 주셔서 감사합니다';

  @override
  String get settingsRestore => '구매 복원';

  @override
  String get settingsPrivacy => '개인정보 처리방침';

  @override
  String get settingsTerms => '이용약관';

  @override
  String get settingsSupport => '지원';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsAboutBody =>
      'DayZero는 인디 개발자가 만들었습니다. 100% 오프라인 — 데이터가 이 기기를 떠나는 일은 없습니다.';

  @override
  String get settingsReset => '시작 날짜 재설정';

  @override
  String get settingsRelapseReset => '카운터 다시 시작';

  @override
  String get settingsDeleteData => '모든 데이터 삭제';

  @override
  String get deleteHabitConfirm => '이 습관과 모든 기록을 삭제할까요?';

  @override
  String get relapseTitle => '다시 하게 됐나요?';

  @override
  String get relapseBody =>
      '한 번의 실수가 진전을 지우지는 않아요. 카운터를 다시 시작하거나, 갈망만 기록하고 계속할 수 있습니다.';

  @override
  String get relapseRestart => '카운터 다시 시작';

  @override
  String get relapseKeep => '계속하기';

  @override
  String get premiumTitle => 'DayZero 프리미엄';

  @override
  String get premiumSubtitle => '자유롭게 지내기 위한 모든 것';

  @override
  String get premiumFeature1 => '무제한 습관';

  @override
  String get premiumFeature2 => '호흡 오디오 전체 라이브러리';

  @override
  String get premiumFeature3 => '테마·글꼴·글자 색';

  @override
  String get premiumFeature4 => '이정표 축하 세리머니';

  @override
  String get premiumFreeNote => '무료 버전은 핵심 통계와 함께 2개의 습관을 영원히 추적합니다 — 광고 없이.';

  @override
  String get premiumWeekly => '주간';

  @override
  String get premiumMonthly => '월간';

  @override
  String get premiumYearly => '연간';

  @override
  String get premiumLifetime => '평생';

  @override
  String get premiumBestValue => '최고 가성비';

  @override
  String get premiumPerWeek => '/주';

  @override
  String get premiumPerMonth => '/월';

  @override
  String get premiumPerYear => '/년';

  @override
  String get premiumOnce => '1회';

  @override
  String get premiumSubscribe => '계속';

  @override
  String get premiumRestore => '구매 복원';

  @override
  String get premiumAutoRenew =>
      '구독은 자동으로 갱신되며 Apple ID 설정에서 언제든지 취소할 수 있습니다. 현재 기간 종료 최소 24시간 전에 취소해야 합니다.';

  @override
  String premiumTermsLinks(Object privacy, Object terms) {
    return '계속하면 $terms과 $privacy에 동의하게 됩니다.';
  }

  @override
  String get termsLink => '이용약관';

  @override
  String get privacyLink => '개인정보 처리방침';

  @override
  String get buying => '처리 중…';

  @override
  String get buyError => '구매에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get restoreDone => '구매를 복원했습니다';

  @override
  String get restoreNothing => '복원할 이전 구매가 없습니다';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get save => '저장';

  @override
  String get done => '완료';

  @override
  String get close => '닫기';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get demoMode => '웹 데모 모드 — 테스트용으로 프리미엄 해제됨';

  @override
  String get exportDone => '내보내기 저장됨';

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
  String get language_system => '시스템';

  @override
  String get health_smoking_20m => '혈압과 심박수가 정상화되기 시작합니다';

  @override
  String get health_smoking_8h => '혈중 일산화탄소가 절반으로 줄어듭니다';

  @override
  String get health_smoking_24h => '심장마비 위험이 낮아지기 시작합니다';

  @override
  String get health_smoking_48h => '미각과 후각이 되살아나기 시작합니다';

  @override
  String get health_smoking_72h => '호흡이 눈에 띄게 편해집니다';

  @override
  String get health_smoking_1m => '혈액순환과 폐 기능이 좋아집니다';

  @override
  String get health_smoking_1y => '심장병 위험이 절반으로 줄어듭니다';

  @override
  String get health_vaping_24h => '니코틴 갈망이 누그러지기 시작합니다';

  @override
  String get health_vaping_48h => '호흡과 미각이 회복되기 시작합니다';

  @override
  String get health_vaping_72h => '폐 염증이 가라앉기 시작합니다';

  @override
  String get health_vaping_1w => '신체 금단 증상이 대부분 사라집니다';

  @override
  String get health_vaping_1m => '활력과 폐활량이 좋아집니다';

  @override
  String get health_alcohol_24h => '더 깊고 편안한 잠';

  @override
  String get health_alcohol_48h => '몸이 수분을 회복하고 머리가 맑아집니다';

  @override
  String get health_alcohol_1w => '간 효소 수치가 회복되기 시작합니다';

  @override
  String get health_alcohol_2w => '소화와 기분이 안정됩니다';

  @override
  String get health_alcohol_1m => '피부가 맑아지고 잠이 좋아집니다';

  @override
  String get health_alcohol_3m => '간 지방이 줄어들기 시작합니다';

  @override
  String get health_alcohol_1y => '간 회복이 크게 진행됩니다';

  @override
  String get health_sugar_1d => '혈당이 안정됩니다';

  @override
  String get health_sugar_3d => '단 음식 갈망이 줄어들기 시작합니다';

  @override
  String get health_sugar_2w => '미각이 예민해집니다';

  @override
  String get health_sugar_1m => '인슐린 민감성이 좋아집니다';

  @override
  String get health_sugar_3m => '활력과 피부가 좋아집니다';

  @override
  String get health_caffeine_1d => '금단 증상 최고조 — 조금만 버텨요';

  @override
  String get health_caffeine_3d => '두통이 가라앉기 시작합니다';

  @override
  String get health_caffeine_1w => '수면의 질이 좋아집니다';

  @override
  String get health_caffeine_2w => '하루 종일 에너지가 안정적입니다';

  @override
  String get health_caffeine_1m => '혈압이 내려갑니다';

  @override
  String get health_social_1d => '집중력이 회복되기 시작합니다';

  @override
  String get health_social_3d => '불안이 줄어듭니다';

  @override
  String get health_social_1w => '잠이 좋아집니다';

  @override
  String get health_social_2w => '기분이 안정됩니다';

  @override
  String get health_social_1m => '집중력과 생산성이 올라갑니다';

  @override
  String get dayUnit => '일';

  @override
  String get hourUnit => '시간';

  @override
  String get minuteUnit => '분';
}
