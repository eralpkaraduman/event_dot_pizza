import 'package:flutter/foundation.dart';

abstract class Event with ChangeNotifier {
  final String id;
  final String name;
  final String link;
  final String platform;
  final String description;

  Event(
    this.id,
    this.platform,
    this.name,
    this.link,
    this.description,
  );
}
