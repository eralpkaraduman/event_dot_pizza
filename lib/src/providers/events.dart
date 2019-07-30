import 'package:flutter/material.dart';

import '../models/event.dart';
import '../providers/platform_events.dart';

class Events extends ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => _events;

  bool _refreshing = false;
  bool get refreshing => _refreshing;

  Events(List<PlatformEvents> plaforms) {
    print('Provider:Events:Updated');
    plaforms.forEach((platform) {
      _events = [...platform.events, ...events];
      _refreshing = _refreshing || platform.refreshing;
    });
  }
}
