import 'package:event_dot_pizza/src/state/platform_session.dart';

class Session {
  int _numberOfConnectedPlatforms;
  Session(List<PlatformSession> _platforms) {
    _numberOfConnectedPlatforms =
        _platforms.where((platform) => platform.isConnected).length;
  }
  bool get noPlatformsConnected => _numberOfConnectedPlatforms == 0;
}
