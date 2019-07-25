class MeetupPlatformApi {
  static const String CONSUMER_KEY = '96rf1kn6pobffcejakptjgarrf';
  static const String REDIRECT_URI =
      'event.pizza://handle_authorization_redirect/meetup';
  static const String authURI = 'https://secure.meetup.com/oauth2/authorize' +
      '?client_id=$CONSUMER_KEY' +
      '&response_type=token' +
      '&redirect_uri=$REDIRECT_URI';
}
