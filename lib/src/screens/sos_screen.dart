import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../services/audio_service.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'paywall_screen.dart';

/// Craving SOS: 4-4-6 box breathing with audio + reasons + a 90-second
/// distraction game. The whole screen is one calming loop.
class SosScreen extends StatefulWidget {
  const SosScreen({super.key, required this.habit});

  final Habit habit;

  @override
  State<SosScreen> createState() => _SosScreenState();
}

enum _Phase { breatheIn, hold, breatheOut }

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  _Phase _phase = _Phase.breatheIn;
  Timer? _phaseTimer;
  bool _audioOn = false;
  int _taps = 0;
  int _tapTarget = 10;
  Offset _target = const Offset(0.5, 0.5);
  bool _distractActive = false;
  final Random _random = Random();
  bool _ambientOn = false;

  /// Cached in didChangeDependencies: dispose() may not look up providers
  /// (the element tree is already being torn down by then).
  AudioService? _audio;

  static const _durations = {
    _Phase.breatheIn: Duration(seconds: 4),
    _Phase.hold: Duration(seconds: 4),
    _Phase.breatheOut: Duration(seconds: 6),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: _durations[_Phase.breatheIn]!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller
            ..reset()
            ..forward();
        }
      })
      ..forward();
    _startPhase();
  }

  void _startPhase() {
    _nextPhase();
  }

  void _nextPhase() {
    _phaseTimer?.cancel();
    setState(() {
      _phase = switch (_phase) {
        _Phase.breatheIn => _Phase.hold,
        _Phase.hold => _Phase.breatheOut,
        _Phase.breatheOut => _Phase.breatheIn,
      };
    });
    _controller
      ..duration = _durations[_phase]!
      ..reset()
      ..forward();
    if (_audioOn && !_ambientOn) _playPhaseSound();
    _phaseTimer = Timer(_durations[_phase]!, _nextPhase);
  }

  Future<void> _playPhaseSound() async {
    final audio = _audio;
    if (audio == null) return;
    switch (_phase) {
      case _Phase.breatheIn:
        await audio.loop('sounds/breath_in.wav');
      case _Phase.hold:
        await audio.stop();
      case _Phase.breatheOut:
        await audio.loop('sounds/breath_out.wav');
    }
  }

  Future<void> _toggleAudio() async {
    final audio = _audio;
    if (audio == null) return;
    if (_audioOn) {
      await audio.stop();
      if (mounted) setState(() => _audioOn = false);
    } else {
      // The two modes are mutually exclusive — keep both flags honest.
      if (mounted) {
        setState(() {
          _audioOn = true;
          _ambientOn = false;
        });
      }
      await _playPhaseSound();
      _checkAudioHealth();
    }
  }

  /// Premium calm-ambient loop (second sound of the audio library).
  Future<void> _toggleAmbient() async {
    final audio = _audio;
    if (audio == null) return;
    if (_ambientOn) {
      await audio.stop();
      if (mounted) setState(() => _ambientOn = false);
    } else {
      if (mounted) {
        setState(() {
          _ambientOn = true;
          _audioOn = false;
        });
      }
      await audio.loop('sounds/calm_ambient.wav');
      _checkAudioHealth();
    }
  }

  /// Silent audio failure is the most expensive failure: surface it.
  void _checkAudioHealth() {
    final audio = _audio;
    if (audio == null || !mounted) return;
    if (audio.status == AudioStatus.failed) {
      setState(() {
        _audioOn = false;
        _ambientOn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).audioUnavailable)));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audio ??= context.read<AudioService>();
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _controller.dispose();
    _audio?.stop();
    super.dispose();
  }

  String _phaseLabel(AppLocalizations l10n) => switch (_phase) {
        _Phase.breatheIn => l10n.sosBreatheIn,
        _Phase.hold => l10n.sosHold,
        _Phase.breatheOut => l10n.sosBreatheOut,
      };

  String _triggerLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'trigger_stress':
        return l10n.trigger_stress;
      case 'trigger_social':
        return l10n.trigger_social;
      case 'trigger_boredom':
        return l10n.trigger_boredom;
      case 'trigger_habit_loop':
        return l10n.trigger_habit_loop;
      case 'trigger_negative':
        return l10n.trigger_negative;
      case 'trigger_celebration':
        return l10n.trigger_celebration;
      default:
        return l10n.trigger_none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sosTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            l10n.sosBody,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(l10n.sosBreathing,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final t = Curves.easeInOut
                            .transform(_controller.value);
                        final scale = switch (_phase) {
                          _Phase.breatheIn => 0.55 + 0.45 * t,
                          _Phase.hold => 1.0,
                          _Phase.breatheOut => 1.0 - 0.45 * t,
                        };
                        return Center(
                          child: Container(
                            width: 170 * scale,
                            height: 170 * scale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                // Theme-derived: the circle follows the
                                // user's palette instead of staying green.
                                colors: [
                                  scheme.primaryContainer,
                                  scheme.primary.withValues(alpha: 0.25),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _phaseLabel(l10n),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Breathing guide audio (free).
                      IconButton.filledTonal(
                        icon: Icon(
                            _audioOn ? Icons.volume_up : Icons.volume_off),
                        tooltip: l10n.sosBreathing,
                        onPressed: _toggleAudio,
                      ),
                      const SizedBox(width: 16),
                      // Calm ambient loop (premium).
                      IconButton.filledTonal(
                        icon: Icon(_ambientOn
                            ? Icons.waves
                            : state.isPremium
                                ? Icons.waves_outlined
                                : Icons.lock_outline),
                        tooltip: l10n.sosAmbient,
                        onPressed: state.isPremium
                            ? _toggleAmbient
                            : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const PaywallScreen())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (state.plans.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.plansTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                    const SizedBox(height: 12),
                    // The pre-committed if-then plans, shown exactly when
                    // the situation they were written for arrives.
                    ...state.plans.map((p) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.route,
                                  color: kLeafGreen, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                    '${l10n.plansWhen} ${_triggerLabel(l10n, p.trigger)} → ${p.action}'),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
          if (state.reasons.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.sosReasons,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                    const SizedBox(height: 12),
                    ...state.reasons.map((r) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.favorite,
                                  color: kLeafGreen, size: 18),
                              const SizedBox(width: 10),
                              Expanded(child: Text(r)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _distractActive
                  ? _distractionGame(l10n)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.sosDistract,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(l10n.sosDistractBody,
                            style: TextStyle(color: scheme.outline)),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed: () => setState(() {
                            _distractActive = true;
                            _taps = 0;
                          }),
                          child: Text(l10n.sosAgain),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              context.read<AudioService>().stop();
              Navigator.of(context).pop();
            },
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }

  Widget _distractionGame(AppLocalizations l10n) {
    final remaining = _tapTarget - _taps;
    if (remaining <= 0) {
      return Column(
        children: [
          Text(l10n.sosDone,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => setState(() {
              _taps = 0;
              _tapTarget = 10;
            }),
            child: Text(l10n.sosAgain),
          ),
        ],
      );
    }
    return Column(
      children: [
        Text('${l10n.sosTapsLeft}: $remaining',
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16)),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    left: _target.dx * (constraints.maxWidth - 56),
                    top: _target.dy * (constraints.maxHeight - 56),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _taps++;
                        _target = Offset(
                            _random.nextDouble(), _random.nextDouble());
                      }),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.habit.type.color,
                          boxShadow: [
                            BoxShadow(
                              color: widget.habit.type.color
                                  .withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.touch_app,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
