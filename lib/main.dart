import 'dart:async';

import 'package:event_dot_pizza/pages/city_selection_page.dart';
import 'package:event_dot_pizza/pages/settings_page.dart';
import 'package:event_dot_pizza/providers/deeplink.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import './providers/meetup_platform_session.dart';
import './providers/eventbrite_platform_session.dart';
import './providers/events.dart';
import './providers/session.dart';
import './pages/connect_platforms_page.dart';
import './pages/events_page.dart';
import './pages/splash_page.dart';
import './pages/welcome_page.dart';
import './pages/event_detail_page.dart';
import './pages/event_url_page.dart';
import './pages/about_page.dart';

void main() => runApp(App());

class App extends StatelessWidget with WidgetsBindingObserver {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver firebaseAnalyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(_) {
    print('App:Build');
    return MultiProvider(
      providers: [
        // Deeplink Handler
        ChangeNotifierProvider<Deeplink>(builder: (_) => Deeplink()),

        // MEETUP PLATFORM SESSION PROVIDER
        ChangeNotifierProxyProvider<Deeplink, MeetupPlatformSession>(
            builder: (_, deeplink, prev) {
          String deeplinkToken = deeplink.meetupToken;
          return MeetupPlatformSession(
            deeplinkToken != null ? deeplinkToken : prev?.accessToken,
          );
        }),

        // EVENTBRITE PLATFORM SESSION PROVIDER
        ChangeNotifierProxyProvider<Deeplink, EventbritePlatformSession>(
            builder: (_, deeplink, prev) {
          String deeplinkToken = deeplink.eventBriteToken;
          return EventbritePlatformSession(
            deeplinkToken != null ? deeplinkToken : prev?.accessToken,
          );
        }),

        // SESSION PROXY PROVIDER
        ChangeNotifierProxyProvider2<MeetupPlatformSession,
            EventbritePlatformSession, Session>(
          builder: (_, platform0, platform1, prev) {
            return Session(
              platforms: [platform0, platform1],
              location: prev?.location,
              themeBrightness: prev?.themeBrightness,
            );
          },
        ),

        // EVENTS PROXY PROVIDER
        ChangeNotifierProxyProvider3<MeetupPlatformSession,
            EventbritePlatformSession, Session, Events>(
          builder: (_, platform0, platform1, session, __) => Events(
            platforms: [platform0, platform1],
            location: session.location,
          ),
        ),
      ],
      child: Consumer<Session>(
        builder: (_, session, __) => MaterialApp(
          title: 'Event.Pizza',
          theme: ThemeData(
            brightness: session.themeBrightness,
            toggleableActiveColor: Colors.deepOrangeAccent,
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
          navigatorObservers: [firebaseAnalyticsObserver],
          routes: {
            ConnectPlatformsPage.routeName: (_) => ConnectPlatformsPage(),
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
