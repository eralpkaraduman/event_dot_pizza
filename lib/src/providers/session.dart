import 'package:flutter/material.dart';

import '../providers/platform_session.dart';

class Session extends ChangeNotifier {
  int _numberOfConnectedPlatforms;
  bool get noPlatformsConnected => _numberOfConnectedPlatforms == 0;
  bool get anyPlatformConnected => !noPlatformsConnected;

  Session(List<PlatformSession> platforms) {
    print('Provider:Session:Updated');
    this._numberOfConnectedPlatforms =
        platforms.where((platform) => platform.isConnected).length;
  }
}
