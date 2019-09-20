import 'package:flutter/foundation.dart';
import '../models/location.dart';
import './platform_session.dart';

class Session extends ChangeNotifier {
  bool anyPlatformConnected;

  Location _location;
  Location get location => _location;
  set location(Location newLocation) {
    _location = newLocation;
    print('Provider:Session:location:Updated');
    notifyListeners();
  }

  Session({List<PlatformSession> platforms, Location location}) {
    print('Provider:Session:Updated');
    anyPlatformConnected =
        platforms.where((platform) => platform.isConnected).length > 0;
    location = _location;
  }
}
