import 'dart:async';
import 'package:event_dot_pizza/models/location.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../platforms/eventbrite_platform_api.dart';
import '../utils.dart';
import '../models/event.dart';
import './platform_session.dart';

const String kEventbriteAccessToken = 'eventbriteAccessToken';

class EventbritePlatformSession with ChangeNotifier implements PlatformSession {
  String _accessToken;
  String get accessToken => _accessToken;
  bool get isConnected => !isNullOrEmpty(accessToken);
  List<Event> _events = [];
  bool _refreshing = false;
  bool get refreshing => _refreshing;
  List<Event> get events => [..._events];

  EventbritePlatformSession() {
    print('Provider:EventbritePlatformSession:Updated');
  }

  void connect(String accessToken) {
    _accessToken = accessToken;
    notifyListeners();
    scheduleMicrotask(() => _saveToPrefs());
  }

  void disconnect() {
    _accessToken = null;
    notifyListeners();
    scheduleMicrotask(() => _saveToPrefs());
  }

  /// Refreshes Eventbrite Platform Events.
  ///
  /// Calling this before app wasn't built yet will cause problems.
  /// Because it calls `notifyListeners()` right away.
  /// It is better if this is called inside `scheduleMicrotask()` callback.
  Future<void> refreshEvents(Location location) async {
    _refreshing = true;
    notifyListeners();
    try {
      _events = await EventbritePlatformApi.fetchUpcomingEvents(
        location: location,
        accessToken: _accessToken,
      );
    } catch (e) {
      print('Provider:EventbritePlatformEvents:FailedToRefresh');
      print(e);
    }
    _refreshing = false;
    notifyListeners();
  }

  void clearEvents() {
    _events = [];
    notifyListeners();
  }

  Future<void> tryToConnectFromPrefs() async {
    print('EventbritePlatformSession::tryToConnectFromPrefs');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isNullOrEmpty(_accessToken) && prefs.containsKey(kEventbriteAccessToken)) {
      String loadedToken = prefs.getString(kEventbriteAccessToken);
      if (!isNullOrEmpty(loadedToken)) {
        _accessToken = loadedToken;
        notifyListeners();
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isNullOrEmpty(_accessToken)) {
      prefs.setString(kEventbriteAccessToken, _accessToken);
    } else {
      prefs.remove(kEventbriteAccessToken);
    }
  }
}
