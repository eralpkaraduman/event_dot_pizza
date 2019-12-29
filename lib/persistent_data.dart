import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './models/location.dart';
import './utils.dart';

const String kThemeBrightness = 'themeBrightness';
const String kSelectedLocationJson = 'selectedLocationJson';
const String kEventbriteAccessToken = 'eventbriteAccessToken';
const String kMeetupAccessToken = 'meetupAccessToken';

class PersistentData {
  // THEME BRIGHTNESS
  static Future<int> getThemeBrightnessIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeBrightnessIndex;
    if (prefs.containsKey(kThemeBrightness)) {
      themeBrightnessIndex = prefs.getInt(kThemeBrightness);
    }
    return themeBrightnessIndex;
  }

  static Future<void> setThemeBrightnessIndex(int themeBrightnessIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (themeBrightnessIndex != null) {
      await prefs.setInt(kThemeBrightness, themeBrightnessIndex);
    } else {
      await prefs.remove(kThemeBrightness);
    }
  }

  // LOCATION
  static Future<Location> getLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Location location;
    if (prefs.containsKey(kSelectedLocationJson)) {
      location =
          Location.fromJson(jsonDecode(prefs.getString(kSelectedLocationJson)));
    }
    return location;
  }

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
  static Future<String> getEventbriteAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String eventbriteAccessToken;
    if (prefs.containsKey(kEventbriteAccessToken)) {
      eventbriteAccessToken = prefs.getString(kEventbriteAccessToken);
    }
    return eventbriteAccessToken;
  }

  static Future<void> setEventbriteAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(accessToken)) {
      await prefs.setString(kEventbriteAccessToken, accessToken);
    } else {
      await prefs.remove(kEventbriteAccessToken);
    }
  }

  // MEETUP ACCESS TOKEN
  static Future<String> getMeetupAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String meetupAccessToken;
    if (prefs.containsKey(kMeetupAccessToken)) {
      meetupAccessToken = prefs.getString(kMeetupAccessToken);
    }
    return meetupAccessToken;
  }

  static Future<void> setMeetupAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(accessToken)) {
      await prefs.setString(kMeetupAccessToken, accessToken);
    } else {
      await prefs.remove(kMeetupAccessToken);
    }
  }
}
