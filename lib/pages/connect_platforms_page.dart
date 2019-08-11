import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './meetup_auth_page.dart';
import '../providers/meetup_platform_session.dart';

class ConnectPlatformsPage extends StatelessWidget {
  static const routeName = "connectPlatforms";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Platforms'),
      ),
      body: SafeArea(
        child: Center(
          child: Consumer<MeetupPlatformSession>(
            builder: (context, meetupPlatform, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: meetupPlatform.isConnected,
                  child: RaisedButton(
                      color: Theme.of(context).errorColor,
                      child: Text('Disconnect Meetup.com'),
                      onPressed: () => meetupPlatform.disconnect()),
                ),
                Visibility(
                  visible: !meetupPlatform.isConnected,
                  child: RaisedButton(
                    child: Text('Connect Meetup.com'),
                    onPressed: () =>
                        Navigator.pushNamed(context, MeetupAuthPage.routeName),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
