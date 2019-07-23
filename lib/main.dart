import 'package:flutter/material.dart';
import 'package:event_dot_pizza/pages/meetupAuthPage.dart';
import 'package:event_dot_pizza/pages/homePage.dart';

void main() => runApp(App());

class Routes {
  static const home = "home";
  static const meetupAuth = "meetupAuth";
}

class App extends StatelessWidget {
  // This widget is the root of your application.
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
                builder: (_) => HomePage(),
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
