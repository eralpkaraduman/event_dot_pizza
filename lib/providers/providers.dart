import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../models/persistent_data.dart';
import './deeplink.dart';
import './meetup_platform_session.dart';
import './eventbrite_platform_session.dart';
import './events.dart';
import './session.dart';

class Providers extends SingleChildStatelessWidget {
  Providers({Key key, Widget child}) : super(key: key, child: child);
  @override
  Widget buildWithChild(_, Widget child) {
    return MultiProvider(
      child: child,
      providers: [
        // PERSISTENT DATA
        FutureProvider<PersistentData>(
          create: (_) => PersistentData.createFromPrefs(),
        ),

        // Session
        ChangeNotifierProxyProvider<PersistentData, Session>(
          create: (_) => Session(null),
          update: (_, data, prev) => Session(data),
        ),

        ChangeNotifierProvider<Deeplink>(create: (_) => Deeplink()),

        // MeetupPlatformSession
        ChangeNotifierProxyProvider2<Deeplink, PersistentData,
            MeetupPlatformSession>(
          create: (_) => MeetupPlatformSession(null),
          update: (_, deeplink, data, prev) {
            final token = prev.accessToken ??
                deeplink.meetupAccessToken ??
                data.meetupAccessToken;
            data.setMeetupAccessToken(token);
            return MeetupPlatformSession(token);
          },
        ),

        // EventbritePlatformSession
        ChangeNotifierProxyProvider2<Deeplink, PersistentData,
            EventbritePlatformSession>(
          create: (_) => EventbritePlatformSession(null),
          update: (_, deeplink, data, prev) {
            final token = prev.accessToken ??
                deeplink.eventbriteAccessToken ??
                data.eventbriteAccessToken;
            data.setEventbriteAccessToken(token);
            return EventbritePlatformSession(token);
          },
        ),

        // Events
        ChangeNotifierProxyProvider3<MeetupPlatformSession,
            EventbritePlatformSession, PersistentData, Events>(
          create: (_) => Events(
            platforms: [],
            location: null,
          ),
          update: (_, meetup, eventbrite, data, __) => Events(
            platforms: [meetup, eventbrite],
            location: data.location,
          ),
        ),
      ],
    );
  }
}
