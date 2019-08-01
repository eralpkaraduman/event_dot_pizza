import 'package:flutter/material.dart';

import './platform_events.dart';
import './event.dart';

class Events extends ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => _events;

  bool _refreshing = false;
  bool get refreshing => _refreshing;

  Events({List<PlatformEvents> platforms}) {
    print('Provider:Events:Updated');
    platforms.forEach((platform) {
      _events = [...platform.events, ...events];
      _refreshing = _refreshing || platform.refreshing;
    });
  }
}
