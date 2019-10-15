import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';
import '../utils.dart';
import './platform_session.dart';

const String kSelectedLocationJson = 'selectedLocationJson';
const String kThemeBrightness = 'themeBrightness';

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

  int _themeBrightnessIndex;
  Brightness get themeBrightness {
    if (_themeBrightnessIndex == null) {
      return Brightness.light;
    } else {
      return Brightness.values[_themeBrightnessIndex];
    }
  }

  set themeBrightness(Brightness themeBrightness) {
    _themeBrightnessIndex = themeBrightness.index;
    print('Provider:Session:themeBrightness:Updated');
    _saveThemeBrightnessToPrefs();
    notifyListeners();
  }

  List<PlatformSession> _platforms;

  Session({
    @required List<PlatformSession> platforms,
    @required Location location,
    @required Brightness themeBrightness,
  }) {
    print('Provider:Session:Updated');
    _platforms = platforms;
    _anyPlatformConnected =
        platforms.where((platform) => platform.isConnected).length > 0;
    _location = location;
    _themeBrightnessIndex = themeBrightness?.index;
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

  Future<void> _saveThemeBrightnessToPrefs() async {
    print('Session:saveThemeBrightnessToPrefs');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeBrightnessIndex != null) {
      try {
        prefs.setInt(kThemeBrightness, _themeBrightnessIndex);
      } catch (_) {
        print('Failed to store themeBrightness setting');
      }
    } else {
      prefs.remove(kThemeBrightness);
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
        print('Session::tryToLoadLocationFromPrefs:failed');
      }
      if (loadedLocation != null) {
        _location = loadedLocation;
        notifyListeners();
      }
    }
  }

  _tryToLoadThemeBrightnessToPrefs() async {
    print('Session:tryToLoadThemeBrightnessFromPrefs');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeBrightnessIndex == null && prefs.containsKey(kThemeBrightness)) {
      try {
        _themeBrightnessIndex = prefs.getInt(kThemeBrightness);
      } catch (_) {
        print('Session::tryToLoadThemeBrightnessFromPrefs:failed');
      }
      if (_themeBrightnessIndex != null) {
        notifyListeners();
      }
    }
  }

  Future<void> tryToLoadFromPrefs() async {
    print('Session:tryToLoadFromPrefs');
    await _tryToLoadThemeBrightnessToPrefs();
    await _tryToLoadLocationFromPrefs();
    for (var platform in _platforms) {
      print("Session:tryToLoadFromPrefs:Platform:${platform.runtimeType}");
      await platform.tryToConnectFromPrefs();
    }
  }
}
