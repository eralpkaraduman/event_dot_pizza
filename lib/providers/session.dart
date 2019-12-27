import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/location.dart';
import '../models/persistent_data.dart';

class Session extends ChangeNotifier {
  String _eventbriteAccessToken, _meetupAccessToken;
  Location _location;
  int _themeBrightnessIndex;
  Session(
    this._eventbriteAccessToken,
    this._meetupAccessToken,
    this._location,
    this._themeBrightnessIndex,
  );

  bool get anyPlatformConnected => [
        eventbriteAccessToken,
        meetupAccessToken,
      ].any((token) => token != null);

  bool get ready => anyPlatformConnected && location != null;

  Brightness get themeBrightness {
    final themeBrightnessIndex =
        _themeBrightnessIndex ?? Brightness.light.index;
    return Brightness.values[themeBrightnessIndex];
  }

  int get themeBrightnessIndex => _themeBrightnessIndex;

  Future<void> setThemeBrightness(Brightness newBrightness) async {
    await PersistentData.setThemeBrightnessIndex(newBrightness?.index);
    notifyListeners();
  }

  Location get location => _location;
  Future<void> setLocation(Location newLocation) async {
    await PersistentData.setLocation(newLocation);
    notifyListeners();
  }

  String get meetupAccessToken => _meetupAccessToken;
  Future<void> setMeetupAccessToken(String token) async {
    await PersistentData.setMeetupAccessToken(token);
    notifyListeners();
  }

  String get eventbriteAccessToken => _eventbriteAccessToken;
  Future<void> setEventbriteAccessToken(String token) async {
    await PersistentData.setEventbriteAccessToken(token);
    notifyListeners();
  }
}
