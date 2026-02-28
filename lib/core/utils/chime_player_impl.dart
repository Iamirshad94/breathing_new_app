import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

final class ChimePlayerImpl {
  ChimePlayerImpl._();
  static AudioPlayer? _player;
  static bool _pluginFailed = false;
  static const _chimeAsset = 'assets/audio/sound.mp3';

  static Future<void> play() async {
    if (_pluginFailed) return;
    await runZonedGuarded<Future<void>>(() async {
      try {
        if (_player == null) {
          try {
            _player = AudioPlayer();
          } on MissingPluginException {
            _pluginFailed = true;
            return;
          }
        }
        await _player!.play(AssetSource(_chimeAsset));
      } on MissingPluginException {
        _pluginFailed = true;
      } catch (_) {}
    }, (error, stack) {
      _pluginFailed = true;
    });
  }
}
