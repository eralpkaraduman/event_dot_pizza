import '../dictionary_matcher.dart';
import '../platform_type.dart';

class Event {
  String id;
  List<EventFilterMatch> matches = [];
  List<EventFilterMatchType> get matchTypes {
    return matches.map((match) => match.type).toSet().toList();
  }

  final String platformId;
  final String name;
  final String link;
  final PlatformType platform;
  final String description;
  final String venueName;
  final String formattedLocalDateTime;
  final int time;

  Event(
    this.platformId,
    this.platform,
    this.name,
    this.link,
    this.description,
    this.venueName,
    this.formattedLocalDateTime,
    this.time,
  ) {
    this.id = '${platform.index}-$platformId';
  }
}
