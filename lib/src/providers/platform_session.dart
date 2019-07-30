abstract class PlatformSession {
  String get accessToken;
  bool get isConnected;
  connect(String accessToken);
  disconnect();
  Future<void> tryToLoadFromPrefs();
}
