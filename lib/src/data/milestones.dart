import 'package:flutter/material.dart';

/// A badge the user can unlock. [at] is the number of days (or the amount of
/// money saved for money milestones) required since the quit date.
class Milestone {
  const Milestone(this.key, this.at, this.icon, {this.isMoney = false});

  final String key;

  /// Days free, or amount of local currency saved when [isMoney] is true.
  final double at;
  final IconData icon;
  final bool isMoney;
}

const List<Milestone> kTimeMilestones = [
  Milestone('milestone_1h', 0, Icons.timer, ),
  Milestone('milestone_1d', 1, Icons.looks_one),
  Milestone('milestone_3d', 3, Icons.looks_3),
  Milestone('milestone_1w', 7, Icons.filter_7),
  Milestone('milestone_2w', 14, Icons.calendar_today),
  Milestone('milestone_1m', 30, Icons.calendar_month),
  Milestone('milestone_3m', 90, Icons.workspace_premium),
  Milestone('milestone_6m', 180, Icons.diamond),
  Milestone('milestone_1y', 365, Icons.emoji_events),
];

const List<Milestone> kMoneyMilestones = [
  Milestone('milestone_money1', 100, Icons.savings, isMoney: true),
  Milestone('milestone_money2', 1000, Icons.account_balance_wallet,
      isMoney: true),
  Milestone('milestone_money3', 10000, Icons.attach_money, isMoney: true),
];

/// Streak milestones are unlocked by consecutive check-in days and carry a
/// negative "at" convention: key + threshold used by AppState directly.
const Map<String, int> kStreakMilestones = {
  'milestone_streak7': 7,
  'milestone_streak30': 30,
};
