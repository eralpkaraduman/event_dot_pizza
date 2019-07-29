import 'dart:async';

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
    notifyListeners();
    scheduleMicrotask(() => _saveToPrefs());
  }

  bool get isConnected => !isNullOrEmpty(accessToken);

  Future<void> loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(kMeetupAccessToken) ?? null;
  }

  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(_accessToken)) {
      prefs.setString(kMeetupAccessToken, _accessToken);
    } else {
      prefs.remove(kMeetupAccessToken);
    }
  }
}
