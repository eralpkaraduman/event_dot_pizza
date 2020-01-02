import 'package:event_dot_pizza/providers/navigation_stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
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
        ChangeNotifierProvider<Deeplink>(create: (_) => Deeplink()),

        // SESSION
        ChangeNotifierProxyProvider<Deeplink, Session>(
          create: (_) {
            final session = Session();
            session.loadFromPrefs();
            return session;
          },
          update: (_, deeplink, session) {
            if (deeplink.url != null) {
              if (deeplink.meetupAccessToken != null)
                session.meetupAccessToken = deeplink.meetupAccessToken;

              if (deeplink.eventbriteAccessToken != null)
                session.eventbriteAccessToken = deeplink.eventbriteAccessToken;

              WidgetsBinding.instance.addPostFrameCallback(
                (_) => deeplink.clear(),
              );
            }

            return session;
          },
        ),

        // Events
        ChangeNotifierProxyProvider<Session, Events>(
          create: (_) => Events(),
          update: (_, session, events) {
            events.meetupAccessToken = session.meetupAccessToken;
            events.eventbriteAccessToken = session.eventbriteAccessToken;
            events.location = session.location;
            return events;
          },
        ),

        ChangeNotifierProvider<NavigationStack>(
          create: (_) => NavigationStack(),
        )
      ],
    );
  }
}
