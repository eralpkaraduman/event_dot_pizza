import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import './providers/providers.dart';
import './providers/navigation_stack.dart';
import './providers/session.dart';
import './pages/city_selection_page.dart';
import './pages/settings_page.dart';
import './pages/connect_platforms_page.dart';
import './pages/events_page.dart';
import './pages/welcome_page.dart';
import './pages/event_detail_page.dart';
import './pages/event_url_page.dart';
import './pages/about_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver _firebaseAnalyticsObserver =
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Widget build(_) {
    return Providers(
      child: Consumer<Session>(
        builder: (context, session, __) => MaterialApp(
          title: 'Event.Pizza',
          theme: ThemeData(
            brightness: session.themeBrightness,
            toggleableActiveColor: Colors.deepOrangeAccent,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepOrangeAccent,
          ),
          //TODO: implement "darkTheme" property here instead of flipping the theme.brightness https://proandroiddev.com/how-to-dynamically-change-the-theme-in-flutter-698bd022d0f0
          navigatorObservers: [
            _firebaseAnalyticsObserver,
            Provider.of<NavigationStack>(context, listen: false).observer,
          ],
          initialRoute: EventsPage.routeName,
          routes: {
            EventsPage.routeName: (_) => EventsPage(),
            ConnectPlatformsPage.routeName: (_) => ConnectPlatformsPage(),
            EventDetailPage.routeName: (_) => EventDetailPage(),
            EventUrlPage.routeName: (_) => EventUrlPage(),
            CitySelectionPage.routeName: (_) => CitySelectionPage(),
            SettingsPage.routeName: (_) => SettingsPage(),
            AboutPage.routeName: (_) => AboutPage(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case WelcomePage.routeName:
                return MaterialPageRoute(
                  fullscreenDialog: true,
                  settings: settings,
                  builder: (_) => WelcomePage(),
                );
              default:
                return null;
            }
          },
        ),
      ),
    );
  }
}
