import 'package:event_dot_pizza/src/models/event.dart';

abstract class PlatformEvents {
  bool get refreshing;
  List<Event> get events;
  Future<void> refresh(String accessToken);
}
