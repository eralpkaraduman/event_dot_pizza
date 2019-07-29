import 'dart:async';

import 'package:event_dot_pizza/src/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/pages/connectPlatformsPage.dart';
import 'package:event_dot_pizza/src/pages/meetupAuthPage.dart';
import 'package:event_dot_pizza/src/state/meetup_platform_session.dart';
import 'package:event_dot_pizza/src/state/meetup_platform_events.dart';
import 'package:event_dot_pizza/src/routes.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    MeetupPlatformSession meetupSession =
        Provider.of<MeetupPlatformSession>(context, listen: false);
    MeetupPlatformEvents meetupEvents =
        Provider.of<MeetupPlatformEvents>(context, listen: false);
    scheduleMicrotask(() async {
      await meetupSession.loadFromPrefs();
      if (meetupSession.isConnected) {
        meetupEvents.refresh(meetupSession.accessToken);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event.Pizza',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.home, // hasSession ? Routes.home : Routes.Welcome
      routes: {
        // Routes.welcome: (_) => WelcomePage(),
        Routes.home: (_) => HomePage(),
        Routes.connectPlatforms: (_) => ConnectPlatformsPage(),
        Routes.meetupAuth: (_) => MeetupAuthPage()
      },
    );
  }
}
