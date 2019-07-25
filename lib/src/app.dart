import 'package:event_dot_pizza/src/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_dot_pizza/src/state/meetupPlatformSession.dart';
import 'package:event_dot_pizza/src/pages/connectPlatformsPage.dart';
import 'package:event_dot_pizza/src/pages/meetupAuthPage.dart';
import 'package:event_dot_pizza/src/routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MeetupPlatformSession>(
        builder: (context, meetupPlatform, _) {
      Provider.of<MeetupPlatformSession>(context).loadFromPrefs();
      return MaterialApp(
        title: 'Event.Pizza',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.home,
        routes: {
          Routes.home: (_) => HomePage(),
          Routes.connectPlatforms: (_) => ConnectPlatformsPage(),
          Routes.meetupAuth: (_) => MeetupAuthPage()
        },
      );
    });
  }
}
