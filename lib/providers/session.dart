import 'package:flutter/material.dart';

import './platform_session.dart';

class Session extends ChangeNotifier {
  bool anyPlatformConnected;
  Session({List<PlatformSession> platforms}) {
    print('Provider:Session:Updated');
    anyPlatformConnected =
        platforms.where((platform) => platform.isConnected).length > 0;
  }
}
