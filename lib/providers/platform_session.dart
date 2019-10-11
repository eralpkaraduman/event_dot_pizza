import '../models/event.dart';
import '../models/location.dart';

abstract class PlatformSession {
  String get accessToken;
  bool get isConnected;
  bool get refreshing;
  List<Event> get events;
  void connect(String accessToken);
  disconnect();
  Future<void> refreshEvents(Location location);
  void clearEvents();
  Future<void> tryToConnectFromPrefs();
}
