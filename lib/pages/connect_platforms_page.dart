import 'package:event_dot_pizza/providers/eventbrite_platform_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './meetup_auth_page.dart';
import './eventbrite_auth_page.dart';
import '../providers/meetup_platform_session.dart';

class ConnectPlatformsPage extends StatelessWidget {
  static const routeName = "connectPlatforms";

  @override
  Widget build(BuildContext context) {
    print('ConnectPlatformsPage:Updated');
    final positiveColor = Theme.of(context).buttonColor;
    final negativeColor = Theme.of(context).colorScheme.error;
    final buttonPadding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 20);
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Platforms'),
      ),
      body: SafeArea(
        child: Center(
          child: Consumer2<MeetupPlatformSession, EventbritePlatformSession>(
            builder: (context, meetupPlatform, eventbritePlatform, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: buttonPadding,
                  child: RaisedButton(
                    textTheme: ButtonTextTheme.primary,
                    color: meetupPlatform.isConnected
                        ? negativeColor
                        : positiveColor,
                    child: meetupPlatform.isConnected
                        ? Text('Disconnect Meetup.com')
                        : Text('Connect Meetup.com'),
                    onPressed: () => meetupPlatform.isConnected
                        ? meetupPlatform.disconnect()
                        : Navigator.pushNamed(
                            context,
                            MeetupAuthPage.routeName,
                          ),
                  ),
                ),
                Padding(
                  padding: buttonPadding,
                  child: RaisedButton(
                    textTheme: ButtonTextTheme.primary,
                    color: eventbritePlatform.isConnected
                        ? negativeColor
                        : positiveColor,
                    child: eventbritePlatform.isConnected
                        ? Text('Disconnect Eventbrite')
                        : Text('Connect Eventbrite'),
                    onPressed: () => eventbritePlatform.isConnected
                        ? eventbritePlatform.disconnect()
                        : Navigator.pushNamed(
                            context,
                            EventbriteAuthPage.routeName,
                          ),
                  ),
                ),

                // Visibility(
                //   visible: meetupPlatform.isConnected,
                //   child: RaisedButton(
                //       color: Theme.of(context).errorColor,
                //       child: Text('Disconnect Meetup.com'),
                //       onPressed: () => meetupPlatform.disconnect()),
                // ),
                // Visibility(
                //   visible: !meetupPlatform.isConnected,
                //   child: RaisedButton(
                //     child: Text('Connect Meetup.com'),
                //     onPressed: () =>
                //         Navigator.pushNamed(context, MeetupAuthPage.routeName),
                //   ),
                // ),
                // Visibility(
                //   visible: eventbritePlatform.isConnected,
                //   child: RaisedButton(
                //       color: Theme.of(context).errorColor,
                //       child: Text('Disconnect Eventbrite'),
                //       onPressed: () => eventbritePlatform.disconnect()),
                // ),
                // Visibility(
                //   visible: !eventbritePlatform.isConnected,
                //   child: RaisedButton(
                //     child: Text('Connect Eventbrite'),
                //     onPressed: () => Navigator.pushNamed(
                //         context, EventbriteAuthPage.routeName),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
