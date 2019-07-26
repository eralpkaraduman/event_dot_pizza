import 'package:event_dot_pizza/src/state/meetupPlatformSession.dart';
import 'package:event_dot_pizza/src/state/otherPlatformSession.dart';

class AppState {
  final MeetupPlatformSession _meetupPlatformSession;
  final OtherPlatformSession _otherPlatformSession;
  const AppState(this._meetupPlatformSession, this._otherPlatformSession);
  bool get noPlatformConnected => ![
        _meetupPlatformSession.isConnected,
        _otherPlatformSession.isConnected
      ].contains(true);
}
