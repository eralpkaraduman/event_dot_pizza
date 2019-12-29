import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/location.dart';
import '../persistent_data.dart';

class Session extends ChangeNotifier {
  String _eventbriteAccessToken, _meetupAccessToken;
  Location _location;
  int _themeBrightnessIndex;

  void loadFromPrefs() async {
    _eventbriteAccessToken = await PersistentData.getEventbriteAccessToken();
    _meetupAccessToken = await PersistentData.getMeetupAccessToken();
    _location = await PersistentData.getLocation();
    _themeBrightnessIndex = await PersistentData.getThemeBrightnessIndex();
    notifyListeners();
  }

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
    _themeBrightnessIndex = newBrightness?.index;
    await PersistentData.setThemeBrightnessIndex(newBrightness?.index);
    notifyListeners();
  }

  Location get location => _location;
  set location(Location newLocation) {
    if (newLocation != _location) _location = newLocation;
    PersistentData.setLocation(newLocation);
    notifyListeners();
  }

  String get meetupAccessToken => _meetupAccessToken;
  set meetupAccessToken(String token) {
    if (_meetupAccessToken != token) {
      _meetupAccessToken = token;
      PersistentData.setMeetupAccessToken(token);
      notifyListeners();
    }
  }

  String get eventbriteAccessToken => _eventbriteAccessToken;
  set eventbriteAccessToken(String token) {
    if (_eventbriteAccessToken != token) {
      _eventbriteAccessToken = token;
      PersistentData.setEventbriteAccessToken(token);
      notifyListeners();
    }
  }
}
