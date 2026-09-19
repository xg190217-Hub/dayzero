import '../l10n/app_localizations.dart';

/// Dynamic-key lookups: health-timeline facts and milestones are addressed by
/// string keys at runtime, which generated getters can't cover.
extension L10nX on AppLocalizations {
  String healthLabel(String key) {
    switch (key) {
      case 'health_smoking_20m':
        return health_smoking_20m;
      case 'health_smoking_8h':
        return health_smoking_8h;
      case 'health_smoking_24h':
        return health_smoking_24h;
      case 'health_smoking_48h':
        return health_smoking_48h;
      case 'health_smoking_72h':
        return health_smoking_72h;
      case 'health_smoking_1m':
        return health_smoking_1m;
      case 'health_smoking_1y':
        return health_smoking_1y;
      case 'health_vaping_24h':
        return health_vaping_24h;
      case 'health_vaping_48h':
        return health_vaping_48h;
      case 'health_vaping_72h':
        return health_vaping_72h;
      case 'health_vaping_1w':
        return health_vaping_1w;
      case 'health_vaping_1m':
        return health_vaping_1m;
      case 'health_alcohol_24h':
        return health_alcohol_24h;
      case 'health_alcohol_48h':
        return health_alcohol_48h;
      case 'health_alcohol_1w':
        return health_alcohol_1w;
      case 'health_alcohol_2w':
        return health_alcohol_2w;
      case 'health_alcohol_1m':
        return health_alcohol_1m;
      case 'health_alcohol_3m':
        return health_alcohol_3m;
      case 'health_alcohol_1y':
        return health_alcohol_1y;
      case 'health_sugar_1d':
        return health_sugar_1d;
      case 'health_sugar_3d':
        return health_sugar_3d;
      case 'health_sugar_2w':
        return health_sugar_2w;
      case 'health_sugar_1m':
        return health_sugar_1m;
      case 'health_sugar_3m':
        return health_sugar_3m;
      case 'health_caffeine_1d':
        return health_caffeine_1d;
      case 'health_caffeine_3d':
        return health_caffeine_3d;
      case 'health_caffeine_1w':
        return health_caffeine_1w;
      case 'health_caffeine_2w':
        return health_caffeine_2w;
      case 'health_caffeine_1m':
        return health_caffeine_1m;
      case 'health_social_1d':
        return health_social_1d;
      case 'health_social_3d':
        return health_social_3d;
      case 'health_social_1w':
        return health_social_1w;
      case 'health_social_2w':
        return health_social_2w;
      case 'health_social_1m':
        return health_social_1m;
      default:
        return key;
    }
  }

  String milestoneLabel(String key) {
    switch (key) {
      case 'milestone_1h':
        return milestone_1h;
      case 'milestone_1d':
        return milestone_1d;
      case 'milestone_3d':
        return milestone_3d;
      case 'milestone_1w':
        return milestone_1w;
      case 'milestone_2w':
        return milestone_2w;
      case 'milestone_1m':
        return milestone_1m;
      case 'milestone_3m':
        return milestone_3m;
      case 'milestone_6m':
        return milestone_6m;
      case 'milestone_1y':
        return milestone_1y;
      case 'milestone_streak7':
        return milestone_streak7;
      case 'milestone_streak30':
        return milestone_streak30;
      case 'milestone_money1':
        return milestone_money1;
      case 'milestone_money2':
        return milestone_money2;
      case 'milestone_money3':
        return milestone_money3;
      default:
        return key;
    }
  }
}
