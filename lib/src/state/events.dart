import 'package:event_dot_pizza/src/models/event.dart';
import 'package:event_dot_pizza/src/state/platform_events.dart';

class Events {
  List<Event> _events = [];
  List<Event> get events => _events;
  bool _refreshing = false;
  bool get refreshing => _refreshing;
  Events(List<PlatformEvents> plaforms) {
    plaforms.forEach((platform) {
      print('platform.events.length:${platform.events.length}');
      _events = platform.events;
      _refreshing = _refreshing || platform.refreshing;
    });
  }
}
