import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';
import '../utils.dart';
import './platform_session.dart';

const String kSelectedLocationJson = 'selectedLocationJson';

class Session extends ChangeNotifier {
  bool anyPlatformConnected;

  Location _location;
  Location get location => _location;
  set location(Location newLocation) {
    _location = newLocation;
    print('Provider:Session:location:Updated');
    notifyListeners();
    scheduleMicrotask(() => _saveLocationToPrefs());
  }

  Session(
      {@required List<PlatformSession> platforms,
      @required Location location}) {
    print('Provider:Session:Updated');
    anyPlatformConnected =
        platforms.where((platform) => platform.isConnected).length > 0;
    location = _location;
  }

  Future<void> _saveLocationToPrefs() async {
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

  Future<void> tryToLoadLocationFromPrefs() async {
    print('tryToLoadLocationFromPrefs');
    if (_location != null) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(kSelectedLocationJson)) {
      return;
    }
    try {
      _location = Location.fromJson(jsonDecode(
        prefs.getString(kSelectedLocationJson),
      ));
    } catch (_) {
      print('Failed to load stored location setting');
      _location = null;
    }
    notifyListeners();
  }
}
