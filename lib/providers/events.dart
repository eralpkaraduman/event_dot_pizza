import 'package:flutter/material.dart';
import '../dictionary_matcher.dart' as matcher;
import './platform_events.dart';
import './event.dart';

class Events extends ChangeNotifier {
  List<Event> _allEvents = [];
  List<Event> _events = [];
  List<Event> get events => [..._events];
  List<Event> get allEvents => [..._allEvents];

  bool _refreshing = false;
  bool get refreshing => _refreshing;

  Events(List<PlatformEvents> platforms) {
    print('Provider:Events:Updated');
    platforms.forEach((platform) {
      _allEvents = [...platform.events, ...events];
      _allEvents.forEach((event) {
        event.matches = matcher.getMatches(event.description);
      });
      _events = _allEvents.where((event) => event.matches.length > 0).toList();
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
