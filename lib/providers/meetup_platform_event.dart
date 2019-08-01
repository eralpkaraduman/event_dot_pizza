import './event.dart';

class MeetupPlatformEvent extends Event {
  static const platformName = 'meetup';
  MeetupPlatformEvent({String name, String link})
      : super(platformName, name, link);

  factory MeetupPlatformEvent.fromJson(Map<String, dynamic> json) {
    return MeetupPlatformEvent(
      name: json['name'] as String,
      link: json['link'] as String,
    );
  }
}
