import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/location.dart';
import '../models/persistent_data.dart';

class Session extends ChangeNotifier {
  PersistentData _data;
  Session(this._data);

  bool get anyPlatformConnected => [
        _data.eventbriteAccessToken,
        _data.meetupAccessToken,
      ].any((token) => token != null);

  bool get ready => anyPlatformConnected && _data.location != null;

  Brightness get themeBrightness {
    final themeBrightnessIndex =
        _data?.themeBrightnessIndex ?? Brightness.light.index;
    return Brightness.values[themeBrightnessIndex];
  }

  Future<void> setThemeBrightness(Brightness newBrightness) async {
    await _data.setThemeBrightnessIndex(newBrightness?.index);
    notifyListeners();
  }

  Location get location => _data.location;
  Future<void> setLocation(Location newLocation) async {
    await _data.setLocation(newLocation);
    notifyListeners();
  }

  String get meetupAccessToken => _data.meetupAccessToken;
  Future<void> setMeetupAccessToken(String token) async {
    await _data.setMeetupAccessToken(token);
    notifyListeners();
  }

  String get eventbriteAccessToken => _data.meetupAccessToken;
  Future<void> setEventbriteAccessToken(String token) async {
    await _data.setEventbriteAccessToken(token);
    notifyListeners();
  }
}
