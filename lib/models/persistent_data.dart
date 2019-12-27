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
  static Future<void> setThemeBrightnessIndex(int themeBrightnessIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (themeBrightnessIndex != null) {
      await prefs.setInt(kThemeBrightness, themeBrightnessIndex);
    } else {
      await prefs.remove(kThemeBrightness);
    }
  }

  // LOCATION
  Location _location;
  Location get location => _location;
  static Future<void> setLocation(Location location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(location)) {
      await prefs.setString(
          kSelectedLocationJson, jsonEncode(location.toJson()));
    } else {
      await prefs.remove(kSelectedLocationJson);
    }
  }

  // EVENTBRITE ACCESS TOKEN
  String _eventbriteAccessToken;
  String get eventbriteAccessToken => _eventbriteAccessToken;
  static Future<void> setEventbriteAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(accessToken)) {
      await prefs.setString(kEventbriteAccessToken, accessToken);
    } else {
      await prefs.remove(kEventbriteAccessToken);
    }
  }

  // MEETUP ACCESS TOKEN
  String _meetupAccessToken;
  String get meetupAccessToken => _meetupAccessToken;
  static Future<void> setMeetupAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(accessToken)) {
      await prefs.setString(kMeetupAccessToken, accessToken);
    } else {
      await prefs.remove(kMeetupAccessToken);
    }
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
}
