import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';
import '../models/event.dart';
import '../models/location.dart';

class EventbritePlatformApi {
  static const String kACCESS_TOKEN = 'access_token';
  static const String REDIRECT_URI =
      'https://event.pizza/handle_authorization_redirect/eventbrite';
  static const String API_KEY = 'DIHW55JS4TOM7O5IA5';
  static const String authURI = "https://www.eventbrite.com/oauth/authorize?response_type=token&client_id=$API_KEY&redirect_uri=$REDIRECT_URI";

  static Future<List<Event>> fetchUpcomingEvents({
    @required Location location,
    @required String accessToken,
  }) async {
    print('not implemented');
    return [];
  }
}