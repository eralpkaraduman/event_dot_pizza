abstract class PlatformSession {
  String accessToken;
  bool get isConnected;
  Future<PlatformSession> loadFromPrefs();
}
