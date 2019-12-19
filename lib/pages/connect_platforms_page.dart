import 'package:event_dot_pizza/providers/eventbrite_platform_session.dart';
import 'package:event_dot_pizza/providers/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './meetup_auth_page.dart';
import './eventbrite_auth_page.dart';
import '../providers/meetup_platform_session.dart';

TextStyle textStyle = TextStyle(fontSize: 18);
TextStyle boldTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

class ConnectPlatformsPage extends StatelessWidget {
  static const routeName = "connectPlatforms";

  @override
  Widget build(BuildContext context) {
    print('ConnectPlatformsPage:Updated');
    final positiveColor = Theme.of(context).colorScheme.primary;
    final negativeColor = Theme.of(context).highlightColor;

    final MeetupPlatformSession meetupPlatform =
        Provider.of<MeetupPlatformSession>(context);
    final EventbritePlatformSession eventbritePlatform =
        Provider.of<EventbritePlatformSession>(context);

    final bool anyPlatformConnected =
        Provider.of<Session>(context).anyPlatformConnected;

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
              Text(
                'We rely on external event organization platforms to show nearby events to you. Them more you connect the more events you see.',
                style: textStyle,
              ),
              SizedBox(height: 20),
              anyPlatformConnected
                  ? Text(
                      'Great, you have a connected platform! You can continue using Event.Pizza. Connect more platforms now or anytime from the settings screen.',
                      style: boldTextStyle,
                    )
                  : Text(
                      'You need to log in to at least one of them to continue.',
                      style: boldTextStyle,
                    ),
              SizedBox(height: 20),
              Text(
                'Meetup.com: ${meetupPlatform.isConnected ? 'Connected ✅' : 'Not Connected ❌'}',
                style: textStyle,
              ),
              RaisedButton(
                color:
                    meetupPlatform.isConnected ? negativeColor : positiveColor,
                onPressed: () => meetupPlatform.isConnected
                    ? meetupPlatform.disconnect()
                    : Navigator.pushNamed(
                        context,
                        MeetupAuthPage.routeName,
                      ),
                child: Text(
                  '${meetupPlatform.isConnected ? 'Disconnect' : 'Connect'} Meetup.Com',
                  style: textStyle,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Eventbrite: ${eventbritePlatform.isConnected ? 'Connected ✅' : 'Not Connected ❌'}',
                style: textStyle,
              ),
              RaisedButton(
                color: eventbritePlatform.isConnected
                    ? negativeColor
                    : positiveColor,
                onPressed: () => eventbritePlatform.isConnected
                    ? eventbritePlatform.disconnect()
                    : Navigator.pushNamed(
                        context,
                        EventbriteAuthPage.routeName,
                      ),
                child: Text(
                  '${eventbritePlatform.isConnected ? 'Disconnect' : 'Connect'} Eventbrite',
                  style: textStyle,
                ),
              ),
              Spacer(),
              anyPlatformConnected
                  ? RaisedButton(
                      color: positiveColor,
                      onPressed: () => Navigator.popUntil(
                        context,
                        ModalRoute.withName(Navigator.defaultRouteName),
                      ),
                      child: Text(
                        'CONTINUE',
                        style: textStyle,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
