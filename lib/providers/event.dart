import 'package:flutter/foundation.dart';
import '../platform_type.dart';

class Event with ChangeNotifier {
  String id;
  final String platformId;
  final String name;
  final String link;
  final PlatformType platform;
  final String description;

  Event(
    this.platformId,
    this.platform,
    this.name,
    this.link,
    this.description,
  ) {
    this.id = '${platform.index}-$platformId';
  }
}
