import 'dart:convert';
import 'package:event_dot_pizza/src/models/event.dart';
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

  static Future<List<Event>> fetchUpcomingEvents(String accessToken) async {
    const lat = '60.192059';
    const lon = '24.945831';
    http.Response response = await http.get(
        _upcomingEventsUri + '?lat=$lat&lon=$lon',
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode != 200) {
      // TODO: standardize error throwing
      print(
          'MeetupPlatformApi::fetchUpcomingEvents:StatusCode:${response.statusCode}');
      throw 'MeetupPlatformApi::fetchUpcomingEvents:StatusCode:${response.statusCode}';
    }

    try {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      List<Event> events = (decodedResponse['events'] as List)
          .map((data) => Event.fromJson(data))
          .toList();
      return events;
    } catch (e) {
      // TODO: standardize error throwing
      print(e);
      print(
          'MeetupPlatformApi::fetchUpcomingEvents:FailedToDecodeJsonResponse');
      throw 'MeetupPlatformApi::fetchUpcomingEvents:FailedToDecodeJsonResponse';
    }
  }
}
