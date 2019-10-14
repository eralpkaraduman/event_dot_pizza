import '../platform_type.dart';
import '../utils.dart';
import './event.dart';

class EventbritePlatformEvent extends Event {
  EventbritePlatformEvent({
    String platformId,
    String name,
    String link,
    String description,
    String venueName,
    String formattedLocalDateTime,
    int time,
  }) : super(platformId, PlatformType.Meetup, name, link, description,
            venueName, formattedLocalDateTime, time);

  factory EventbritePlatformEvent.fromJson(Map<String, dynamic> json) {
    String eventName = json['name']['text'];
    String localStartDateTime = json['start']['local'].toString();
    DateTime startDateTime = DateTime.parse(localStartDateTime);
    Map<String, dynamic> venueJson = json['venue'] ?? {};
    return EventbritePlatformEvent(
      platformId: json['id'],
      name: eventName,
      link: json['url'],
      description: eventName +
          ' ' +
          parseHtmlText(json['description']['html'].toString()),
      venueName: venueJson['name'] ?? 'Unknown Venue',
      formattedLocalDateTime: Event.dateFormater.format(startDateTime),
      time: startDateTime.millisecondsSinceEpoch,
    );
  }
}
