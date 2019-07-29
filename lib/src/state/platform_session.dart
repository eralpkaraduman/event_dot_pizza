abstract class PlatformSession {
  String accessToken;
  bool get isConnected;
  Future<void> loadFromPrefs();
}
