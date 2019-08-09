import './event.dart';
import '../utils.dart';

class MeetupPlatformEvent extends Event {
  static const platformName = 'meetup';
  MeetupPlatformEvent({String id, String name, String link, String description})
      : super(id, platformName, name, link, description);

  factory MeetupPlatformEvent.fromJson(Map<String, dynamic> json) {
    return MeetupPlatformEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      link: json['link'] as String,
      description: parseHtmlText(json['description'].toString()),
    );
  }
}
