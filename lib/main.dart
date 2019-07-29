import 'package:event_dot_pizza/src/app.dart';
import 'package:event_dot_pizza/src/state/session.dart';
import 'package:event_dot_pizza/src/state/meetup_platform_events.dart';
import 'package:event_dot_pizza/src/state/meetup_platform_session.dart';
import 'package:event_dot_pizza/src/state/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(builder: (_) => MeetupPlatformSession()),
      ChangeNotifierProvider(builder: (_) => MeetupPlatformEvents()),
      ProxyProvider<MeetupPlatformSession, Session>(
          builder: (_, meetupSession, __) => Session([meetupSession])),
      ProxyProvider<MeetupPlatformEvents, Events>(
          builder: (_, meetupEvents, __) => Events([meetupEvents])),
    ], child: App()));
