import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatformSession with ChangeNotifier {
  String _accessToken;
  String get accessToken => _accessToken;
  set accessToken(accessToken) {
    _accessToken = accessToken;
    saveToPrefs();
    notifyListeners();
  }

  bool get isConnected => _accessToken != null && _accessToken.isNotEmpty;

  void loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(kMeetupAccessToken) ?? null;
  }

  void saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnected) {
      prefs.setString(kMeetupAccessToken, accessToken);
    } else {
      prefs.remove(kMeetupAccessToken);
    }
  }
}
