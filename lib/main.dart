import 'dart:async';

import 'package:event_dot_pizza/pages/city_selection_page.dart';
import 'package:event_dot_pizza/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/meetup_platform_session.dart';
import './providers/events.dart';
import './providers/session.dart';
import './pages/connect_platforms_page.dart';
import './pages/events_page.dart';
import './pages/meetup_auth_page.dart';
import './pages/splash_page.dart';
import './pages/welcome_page.dart';
import './pages/event_detail_page.dart';
import './pages/event_url_page.dart';
import './pages/about_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('App:Build');
    return MultiProvider(
      providers: [
        // MEETUP PLATFORM SESSION PROVIDER
        ChangeNotifierProvider.value(value: MeetupPlatformSession()),

        // SESSION PROXY PROVIDER
        ChangeNotifierProxyProvider<MeetupPlatformSession, Session>(
          builder: (_, platform0, prev) {
            return Session(
              platforms: [platform0],
              location: prev != null ? prev.location : null,
            );
          },
        ),

        // EVENTS PROVIDER
        ChangeNotifierProxyProvider<MeetupPlatformSession, Events>(
          builder: (_, platform0, __) => Events(platforms: [platform0]),
        ),
      ],
      child: Consumer2<Session, MeetupPlatformSession>(
        // Remove MeetupPlatformSession
        builder: (_, session, platform0, __) => MaterialApp(
          title: 'Event.Pizza',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepOrangeAccent,
          ),
          home: session.ready
              ? EventsPage()
              : FutureBuilder(
                  future: () async {
                    print('App:Initializing');
                    print('App:WaitingForNoReason');
                    await Future.delayed(const Duration(seconds: 1));
                    print('App:RecoveringStoredSession');
                    await session.tryToLoadFromPrefs();
                    print('App:RecoveringStoredSession:Meetup');
                    await platform0.tryToConnectFromPrefs();
                    print('App:InitializationComplete');
                  }(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return SplashPage();
                    } else if (session.ready) {
                      return EventsPage();
                    } else {
                      return WelcomePage();
                    }
                  },
                ),
          routes: {
            ConnectPlatformsPage.routeName: (_) => ConnectPlatformsPage(),
            MeetupAuthPage.routeName: (_) => MeetupAuthPage(),
            EventDetailPage.routeName: (_) => EventDetailPage(),
            EventUrlPage.routeName: (_) => EventUrlPage(),
            CitySelectionPage.routeName: (_) => CitySelectionPage(),
            SettingsPage.routeName: (_) => SettingsPage(),
            AboutPage.routeName: (_) => AboutPage()
          },
        ),
      ),
    );
  }
}
