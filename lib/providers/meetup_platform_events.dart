import 'package:flutter/material.dart';
import '../platforms/meetupPlatformApi.dart';
import '../providers/platform_events.dart';
import '../models/event.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatformEvents with ChangeNotifier implements PlatformEvents {
  String _accessToken;
  List<Event> _events = [];
  bool _refreshing = false;
  bool get refreshing => _refreshing;
  List<Event> get events => [..._events];

  MeetupPlatformEvents({String accessToken, List<Event> events}) {
    print('Provider:MeetupPlatformEvents:Updated');
    this._accessToken = accessToken;
    this._events = events;
  }

  Future<void> refresh() async {
    _refreshing = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // TODO: remove this
    try {
      _events = await MeetupPlatformApi.fetchUpcomingEvents(_accessToken);
    } catch (e) {}
    _refreshing = false;
    notifyListeners();
  }
}
