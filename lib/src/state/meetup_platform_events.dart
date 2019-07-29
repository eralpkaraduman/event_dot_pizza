import 'package:event_dot_pizza/src/platforms/meetupPlatformApi.dart';
import 'package:event_dot_pizza/src/state/platform_events.dart';
import 'package:event_dot_pizza/src/models/event.dart';
import 'package:flutter/material.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatformEvents with ChangeNotifier implements PlatformEvents {
  bool _refreshing = false;
  bool get refreshing => _refreshing;
  List<Event> _events = [];
  List<Event> get events => _events;

  Future<void> refresh(String accessToken) async {
    _refreshing = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // TODO: remove this
    try {
      _events = await MeetupPlatformApi.fetchUpcomingEvents(accessToken);
    } catch (e) {}
    _refreshing = false;
    notifyListeners();
  }
}
