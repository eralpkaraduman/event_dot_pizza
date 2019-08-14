import 'package:flutter/material.dart';

import '../event_filter.dart';
import './platform_events.dart';
import './event.dart';

class Events extends ChangeNotifier {
  List<Event> _allEvents = [];
  List<Event> _events = [];
  List<Event> get events => [..._events];

  bool _refreshing = false;
  bool get refreshing => _refreshing;

  Events(List<PlatformEvents> platforms, EventFilter eventFilter) {
    print('Provider:Events:Updated');
    platforms.forEach((platform) {
      _allEvents = [...platform.events, ...events];
      _events = _allEvents
          .where((Event event) => eventFilter.checkFood(event.description))
          .toList();
      _refreshing = _refreshing || platform.refreshing;
    });
  }

  Event find({String id, String platform}) {
    return _events
        .firstWhere((event) => event.platform == platform && event.id == id);
  }
}
