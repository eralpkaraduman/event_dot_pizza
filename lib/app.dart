import 'package:flutter/material.dart';
import 'package:event_dot_pizza/pages/connectPlatformsPage.dart';
import 'package:event_dot_pizza/pages/meetupAuthPage.dart';
import 'package:event_dot_pizza/routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event.Pizza',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.home:
            return MaterialPageRoute(
                builder: (_) => ConnectPlatformsPage(),
                settings: RouteSettings(isInitialRoute: true));
          case Routes.meetupAuth:
            return MaterialPageRoute(
                fullscreenDialog: true, builder: (_) => MeetupAuthPage());
          default:
            throw 'Invalid Route';
        }
      },
    );
  }
}
