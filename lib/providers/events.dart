import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../providers/platform_session.dart';
import '../dictionary_matcher.dart' as matcher;
import '../models/location.dart';
import '../models/event.dart';

class Events extends ChangeNotifier {
  List<Event> _allEvents = [];
  List<Event> _events = [];
  List<Event> get events => [..._events];
  List<Event> get allEvents => [..._allEvents];

  bool _refreshing = false;
  bool get refreshing => _refreshing;

  List<PlatformSession> _platforms = [];

  Location _location;
  Location get location => _location;

  Events({
    @required List<PlatformSession> platforms,
    @required Location location,
  }) {
    print('Provider:Events:Updated');
    platforms.forEach((platform) {
      _platforms = platforms;
      _location = location;
      _allEvents = [...platform.events, ...events];
      _allEvents.forEach((event) {
        event.matches = matcher.getMatches(event.description);
      });
      _events = _allEvents.where((event) => event.matches.length > 0).toList();
      _events.sort((a, b) => a.time.compareTo(b.time));
      _refreshing = _refreshing || platform.refreshing;
    });
  }

  Future<Location> refresh() async {
    if (_location != null) {
      for (var platform in _platforms) {
        await platform.refreshEvents(_location);
      }
    }
    return location;
  }

  Event find(String id) {
    try {
      return _allEvents.firstWhere((event) => event.id == id);
    } catch (_) {
      print('Event not found: $id');
      return null;
    }
  }
}
