import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';
import '../models/eventbrite_platform_event.dart';
import '../models/location.dart';

class EventbritePlatformApi {
  static const String kACCESS_TOKEN = 'access_token';
  static const String REDIRECT_URI =
      'https://event.pizza/handle_authorization_redirect/eventbrite';
  static const String CALLBACK_URI = 'event.pizza://handle_eventbrite_redirect';
  static const String API_KEY = 'DIHW55JS4TOM7O5IA5';
  static const String authURI =
      "https://www.eventbrite.com/oauth/authorize?response_type=token&client_id=$API_KEY&redirect_uri=$REDIRECT_URI";
  static const _baseUri = "https://www.eventbriteapi.com/v3";
  static const _upcomingEventsUri = "$_baseUri/events/search/";

  static Future<List<EventbritePlatformEvent>> fetchUpcomingEvents({
    @required Location location,
    @required String accessToken,
  }) async {
    if (isNullOrEmpty(accessToken)) {
      // TODO: standardize error throwing
      throw 'EventbritePlatformApi:FetchUpcomingEvents:NullOrEmptyAccessToken';
    }
    http.Response response = await http.get(
      _upcomingEventsUri +
          '?location.longitude=${location.lon}&location.latitude=${location.lat}&location.within=40mi&start_date.keyword=this_week&expand=venue',
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 401) {
      // TODO: standardize error throwing
      throw 'EventbritePlatformApi:FetchUpcomingEvents:Unauthorized';
    }

    if (response.statusCode != 200) {
      // TODO: standardize error throwing
      throw 'EventbritePlatformApi::fetchUpcomingEvents:StatusCode:${response.statusCode}';
    }

    try {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      List<EventbritePlatformEvent> events = (decodedResponse['events'] as List)
          .map((data) => EventbritePlatformEvent.fromJson(data))
          .toList();
      return events;
    } catch (e) {
      // TODO: standardize error throwing
      print(e);
      throw 'EventbritePlatformApi::fetchUpcomingEvents:FailedToDecodeJsonResponse';
    }

    return [];
  }
}
