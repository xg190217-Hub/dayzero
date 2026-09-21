import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Breathing / celebration audio.
///
/// Lessons from the previous project, wired in from day one:
///  - Construct the player only after WidgetsFlutterBinding.ensureInitialized()
///    (main() calls AudioService.init() inside the app's boot sequence, never
///    before runApp).
///  - Initialization is observable and time-bounded: silent failure is the
///    most expensive failure. [status] is rendered on a debug screen and the
///    init future resolves to false on timeout instead of hanging forever.
enum AudioStatus { idle, initializing, ready, failed }

class AudioService {
  AudioService({this._timeout = const Duration(seconds: 5)});

  final Duration _timeout;
  AudioStatus status = AudioStatus.idle;

  AudioPlayer? _player;

  bool get isReady => status == AudioStatus.ready;

  /// Returns true when the audio backend is ready. Never throws; never hangs
  /// (the whole init is bounded by [_timeout]).
  Future<bool> init() async {
    if (status == AudioStatus.ready) return true;
    status = AudioStatus.initializing;
    try {
      _player = AudioPlayer();
      await Future.wait([
        _player!.setReleaseMode(ReleaseMode.stop),
      ]).timeout(_timeout);
      status = AudioStatus.ready;
      return true;
    } catch (e) {
      debugPrint('AudioService.init failed: $e');
      status = AudioStatus.failed;
      return false;
    }
  }

  /// Plays a bundled sound once (chimes, milestone celebrations).
  Future<void> play(String assetPath) async {
    if (!isReady) {
      if (!await init()) return;
    }
    try {
      await _player!.stop();
      await _player!.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('AudioService.play failed: $e');
    }
  }

  /// Loops a bundled sound until [stop] is called (breathing guides).
  Future<void> loop(String assetPath) async {
    if (!isReady) {
      if (!await init()) return;
    }
    try {
      await _player!.stop();
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('AudioService.loop failed: $e');
    }
  }

  Future<void> stop() async {
    if (!isReady) return;
    try {
      await _player!.stop();
      await _player!.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      debugPrint('AudioService.stop failed: $e');
    }
  }

  void dispose() {
    _player?.dispose();
    _player = null;
    status = AudioStatus.idle;
  }
}
