// On web we use the stub so we never activate audioplayers (avoids MissingPluginException).
// On mobile/desktop we use the real implementation.
import 'chime_player_impl.dart'
    if (dart.library.html) 'chime_player_stub.dart' as impl;

abstract final class ChimePlayer {
  static Future<void> play() async {
    await impl.ChimePlayerImpl.play();
  }
}
