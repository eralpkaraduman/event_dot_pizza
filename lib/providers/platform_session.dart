import '../models/event.dart';
import '../models/location.dart';

abstract class PlatformSession {
  PlatformSession(String accessToken);
  String name;
  String get accessToken;
  bool get isConnected;
  bool get refreshing;
  List<Event> get events;
  Future<void> refreshEvents(Location location);
  void clearEvents();
  String get authUri;
}
