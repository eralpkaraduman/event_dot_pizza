import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatformSession with ChangeNotifier {
  String _accessToken;
  String get accessToken => _accessToken;
  set accessToken(value) {
    _accessToken = value;
    MeetupPlatformSession.saveAccessTokenToPrefs(value);
    notifyListeners();
  }

  bool get isConnected => !isNullOrEmpty(accessToken);

  MeetupPlatformSession(String accessToken) {
    this._accessToken = accessToken;
  }

  static Future<String> loadAccessTokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kMeetupAccessToken) ?? null;
  }

  static void saveAccessTokenToPrefs(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(value)) {
      prefs.setString(kMeetupAccessToken, value);
    } else {
      prefs.remove(kMeetupAccessToken);
    }
  }
}
