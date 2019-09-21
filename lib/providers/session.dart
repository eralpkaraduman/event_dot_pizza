import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';
import '../utils.dart';
import './platform_session.dart';

const String kSelectedLocationJson = 'selectedLocationJson';

class Session extends ChangeNotifier {
  Location _location;
  Location get location => _location;
  set location(Location newLocation) {
    _location = newLocation;
    print('Provider:Session:location:Updated');
    _saveLocationToPrefs();
    notifyListeners();
  }

  bool _anyPlatformConnected;
  bool get anyPlatformConnected => _anyPlatformConnected;
  bool get ready => _location != null && anyPlatformConnected;

  Session({
    @required List<PlatformSession> platforms,
    @required Location location,
  }) {
    print('Provider:Session:Updated');
    _anyPlatformConnected =
        platforms.where((platform) => platform.isConnected).length > 0;
    _location = location;
  }

  Future<void> _saveLocationToPrefs() async {
    print('Session::saveLocationToPrefs');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(_location)) {
      try {
        prefs.setString(kSelectedLocationJson, jsonEncode(_location.toJson()));
      } catch (_) {
        print('Failed to store location setting');
      }
    } else {
      prefs.remove(kSelectedLocationJson);
    }
  }

  _tryToLoadLocationFromPrefs() async {
    print('Session::tryToLoadLocationFromPrefs');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isNullOrEmpty(_location) && prefs.containsKey(kSelectedLocationJson)) {
      Location loadedLocation;
      try {
        loadedLocation = Location.fromJson(jsonDecode(
          prefs.getString(kSelectedLocationJson),
        ));
      } catch (_) {
        print('MeetupPlatformSession::tryToConnectFromPrefs:failed');
      }
      if (loadedLocation != null) {
        _location = loadedLocation;
        notifyListeners();
      }
    }
  }

  Future<void> tryToLoadFromPrefs() async {
    print('Session:tryToLoadFromPrefs');
    await _tryToLoadLocationFromPrefs();
  }
}
