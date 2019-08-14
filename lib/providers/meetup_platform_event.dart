import 'package:event_dot_pizza/platform_type.dart';

import './event.dart';
import '../utils.dart';

class MeetupPlatformEvent extends Event {
  MeetupPlatformEvent({
    String platformId,
    String name,
    String link,
    String description,
    String venueName,
  }) : super(
          platformId,
          PlatformType.Meetup,
          name,
          link,
          description,
          venueName,
        );

  factory MeetupPlatformEvent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> venueJson = json['venue'] ?? {};
    return MeetupPlatformEvent(
      platformId: json['id'].toString(),
      name: json['name'].toString(),
      link: json['link'].toString(),
      description: parseHtmlText(json['description'].toString()),
      venueName: venueJson['name']?.toString() ?? 'Unknown Venue',
    );
  }
}
