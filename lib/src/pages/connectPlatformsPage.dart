import 'package:event_dot_pizza/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/state/meetup_platform_session.dart';
import 'package:provider/provider.dart';

class ConnectPlatformsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meetupPlatform = Provider.of<MeetupPlatformSession>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Platforms'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: meetupPlatform.isConnected,
              child: RaisedButton(
                  color: Theme.of(context).errorColor,
                  child: Text('Disconnect Meetup.com'),
                  onPressed: () => Provider.of<MeetupPlatformSession>(context)
                      .accessToken = null),
            ),
            Visibility(
              visible: !meetupPlatform.isConnected,
              child: RaisedButton(
                child: Text('Connect Meetup.com'),
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.meetupAuth),
              ),
            )
          ],
        ),
      ),
    );
  }
}
