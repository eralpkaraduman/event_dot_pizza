import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../dictionary_matcher.dart' as matcher;
import '../models/location.dart';
import '../models/event.dart';
import '../platforms/meetup_platform_api.dart';
import '../platforms/eventbrite_platform_api.dart';

class Events extends ChangeNotifier {
  static const DATE_FORMAT = 'EEE, MMM d';

  bool _needsRefresh = false;
  bool get needsRefresh => _needsRefresh;

  List<Event> _allEvents = [];
  List<Event> get allEvents => [..._allEvents];
  List<Event> get events {
    final matchingEvents =
        _allEvents.where((event) => event.matches.length > 0).toList();
    matchingEvents.sort((a, b) => a.time.compareTo(b.time));
    return matchingEvents;
  }

  List<Event> get todayEvents => [
        ...events.where((event) => event.formattedLocalDateTime
            .contains(DateFormat(DATE_FORMAT).format(DateTime.now())))
      ];

  String _meetupAccessToken;
  set meetupAccessToken(String token) {
    if (token != _meetupAccessToken) {
      _meetupAccessToken = token;
      _needsRefresh = true;
      notifyListeners();
    }
  }

  String _eventbriteAccessToken;
  set eventbriteAccessToken(String token) {
    if (token != _eventbriteAccessToken) {
      _eventbriteAccessToken = token;
      _needsRefresh = true;
      notifyListeners();
    }
  }

  Location _location;
  set location(Location location) {
    if (!location.equalsTo(_location)) {
      _location = location;
      _needsRefresh = true;
      notifyListeners();
    }
  }

  Event find(String id) {
    try {
      return _allEvents.firstWhere((event) => event.id == id);
    } catch (_) {
      print('Event not found: $id');
      return null;
    }
  }

  Future<void> refreshEvents() async {
    List<Event> _meetupEvents = [];
    try {
      _meetupEvents = await MeetupPlatformApi.fetchUpcomingEvents(
        location: _location,
        accessToken: _meetupAccessToken,
      );
    } catch (e) {
      print('Provider:Events:MeetupPlatformEvents:FailedToRefresh:$e');
    }

    List<Event> _eventbriteEvents = [];
    try {
      _eventbriteEvents = await EventbritePlatformApi.fetchUpcomingEvents(
        location: _location,
        accessToken: _eventbriteAccessToken,
      );
    } catch (e) {
      print('Provider:Events:EventbritePlatformEvents:FailedToRefresh:$e');
    }

    _allEvents = [..._meetupEvents, ..._eventbriteEvents];
    _allEvents.forEach((event) {
      event.matches = matcher.getMatches(event.description);
    });

    _needsRefresh = false;
    notifyListeners();
  }
}
