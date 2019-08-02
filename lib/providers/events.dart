import 'package:flutter/material.dart';

import './platform_events.dart';
import './event.dart';

class Events extends ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => [..._events];
  List<Event> get foodEvents => _events.where((event) => true);

  bool _refreshing = false;
  bool get refreshing => _refreshing;

  Events({List<PlatformEvents> platforms}) {
    print('Provider:Events:Updated');
    platforms.forEach((platform) {
      _events = [...platform.events, ...events];
      _refreshing = _refreshing || platform.refreshing;
    });
  }

  Event find({String id, String platform}) {
    return _events
        .firstWhere((event) => event.platform == platform && event.id == id);
  }
}
