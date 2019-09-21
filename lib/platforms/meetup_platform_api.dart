import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils.dart';
import '../providers/meetup_platform_event.dart';
import 'package:geolocator/geolocator.dart';

class MeetupPlatformApi {
  static const String kACCESS_TOKEN = 'access_token';
  static const String CONSUMER_KEY = '96rf1kn6pobffcejakptjgarrf';
  static const String REDIRECT_URI =
      'event.pizza://handle_authorization_redirect/meetup';
  static const String authURI = 'https://secure.meetup.com/oauth2/authorize' +
      '?client_id=$CONSUMER_KEY' +
      '&response_type=token' +
      '&redirect_uri=$REDIRECT_URI';

  static const _upcomingEventsUri =
      "https://api.meetup.com/find/upcoming_events";

  static Future<List<MeetupPlatformEvent>> fetchUpcomingEvents(
      Position location, String accessToken) async {
    if (isNullOrEmpty(accessToken)) {
      // TODO: standardize error throwing
      throw 'MeetupPlatformApi:FetchUpcomingEvents:NullOrEmptyAccessToken';
    }

    print("LOCATION: $location");

    // TODO: uncomment code below to use the the actual position
    String lat = location.latitude.toString();
    String lon = location.longitude.toString();

    http.Response response = await http.get(
        _upcomingEventsUri + '?lat=$lat&lon=$lon',
        headers: {'Authorization': 'Bearer $accessToken'});

    if (response.statusCode == 401) {
      // TODO: standardize error throwing
      throw 'MeetupPlatformApi:FetchUpcomingEvents:Unauthorized';
    }

    if (response.statusCode != 200) {
      // TODO: standardize error throwing
      print(
          'MeetupPlatformApi::fetchUpcomingEvents:StatusCode:${response.statusCode}');
      throw 'MeetupPlatformApi::fetchUpcomingEvents:StatusCode:${response.statusCode}';
    }

    try {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      List<MeetupPlatformEvent> events = (decodedResponse['events'] as List)
          .map((data) => MeetupPlatformEvent.fromJson(data))
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
