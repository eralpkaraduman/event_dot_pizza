import 'package:flutter/material.dart';
import '../platforms/meetup_platform_api.dart';
import '../providers/platform_events.dart';
import '../providers/event.dart';
import '../services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatformEvents with ChangeNotifier implements PlatformEvents {
  String _accessToken;
  List<Event> _events = [];
  bool _refreshing = false;
  bool get refreshing => _refreshing;
  List<Event> get events => [..._events];

  MeetupPlatformEvents(String accessToken, List<Event> events) {
    print('Provider:MeetupPlatformEvents:Updated');
    this._accessToken = accessToken;
    this._events = events;
  }

  /// Refreshes Meetup Platform Events.
  ///
  /// Calling this before app wasnt built yet will cause problems.
  /// Because it calls `notifyListeners()` right away.
  /// It is better if this is called inside `scheduleMicrotask()` callback.
  Future<void> refresh(BuildContext context) async {
    _refreshing = true;
    notifyListeners();
    try {
      _events = await MeetupPlatformApi.fetchUpcomingEvents(
          Provider.of<LocationService>(context).position, _accessToken);
    } catch (e) {
      print('Provider:MeetupPlatformEvents:FailedToRefresh');
      print(e);
    }
    _refreshing = false;
    notifyListeners();
  }
}
