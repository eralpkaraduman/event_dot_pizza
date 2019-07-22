import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String CONSUMER_KEY = '96rf1kn6pobffcejakptjgarrf';
const String REDIRECT_URI =
    'event.pizza://handle_authorization_redirect/meetup';

class MeetupAuthScreen extends StatelessWidget {
  final String title = 'Connect Meetup.Com';
  final String authURI = 'https://secure.meetup.com/oauth2/authorize' +
      '?client_id=$CONSUMER_KEY' +
      '&response_type=token' +
      '&redirect_uri=$REDIRECT_URI';

  String parseAccessTokenFromUrl(String url) {
    if (url.startsWith(REDIRECT_URI)) {
      String query = url.split('#')[1];
      List<String> params = query.split('&');
      for (String params in params) {
        List<String> pair = params.split('=');
        if (pair[0] == 'access_token') {
          return pair[1];
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: authURI,
          navigationDelegate: (NavigationRequest request) {
            String accessToken = parseAccessTokenFromUrl(request.url);
            if (accessToken == null) {
              return NavigationDecision.navigate;
            } else {
              print(accessToken);
              return NavigationDecision.prevent;
            }
          },
        ),
      ),
    );
  }
}
