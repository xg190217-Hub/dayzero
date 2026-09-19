import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../services/audio_service.dart';
import '../state/app_state.dart';
import '../theme.dart';

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
    if (_audioOn) _playPhaseSound();
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
      setState(() => _audioOn = false);
    } else {
      setState(() => _audioOn = true);
      await _playPhaseSound();
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
                          fontFamily: 'DayZeroNunito',
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
                                colors: [
                                  kSage.withValues(alpha: 0.9),
                                  kLeafGreen.withValues(alpha: 0.25),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _phaseLabel(l10n),
                                style: const TextStyle(
                                  fontFamily: 'DayZeroNunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: kDeepGreen,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  IconButton.filledTonal(
                    icon: Icon(_audioOn ? Icons.volume_up : Icons.volume_off),
                    onPressed: _toggleAudio,
                  ),
                ],
              ),
            ),
          ),
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
                            fontFamily: 'DayZeroNunito',
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
                                fontFamily: 'DayZeroNunito',
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
                  fontFamily: 'DayZeroNunito',
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
                fontFamily: 'DayZeroNunito',
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
