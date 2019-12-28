import 'package:event_dot_pizza/models/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../models/immutable_persistent_data.dart';
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
        FutureProvider<ImmutablePersistentData>(
          create: (_) => ImmutablePersistentData.loadFromPrefs(),
        ),

        ChangeNotifierProvider<Deeplink>(create: (_) => Deeplink()),

        // SESSION
        ChangeNotifierProxyProvider2<ImmutablePersistentData, Deeplink,
            Session>(
          create: (_) => Session(),
          update: (_, initialData, deeplink, prev) {
            String meetupToken = prev.meetupAccessToken;
            String eventbriteToken = prev.eventbriteAccessToken;
            Location location = prev.location;
            int themeBrightnessIndex = prev.themeBrightnessIndex;

            // REHYDRATE STORED DATA
            if (initialData != null && initialData.expired == false) {
              meetupToken = initialData.meetupAccessToken;
              eventbriteToken = initialData.eventbriteAccessToken;
              location = initialData.location;
              themeBrightnessIndex = initialData.themeBrightnessIndex;
              initialData.expired = true;
            }

            // AUTH CALLBACKS
            if (deeplink.url != null) {
              if (deeplink.meetupAccessToken != null) {
                meetupToken = deeplink.meetupAccessToken;
                PersistentData.setMeetupAccessToken(meetupToken);
              }
              if (deeplink.eventbriteAccessToken != null) {
                eventbriteToken = deeplink.eventbriteAccessToken;
                PersistentData.setEventbriteAccessToken(eventbriteToken);
              }
              deeplink.clear();
            }

            return Session(
              eventbriteAccessToken: eventbriteToken,
              meetupAccessToken: meetupToken,
              location: location,
              themeBrightnessIndex: themeBrightnessIndex,
            );
          },
        ),

        // Events
        ChangeNotifierProxyProvider<Session, Events>(
          create: (_) => Events(null, []),
          update: (_, session, prev) => Events(session, prev.allEvents),
        ),
      ],
    );
  }
}
