import '../platform_type.dart';
import '../utils.dart';
import './event.dart';

class MeetupPlatformEvent extends Event {
  MeetupPlatformEvent({
    String platformId,
    String name,
    String link,
    String description,
    String venueName,
    String formattedLocalDateTime,
  }) : super(platformId, PlatformType.Meetup, name, link, description,
            venueName, formattedLocalDateTime);

  factory MeetupPlatformEvent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> venueJson = json['venue'] ?? {};
    Map<String, dynamic> groupJson = json['group'] ?? {};
    String eventName = groupJson['name'] + ' : ' + json['name'];
    print(json);
    return MeetupPlatformEvent(
        platformId: json['id'],
        name: eventName,
        link: json['link'],
        description:
            eventName + ' ' + parseHtmlText(json['description'].toString()),
        venueName: venueJson['name'] ?? 'Unknown Venue',
        formattedLocalDateTime: '${json['local_date']} ${json['local_time']}');
  }
}
