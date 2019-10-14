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
    int time,
  }) : super(platformId, PlatformType.Meetup, name, link, description,
            venueName, formattedLocalDateTime, time);

  factory MeetupPlatformEvent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> venueJson = json['venue'] ?? {};
    Map<String, dynamic> groupJson = json['group'] ?? {};
    String eventName = groupJson['name'] + ' : ' + json['name'];
    int time = json['time'] as int;
    return MeetupPlatformEvent(
      platformId: json['id'],
      name: eventName,
      link: json['link'],
      description:
          eventName + ' ' + parseHtmlText(json['description'].toString()),
      venueName: venueJson['name'] ?? 'Unknown Venue',
      formattedLocalDateTime:
          Event.dateFormater.format(DateTime.fromMillisecondsSinceEpoch(time)),
      time: time,
    );
  }
}
