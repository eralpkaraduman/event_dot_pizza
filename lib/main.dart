import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/meetup_platform_events.dart';
import './providers/meetup_platform_session.dart';
import './providers/events.dart';
import './providers/session.dart';
import './pages/connectPlatformsPage.dart';
import './pages/homePage.dart';
import './pages/meetupAuthPage.dart';
import './pages/splash_page.dart';
import './pages/welcome_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('App:Build');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MeetupPlatformSession()),
        ChangeNotifierProxyProvider<MeetupPlatformSession, Session>(
          builder: (_, platform0, __) => Session(platforms: [platform0]),
        ),
        ChangeNotifierProxyProvider<MeetupPlatformSession,
            MeetupPlatformEvents>(
          builder: (_, session, prev) => MeetupPlatformEvents(
            accessToken: session.accessToken,
            events: prev != null ? prev.events : [],
          ),
        ),
        ChangeNotifierProxyProvider<MeetupPlatformEvents, Events>(
          builder: (_, platform0, __) => Events(platforms: [platform0]),
        ),
      ],
      child: Consumer2<Session, MeetupPlatformSession>(
        builder: (_, session, platform0, __) => MaterialApp(
          title: 'Event.Pizza',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blueAccent,
          ),
          home: session.anyPlatformConnected
              ? HomePage()
              : FutureBuilder(
                  future: Future.wait([
                    platform0.tryToConnectFromPrefs(),
                    // platform1.tryToConnectFromPrefs(),
                  ]),
                  builder: (_, snap) =>
                      snap.connectionState == ConnectionState.waiting
                          ? SplashPage()
                          : WelcomePage(),
                ),
          routes: {
            ConnectPlatformsPage.routeName: (_) => ConnectPlatformsPage(),
            MeetupAuthPage.routeName: (_) => MeetupAuthPage()
          },
        ),
      ),
    );
  }
}
