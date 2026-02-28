final class ChimePlayerImpl {
  ChimePlayerImpl._();

  static Future<void> play() async {
    // No-op on web: audioplayers plugin is not implemented, avoids MissingPluginException.
  }
}
