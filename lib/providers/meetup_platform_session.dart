import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils.dart';
import './platform_session.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatformSession with ChangeNotifier implements PlatformSession {
  String _accessToken;
  String get accessToken => _accessToken;
  bool get isConnected => !isNullOrEmpty(accessToken);

  MeetupPlatformSession() {
    print('Provider:MeetupPlatformSession:Updated');
    scheduleMicrotask(tryToConnectFromPrefs);
  }

  connect(String accessToken) {
    _accessToken = accessToken;
    notifyListeners();
    scheduleMicrotask(() => _saveToPrefs());
  }

  disconnect() {
    _accessToken = null;
    notifyListeners();
    scheduleMicrotask(() => _saveToPrefs());
  }

  Future<bool> tryToConnectFromPrefs() async {
    print('tryToConnectFromPrefs');
    if (isConnected) {
      return true;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(kMeetupAccessToken)) {
      return false;
    }
    _accessToken = prefs.getString(kMeetupAccessToken);
    notifyListeners();
    return isConnected;
  }

  Future<void> _saveToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(_accessToken)) {
      prefs.setString(kMeetupAccessToken, _accessToken);
    } else {
      prefs.remove(kMeetupAccessToken);
    }
  }
}
