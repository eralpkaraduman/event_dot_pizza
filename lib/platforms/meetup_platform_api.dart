import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils.dart';
import '../providers/meetup_platform_event.dart';
import '../models/location.dart';

class MeetupPlatformApi {
  static const String kACCESS_TOKEN = 'access_token';
  static const String CONSUMER_KEY = '96rf1kn6pobffcejakptjgarrf';
  static const String REDIRECT_URI =
      'event.pizza://handle_authorization_redirect/meetup';
  static const String authURI = 'https://secure.meetup.com/oauth2/authorize' +
      '?client_id=$CONSUMER_KEY' +
      '&response_type=token' +
      '&redirect_uri=$REDIRECT_URI';

  static const _baseUri = "https://api.meetup.com";
  static const _upcomingEventsUri = "$_baseUri/find/upcoming_events";
  static const _findLocationsUri = "$_baseUri/find/locations";

  static Future<List<MeetupPlatformEvent>> fetchUpcomingEvents(
      double lat, double lon, String accessToken) async {
    if (isNullOrEmpty(accessToken)) {
      // TODO: standardize error throwing
      throw 'MeetupPlatformApi:FetchUpcomingEvents:NullOrEmptyAccessToken';
    }
    print('?lat=$lat&lon=$lon');
    http.Response response = await http.get(
      _upcomingEventsUri + '?lat=$lat&lon=$lon',
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 401) {
      // TODO: standardize error throwing
      throw 'MeetupPlatformApi:FetchUpcomingEvents:Unauthorized';
    }

    if (response.statusCode != 200) {
      // TODO: standardize error throwing
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
      throw 'MeetupPlatformApi::fetchUpcomingEvents:FailedToDecodeJsonResponse';
    }
  }

  static Future<List<Location>> findLocations(String query) async {
    http.Response response =
        await http.get(_findLocationsUri + '?query=$query');

    if (response.statusCode != 200) {
      // TODO: standardize error throwing
      throw 'MeetupPlatformApi::findLocations:StatusCode:${response.statusCode}';
    }

    try {
      List<dynamic> decodedResponse = jsonDecode(response.body);
      List<Location> locations =
          decodedResponse.map((locData) => Location.fromJson(locData)).toList();
      return locations;
    } catch (e) {
      // TODO: standardize error throwing
      print(e);
      throw 'MeetupPlatformApi::fetchUpcomingEvents:FailedToDecodeJsonResponse';
    }
  }
}
