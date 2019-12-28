import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/location.dart';
import '../models/persistent_data.dart';

class Session extends ChangeNotifier {
  String _eventbriteAccessToken, _meetupAccessToken;
  Location _location;
  int _themeBrightnessIndex;
  Session({
    String eventbriteAccessToken,
    String meetupAccessToken,
    Location location,
    int themeBrightnessIndex,
  }) {
    _eventbriteAccessToken = eventbriteAccessToken;
    _meetupAccessToken = meetupAccessToken;
    _location = location;
    _themeBrightnessIndex = themeBrightnessIndex;
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
  Future<void> setLocation(Location newLocation) async {
    _location = newLocation;
    await PersistentData.setLocation(newLocation);
    notifyListeners();
  }

  String get meetupAccessToken => _meetupAccessToken;
  Future<void> setMeetupAccessToken(String token) async {
    _meetupAccessToken = token;
    await PersistentData.setMeetupAccessToken(token);
    notifyListeners();
  }

  String get eventbriteAccessToken => _eventbriteAccessToken;
  Future<void> setEventbriteAccessToken(String token) async {
    _eventbriteAccessToken = token;
    await PersistentData.setEventbriteAccessToken(token);
    notifyListeners();
  }
}
