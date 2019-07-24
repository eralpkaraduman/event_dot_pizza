import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class MeetupPlatform with ChangeNotifier {
  static const String CONSUMER_KEY = '96rf1kn6pobffcejakptjgarrf';
  static const String REDIRECT_URI =
      'event.pizza://handle_authorization_redirect/meetup';
  static const String authURI = 'https://secure.meetup.com/oauth2/authorize' +
      '?client_id=$CONSUMER_KEY' +
      '&response_type=token' +
      '&redirect_uri=$REDIRECT_URI';

  String _accessToken;
  String get accessToken => _accessToken;
  set accessToken(accessToken) {
    _accessToken = accessToken;
    saveToPrefs();
    notifyListeners();
  }

  bool get isConnected => _accessToken != null && _accessToken.isNotEmpty;

  void loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(kMeetupAccessToken) ?? null;
  }

  void saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnected) {
      prefs.setString(kMeetupAccessToken, accessToken);
    } else {
      prefs.remove(kMeetupAccessToken);
    }
  }
}
