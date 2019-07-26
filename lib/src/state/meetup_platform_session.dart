import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/utils.dart';
import 'package:event_dot_pizza/src/state/platform_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatformSession with ChangeNotifier implements PlatformSession {
  String _accessToken;
  String get accessToken => _accessToken;
  set accessToken(value) {
    _accessToken = value;
    MeetupPlatformSession._saveAccessTokenToPrefs(value);
    notifyListeners();
  }

  bool get isConnected => !isNullOrEmpty(accessToken);

  Future<MeetupPlatformSession> loadFromPrefs() async {
    accessToken = await _loadAccessTokenFromPrefs();
    return this;
  }

  static Future<String> _loadAccessTokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kMeetupAccessToken) ?? null;
  }

  static void _saveAccessTokenToPrefs(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(value)) {
      prefs.setString(kMeetupAccessToken, value);
    } else {
      prefs.remove(kMeetupAccessToken);
    }
  }
}
