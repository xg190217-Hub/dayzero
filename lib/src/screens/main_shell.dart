import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../services/notifications.dart';
import '../state/app_state.dart';
import 'home_screen.dart';
import 'milestones_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Re-assert the daily reminder with localized strings on every launch.
    WidgetsBinding.instance.addPostFrameCallback((_) => _reschedule());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Day-based counters must refresh when the app returns from the
  /// background — otherwise a device that slept past midnight still shows
  /// yesterday's number.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {});
      _reschedule();
    }
  }

  Future<void> _reschedule() async {
    final state = context.read<AppState>();
    if (!state.notificationsEnabled) return;
    final l10n = AppLocalizations.of(context);
    await context.read<NotificationService>().scheduleDaily(
          title: l10n.appTitle,
          body: l10n.notifBody,
          hour: state.reminderHour,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = const [
      HomeScreen(),
      StatsScreen(),
      MilestonesScreen(),
      SettingsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.appTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: l10n.statsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: l10n.milestonesTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settingsTitle,
          ),
        ],
      ),
    );
  }
}
