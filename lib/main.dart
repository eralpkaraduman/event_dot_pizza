import 'package:event_dot_pizza/src/state/appState.dart';
import 'package:event_dot_pizza/src/state/meetup_platform_session.dart';
import 'package:event_dot_pizza/src/state/other_platform_session.dart';
import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/app.dart';
import 'package:provider/provider.dart';

void main() async {
  final meetupPlatformSession = await MeetupPlatformSession().loadFromPrefs();
  final otherPlatformSession = await OtherPlatformSession().loadFromPrefs();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(builder: (_) => meetupPlatformSession),
    ChangeNotifierProvider(builder: (_) => otherPlatformSession),
    ProxyProvider2<MeetupPlatformSession, OtherPlatformSession, AppState>(
        builder: (context, meetup, other, _) => AppState([meetup, other]))
  ], child: App()));
}
