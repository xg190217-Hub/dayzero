import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../services/audio_service.dart';
import '../state/app_state.dart';
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
    with TickerProviderStateMixin {
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

  /// Urge-surfing mode (acceptance path): watch the craving like a wave
  /// instead of fighting it. Evidence: no worse than distraction overall,
  /// better for high-craving moments; both paths stay available.
  bool _surfingMode = false;
  int _surfStep = 0;
  Timer? _surfTimer;
  late final AnimationController _waveController;

  /// Cached in didChangeDependencies: dispose() may not look up providers
  /// (the element tree is already being torn down by then).
  AudioService? _audio;

  /// Breathing patterns: each is a full guide (durations + audio pair).
  /// A zero hold means the pattern skips the hold phase entirely (5-5).
  static const _patterns = [
    _Pattern('pattern446', 4, 4, 6, 'sounds/breath_in.wav', 'sounds/breath_out.wav'),
    _Pattern('pattern478', 4, 7, 8, 'sounds/breath_in.wav', 'sounds/breath_out_8.wav'),
    _Pattern('pattern55', 5, 0, 5, 'sounds/breath_in_5.wav', 'sounds/breath_out_5.wav'),
    _Pattern('pattern444', 4, 4, 4, 'sounds/breath_in.wav', 'sounds/breath_out_4.wav'),
  ];

  int _patternIndex = 0;

  _Pattern get _pattern => _patterns[_patternIndex];

  Duration _durFor(_Phase phase) => switch (phase) {
        _Phase.breatheIn => Duration(seconds: _pattern.inDur),
        _Phase.hold => Duration(seconds: _pattern.holdDur),
        _Phase.breatheOut => Duration(seconds: _pattern.outDur),
      };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: _durFor(_Phase.breatheIn))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller
            ..reset()
            ..forward();
        }
      })
      ..forward();
    _waveController = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
    _startPhase();
  }

  void _startPhase() {
    _nextPhase();
  }

  void _nextPhase() {
    _phaseTimer?.cancel();
    setState(() {
      // A zero-length hold phase is skipped (the 5-5 pattern).
      if (_phase == _Phase.breatheIn && _pattern.holdDur == 0) {
        _phase = _Phase.breatheOut;
      } else {
        _phase = switch (_phase) {
          _Phase.breatheIn => _Phase.hold,
          _Phase.hold => _Phase.breatheOut,
          _Phase.breatheOut => _Phase.breatheIn,
        };
      }
    });
    _controller
      ..duration = _durFor(_phase)
      ..reset()
      ..forward();
    if (_audioOn && !_ambientOn) _playPhaseSound();
    _phaseTimer = Timer(_durFor(_phase), _nextPhase);
  }

  Future<void> _playPhaseSound() async {
    final audio = _audio;
    if (audio == null) return;
    switch (_phase) {
      case _Phase.breatheIn:
        await audio.loop(_pattern.inFile);
      case _Phase.hold:
        await audio.stop();
      case _Phase.breatheOut:
        await audio.loop(_pattern.outFile);
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

  static const _ambientFiles = <String, String>{
    'music': 'sounds/calm_ambient.wav',
    'rain': 'sounds/rain.wav',
    'ocean': 'sounds/ocean.wav',
    'forest': 'sounds/forest.wav',
    'fire': 'sounds/campfire.wav',
  };

  String _ambientLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case 'rain':
        return l10n.ambientRain;
      case 'ocean':
        return l10n.ambientOcean;
      case 'forest':
        return l10n.ambientForest;
      case 'fire':
        return l10n.ambientFire;
      default:
        return l10n.ambientMusic;
    }
  }

  /// Premium ambient library: five synthesized nature soundscapes.
  Future<void> _pickAmbient() async {
    final state = context.read<AppState>();
    final l10n = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _ambientFiles.keys.map((code) {
            final active = state.ambientCode == code && _ambientOn;
            return ListTile(
              leading: Icon(
                code == state.ambientCode
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(_ambientLabel(l10n, code)),
              trailing: active ? const Icon(Icons.volume_up) : null,
              onTap: () => Navigator.of(sheetContext).pop(code),
            );
          }).toList(),
        ),
      ),
    );
    if (picked == null) return;
    final audio = _audio;
    if (audio == null) return;
    if (picked == state.ambientCode && _ambientOn) {
      // Tapping the active sound turns it off.
      await audio.stop();
      if (mounted) setState(() => _ambientOn = false);
      return;
    }
    await state.setAmbient(picked);
    if (mounted) {
      setState(() {
        _ambientOn = true;
        _audioOn = false;
      });
    }
    await audio.loop(_ambientFiles[picked]!);
    _checkAudioHealth();
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
    _surfTimer?.cancel();
    _controller.dispose();
    _waveController.dispose();
    _audio?.stop();
    super.dispose();
  }

  void _startSurfing() {
    _surfTimer?.cancel();
    _surfStep = 0;
    _surfTimer = Timer.periodic(const Duration(seconds: 40), (_) {
      if (mounted) {
        setState(() => _surfStep = (_surfStep + 1) % 3);
      }
    });
  }

  String _phaseLabel(AppLocalizations l10n) => switch (_phase) {
        _Phase.breatheIn => l10n.sosBreatheIn,
        _Phase.hold => l10n.sosHold,
        _Phase.breatheOut => l10n.sosBreatheOut,
      };

  String _patternLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'pattern478':
        return l10n.pattern478;
      case 'pattern55':
        return l10n.pattern55;
      case 'pattern444':
        return l10n.pattern444;
      default:
        return l10n.pattern446;
    }
  }

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
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: List.generate(_patterns.length, (i) {
                      final selected = i == _patternIndex;
                      return ChoiceChip(
                        label: Text(_patternLabel(l10n, _patterns[i].key)),
                        selected: selected,
                        onSelected: (_) => setState(() {
                          _patternIndex = i;
                          _phase = _Phase.breatheIn;
                          _controller
                            ..duration = _durFor(_phase)
                            ..reset()
                            ..forward();
                          _phaseTimer?.cancel();
                          _phaseTimer = Timer(_durFor(_phase), _nextPhase);
                          if (_audioOn && !_ambientOn) _playPhaseSound();
                        }),
                      );
                    }),
                  ),
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
                      // Ambient soundscape library (premium).
                      IconButton.filledTonal(
                        icon: Icon(_ambientOn
                            ? Icons.waves
                            : state.isPremium
                                ? Icons.waves_outlined
                                : Icons.lock_outline),
                        tooltip: l10n.sosAmbient,
                        onPressed: state.isPremium
                            ? _pickAmbient
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
                              Icon(Icons.route,
                                  color: Theme.of(context).colorScheme.primary, size: 18),
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
                              Icon(Icons.favorite,
                                  color: Theme.of(context).colorScheme.primary, size: 18),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Two evidence-based ways to ride out a craving:
                  // distraction (fast peak relief) and urge surfing
                  // (acceptance — long-term desensitization).
                  Center(
                    child: SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                            value: false, label: Text(l10n.sosDistract)),
                        ButtonSegment(
                            value: true, label: Text(l10n.surfingTitle)),
                      ],
                      selected: {_surfingMode},
                      onSelectionChanged: (s) {
                        setState(() {
                          _surfingMode = s.first;
                          _distractActive = false;
                          _taps = 0;
                        });
                        if (_surfingMode) _startSurfing();
                      },
                      showSelectedIcon: false,
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_surfingMode)
                    _distractActive
                        ? _distractionGame(l10n)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                          )
                  else
                    _surfingView(l10n, scheme),
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

  /// Urge surfing: an animated wave + three 40-second guided steps that
  /// teach the user to watch the craving pass instead of fighting it.
  Widget _surfingView(AppLocalizations l10n, ColorScheme scheme) {
    final stepText = switch (_surfStep) {
      0 => l10n.surfingStep1,
      1 => l10n.surfingStep2,
      _ => l10n.surfingStep3,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 90,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, _) => CustomPaint(
              painter: _WavePainter(
                phase: _waveController.value,
                color: scheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          stepText,
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(3, (i) {
            final active = i == _surfStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 6),
              width: active ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active
                    ? scheme.primary
                    : scheme.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.sosDone,
          style: TextStyle(color: scheme.outline, fontSize: 13),
        ),
      ],
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

/// A single drifting sine wave: the urge-surfing visual metaphor.
class _WavePainter extends CustomPainter {
  _WavePainter({required this.phase, required this.color});

  /// 0..1 — the wave drifts as it advances.
  final double phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = color;
    final path = Path();
    for (var x = 0.0; x <= size.width; x += 2) {
      final t = x / size.width;
      final y = size.height / 2 +
          sin(t * 2 * pi * 2 + phase * 2 * pi) * 18;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.color != color;
}

/// One breathing guide: phase durations (seconds) + the synthesized audio
/// pair that accompanies inhale/exhale.
class _Pattern {
  const _Pattern(this.key, this.inDur, this.holdDur, this.outDur, this.inFile, this.outFile);
  final String key;
  final int inDur;
  final int holdDur;
  final int outDur;
  final String inFile;
  final String outFile;
}
