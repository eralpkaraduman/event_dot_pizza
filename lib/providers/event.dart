import 'package:flutter/foundation.dart';

abstract class Event with ChangeNotifier {
  final String name;
  final String link;
  final String platform;
  Event(
    this.platform,
    this.name,
    this.link,
  );
}
