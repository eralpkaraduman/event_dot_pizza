import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/connectPlatformsPage.dart';
import './pages/homePage.dart';
import './pages/meetupAuthPage.dart';
import './pages/splash_page.dart';
import './pages/welcome_page.dart';
import './providers/meetup_platform_session.dart';
import './providers/session.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('App:build');
    return Consumer2<Session, MeetupPlatformSession>(
      builder: (_, session, platform0, __) => MaterialApp(
        title: 'Event.Pizza',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: session.anyPlatformConnected
            ? HomePage()
            : FutureBuilder<void>(
                future: Future.wait([
                  platform0.tryToLoadFromPrefs(),
                  // platform1.tryToLoadFromPrefs(),
                ]),
                builder: (_, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? SplashPage()
                        : WelcomePage()),
        routes: {
          ConnectPlatformsPage.routeName: (_) => ConnectPlatformsPage(),
          MeetupAuthPage.routeName: (_) => MeetupAuthPage()
        },
      ),
    );
  }
}
