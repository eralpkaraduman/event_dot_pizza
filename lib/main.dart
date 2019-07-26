import 'dart:async';

import 'package:event_dot_pizza/src/platforms/meetupPlatformApi.dart';
import 'package:event_dot_pizza/src/state/appState.dart';
import 'package:event_dot_pizza/src/state/meetup_platform_session.dart';
import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/app.dart';
import 'package:provider/provider.dart';

void main() async {
  final meetupPlatformSession = await MeetupPlatformSession().loadFromPrefs();
  if (meetupPlatformSession.isConnected) {
    scheduleMicrotask(() => MeetupPlatformApi.fetchUpcomingEvents(
        meetupPlatformSession.accessToken));
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(builder: (_) => meetupPlatformSession),
    ProxyProvider<MeetupPlatformSession, AppState>(
        builder: (context, meetupSession, _) => AppState([meetupSession]))
  ], child: App()));
}
