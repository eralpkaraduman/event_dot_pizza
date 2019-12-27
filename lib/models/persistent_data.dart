import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';
import '../utils.dart';

const String kThemeBrightness = 'themeBrightness';
const String kSelectedLocationJson = 'selectedLocationJson';
const String kEventbriteAccessToken = 'eventbriteAccessToken';
const String kMeetupAccessToken = 'meetupAccessToken';

class PersistentData {
  PersistentData(
    this._themeBrightnessIndex,
    this._location,
    this._eventbriteAccessToken,
    this._meetupAccessToken,
  );

  // THEME BRIGHTNESS
  int _themeBrightnessIndex;
  int get themeBrightnessIndex => _themeBrightnessIndex;

  Future<void> setThemeBrightnessIndex(int newIndex) async {
    _themeBrightnessIndex = newIndex;
    await _saveToPrefs();
  }

  // LOCATION
  Location _location;
  Location get location => _location;
  Future<void> setLocation(Location newLocation) async {
    _location = newLocation;
    await _saveToPrefs();
  }

  // EVENTBRITE ACCESS TOKEN
  String _eventbriteAccessToken;
  String get eventbriteAccessToken => _eventbriteAccessToken;
  Future<void> setEventbriteAccessToken(String accessToken) async {
    _eventbriteAccessToken = accessToken;
    await _saveToPrefs();
  }

  // MEETUP ACCESS TOKEN
  String _meetupAccessToken;
  String get meetupAccessToken => _meetupAccessToken;
  Future<void> setMeetupAccessToken(String accessToken) async {
    _meetupAccessToken = accessToken;
    await _saveToPrefs();
  }

  static Future<PersistentData> createFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeBrightnessIndex;
    if (prefs.containsKey(kThemeBrightness)) {
      themeBrightnessIndex = prefs.getInt(kThemeBrightness);
    }

    Location location;
    if (prefs.containsKey(kSelectedLocationJson)) {
      location =
          Location.fromJson(jsonDecode(prefs.getString(kSelectedLocationJson)));
    }

    String eventbriteAccessToken;
    if (prefs.containsKey(kEventbriteAccessToken)) {
      eventbriteAccessToken = prefs.getString(kEventbriteAccessToken);
    }

    String meetupAccessToken;
    if (prefs.containsKey(kMeetupAccessToken)) {
      meetupAccessToken = prefs.getString(kMeetupAccessToken);
    }

    return PersistentData(
      themeBrightnessIndex,
      location,
      eventbriteAccessToken,
      meetupAccessToken,
    );
  }

  Future<void> _saveToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_themeBrightnessIndex != null) {
      await prefs.setInt(kThemeBrightness, _themeBrightnessIndex);
    } else {
      await prefs.remove(kThemeBrightness);
    }

    if (!isNullOrEmpty(_location)) {
      await prefs.setString(
          kSelectedLocationJson, jsonEncode(_location.toJson()));
    } else {
      await prefs.remove(kSelectedLocationJson);
    }

    if (!isNullOrEmpty(_eventbriteAccessToken)) {
      await prefs.setString(kEventbriteAccessToken, _eventbriteAccessToken);
    } else {
      await prefs.remove(kEventbriteAccessToken);
    }

    if (!isNullOrEmpty(_meetupAccessToken)) {
      await prefs.setString(kMeetupAccessToken, _meetupAccessToken);
    } else {
      await prefs.remove(kMeetupAccessToken);
    }
  }
}
