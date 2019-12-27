import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session.dart';
import '../providers/eventbrite_platform_session.dart';
import '../widgets/platform_connector.dart';
import '../widgets/body_text_with_padding.dart';
import '../providers/meetup_platform_session.dart';

class ConnectPlatformsPage extends StatelessWidget {
  static const routeName = "connectPlatforms";

  @override
  Widget build(BuildContext context) {
    print('ConnectPlatformsPage:Updated');

    final meetupPlatform = Provider.of<MeetupPlatformSession>(context);
    final eventbritePlatform = Provider.of<EventbritePlatformSession>(context);
    final session = Provider.of<Session>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Platforms'),
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
              PlatformConnector(meetupPlatform),
              PlatformConnector(eventbritePlatform),
              Spacer(),
              Visibility(
                visible: session.anyPlatformConnected,
                child: RaisedButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => Navigator.popUntil(
                    context,
                    ModalRoute.withName(Navigator.defaultRouteName),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
