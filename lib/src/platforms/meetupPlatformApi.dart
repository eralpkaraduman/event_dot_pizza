import 'dart:convert';
import 'package:http/http.dart' as http;

class MeetupPlatformApi {
  static const String CONSUMER_KEY = '96rf1kn6pobffcejakptjgarrf';
  static const String REDIRECT_URI =
      'event.pizza://handle_authorization_redirect/meetup';
  static const String authURI = 'https://secure.meetup.com/oauth2/authorize' +
      '?client_id=$CONSUMER_KEY' +
      '&response_type=token' +
      '&redirect_uri=$REDIRECT_URI';

  static const upcomingEventsUri =
      "https://api.meetup.com/find/upcoming_events";

  static Future<List<dynamic>> fetchUpcomingEvents(String accessToken) async {
    const lat = '60.192059';
    const lon = '24.945831';
    http.Response response =
        await http.get(upcomingEventsUri + '?lat=$lat&lon=$lon');
    if (response.statusCode == 200) {
      var events = jsonDecode(response.body) as List<dynamic>;
      print(events);
      return events;
    } else {
      print('MeetupPlatformApi::fetchUpcomingEvents:${response.statusCode}');
      throw 'MeetupPlatformApi::fetchUpcomingEvents';
    }
  }
}
