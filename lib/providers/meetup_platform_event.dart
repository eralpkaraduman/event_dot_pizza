import 'package:event_dot_pizza/platform_type.dart';

import './event.dart';
import '../utils.dart';

class MeetupPlatformEvent extends Event {
  MeetupPlatformEvent({
    String platformId,
    String name,
    String link,
    String description,
  }) : super(platformId, PlatformType.Meetup, name, link, description);

  factory MeetupPlatformEvent.fromJson(Map<String, dynamic> json) {
    return MeetupPlatformEvent(
      platformId: json['id'] as String,
      name: json['name'] as String,
      link: json['link'] as String,
      description: parseHtmlText(json['description'].toString()),
    );
  }
}
