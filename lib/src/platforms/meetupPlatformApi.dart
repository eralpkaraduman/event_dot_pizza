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

  static const _upcomingEventsUri =
      "https://api.meetup.com/find/upcoming_events";

  static Future<List<dynamic>> fetchUpcomingEvents(String accessToken) async {
    const lat = '60.192059';
    const lon = '24.945831';
    http.Response response = await http.get(
        _upcomingEventsUri + '?lat=$lat&lon=$lon',
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      var events = List<dynamic>.from(decodedResponse['events']);
      print(events);
      return events;
    } else {
      print('MeetupPlatformApi::fetchUpcomingEvents:${response.statusCode}');
      throw 'MeetupPlatformApi::fetchUpcomingEvents';
    }
  }
}
