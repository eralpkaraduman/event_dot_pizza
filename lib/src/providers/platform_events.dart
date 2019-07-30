import '../models/event.dart';

abstract class PlatformEvents {
  bool get refreshing;
  List<Event> get events;
  Future<void> refresh();
}
