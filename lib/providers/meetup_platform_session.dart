import 'dart:async';
import 'package:flutter/material.dart';
import '../platforms/meetup_platform_api.dart';
import '../utils.dart';
import '../models/location.dart';
import '../models/event.dart';
import './platform_session.dart';

class MeetupPlatformSession with ChangeNotifier implements PlatformSession {
  String name = 'Meetup.Com';
  String _accessToken;
  String get accessToken => _accessToken;
  bool get isConnected => !isNullOrEmpty(accessToken);
  List<Event> _events = [];
  bool _refreshing = false;
  bool get refreshing => _refreshing;
  List<Event> get events => [..._events];
  String get authUri => MeetupPlatformApi.authUri;

  MeetupPlatformSession(this._accessToken);

  /// Refreshes Meetup Platform Events.
  ///
  /// Calling this before app wasnt built yet will cause problems.
  /// Because it calls `notifyListeners()` right away.
  /// It is better if this is called inside `scheduleMicrotask()` callback.
  Future<void> refreshEvents(Location location) async {
    _refreshing = true;
    notifyListeners();
    try {
      _events = await MeetupPlatformApi.fetchUpcomingEvents(
        location: location,
        accessToken: _accessToken,
      );
    } catch (e) {
      print('Provider:MeetupPlatformEvents:FailedToRefresh');
      print(e);
    }
    _refreshing = false;
    try {
      notifyListeners();
    } catch (_) {}
  }

  void clearEvents() {
    _events = [];
    notifyListeners();
  }
}
