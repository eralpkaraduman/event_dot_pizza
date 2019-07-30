import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './src/app.dart';
import './src/providers/session.dart';
import './src/providers/meetup_platform_events.dart';
import './src/providers/meetup_platform_session.dart';
import './src/providers/events.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MeetupPlatformSession()),
          ChangeNotifierProxyProvider<MeetupPlatformSession, Session>(
            builder: (_, platform0, __) => Session([platform0]),
          ),
          ChangeNotifierProxyProvider<MeetupPlatformSession,
              MeetupPlatformEvents>(
            builder: (_, session, prev) => MeetupPlatformEvents(
              accessToken: session.accessToken,
              events: prev != null ? prev.events : [],
            ),
          ),
          ChangeNotifierProxyProvider<MeetupPlatformEvents, Events>(
            builder: (_, platform0, __) => Events([platform0]),
          ),
        ],
        child: App(),
      ),
    );
