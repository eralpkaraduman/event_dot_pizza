import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/platform_session.dart';
import '../providers/meetup_platform_session.dart';
import '../providers/session.dart';
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

  Events({@required List<PlatformSession> platforms}) {
    print('Provider:Events:Updated');
    platforms.forEach((platform) {
      _allEvents = [...platform.events, ...events];
      _allEvents.forEach((event) {
        event.matches = matcher.getMatches(event.description);
      });
      _events = _allEvents.where((event) => event.matches.length > 0).toList();
      _events.sort((a, b) => a.time.compareTo(b.time));
      _refreshing = _refreshing || platform.refreshing;
    });
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
