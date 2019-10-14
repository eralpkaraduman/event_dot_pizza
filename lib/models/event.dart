import '../dictionary_matcher.dart';
import '../platform_type.dart';
import 'package:intl/intl.dart' show DateFormat;

class Event {
  static DateFormat dateFormater = DateFormat("EEE, MMM d, ''yy h:mm a");
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
