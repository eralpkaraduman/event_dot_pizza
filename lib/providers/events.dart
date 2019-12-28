import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../providers/session.dart';
import '../dictionary_matcher.dart' as matcher;
import '../models/location.dart';
import '../models/event.dart';
import '../platforms/meetup_platform_api.dart';
import '../platforms/eventbrite_platform_api.dart';

class Events extends ChangeNotifier {
  static const DATE_FORMAT = 'EEE, MMM d';
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
  String _eventbriteAccessToken;

  Events(Session session, List<Event> allEvents) {
    _meetupAccessToken = session?.meetupAccessToken;
    _eventbriteAccessToken = session?.eventbriteAccessToken;
    _allEvents = allEvents;
  }

  Event find(String id) {
    try {
      return _allEvents.firstWhere((event) => event.id == id);
    } catch (_) {
      print('Event not found: $id');
      return null;
    }
  }

  Future<void> refreshEvents(Location location) async {
    List<Event> _meetupEvents = [];
    try {
      _meetupEvents = await MeetupPlatformApi.fetchUpcomingEvents(
        location: location,
        accessToken: _meetupAccessToken,
      );
    } catch (e) {
      print('Provider:Events:MeetupPlatformEvents:FailedToRefresh:$e');
    }

    List<Event> _eventbriteEvents = [];
    try {
      _eventbriteEvents = await EventbritePlatformApi.fetchUpcomingEvents(
        location: location,
        accessToken: _eventbriteAccessToken,
      );
    } catch (e) {
      print('Provider:Events:EventbritePlatformEvents:FailedToRefresh:$e');
    }

    _allEvents = [..._meetupEvents, ..._eventbriteEvents];
    _allEvents.forEach((event) {
      event.matches = matcher.getMatches(event.description);
    });

    notifyListeners();
  }

  void clearEvents() {
    _allEvents = [];
    notifyListeners();
  }
}
