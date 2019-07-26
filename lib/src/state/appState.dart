import 'package:event_dot_pizza/src/state/platform_session.dart';

class AppState {
  final List<PlatformSession> _platformSessions;
  const AppState(this._platformSessions);
  List<PlatformSession> get connectedPlatformSessions =>
      _platformSessions.where((platform) => platform.isConnected).toList();
  bool get noPlatformConnected => connectedPlatformSessions.length == 0;
}
