import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../platforms/eventbrite_platform_api.dart';
import '../platforms/meetup_platform_api.dart';
import '../providers/session.dart';
import '../widgets/platform_connector.dart';
import '../widgets/body_text_with_padding.dart';

class ConnectPlatformsPage extends StatelessWidget {
  static const routeName = "connectPlatforms";

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Event Sources'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BodyTextWithPadding(
                'We are relying on external event organization platforms to show nearby events to you. Them more you connect the more events you see.',
              ),
              BodyTextWithPadding(
                session.anyPlatformConnected
                    ? 'Great, you have a connected platform! You can continue using Event.Pizza. Connect more platforms now or anytime from the settings screen.'
                    : 'You need to log in to at least one of them to continue.',
                bold: true,
              ),
              PlatformConnector(
                name: 'Meetup.Com',
                authUri: MeetupPlatformApi.AUTH_URI,
                isConnected: session.meetupAccessToken != null,
                onDisconnect: () => session.meetupAccessToken = null,
              ),
              PlatformConnector(
                disabled: true,
                name: 'EventBrite',
                authUri: EventbritePlatformApi.AUTH_URI,
                isConnected: session.eventbriteAccessToken != null,
                onDisconnect: () => session.eventbriteAccessToken = null,
              ),
              Text('More event sources will be added soon!'),
              Spacer(),
              if (session.anyPlatformConnected) ...[
                RaisedButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => Navigator.pop(
                    context,
                    Provider.of<Session>(context).ready
                        ? (route) => route.isFirst
                        : null,
                  ),
                  child: Text('Continue'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
