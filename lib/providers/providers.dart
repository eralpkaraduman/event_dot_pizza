import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../models/persistent_data.dart';
import './deeplink.dart';
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

        ChangeNotifierProvider<Deeplink>(create: (_) => Deeplink()),

        // Session
        ChangeNotifierProxyProvider2<PersistentData, Deeplink, Session>(
          create: (_) => Session(null, null, null, null),
          update: (_, data, deeplink, prev) {
            final meetupToken = data?.meetupAccessToken ??
                prev.meetupAccessToken ??
                deeplink.meetupAccessToken;

            if (meetupToken != null) {
              // TODO: find a smarter way to do this
              PersistentData.setMeetupAccessToken(meetupToken);
            }

            final eventbriteToken = data?.eventbriteAccessToken ??
                prev.eventbriteAccessToken ??
                deeplink.eventbriteAccessToken;

            if (eventbriteToken != null) {
              // TODO: find a smarter way to do this
              PersistentData.setEventbriteAccessToken(eventbriteToken);
            }

            final location = data?.location ?? prev.location;

            final brightness =
                data?.themeBrightnessIndex ?? prev.themeBrightnessIndex;

            return Session(eventbriteToken, meetupToken, location, brightness);
          },
        ),

        // Events
        ChangeNotifierProxyProvider<Session, Events>(
          create: (_) => Events(null),
          update: (_, session, __) => Events(session),
        ),
      ],
    );
  }
}
