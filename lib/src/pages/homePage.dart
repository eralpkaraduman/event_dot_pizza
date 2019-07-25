import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/routes.dart';
import 'package:provider/provider.dart';
import 'package:event_dot_pizza/src/state/meetupPlatformSession.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meetupPlatform = Provider.of<MeetupPlatformSession>(context);
    final atLeastOnePlatformIsConnected = meetupPlatform.isConnected;
    return Scaffold(
      appBar: AppBar(
        title: Text('Event.Pizza'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, Routes.connectPlatforms),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            atLeastOnePlatformIsConnected
                ? Text('List Of Events')
                : RaisedButton(
                    child: Text('Connect Platforms'),
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.connectPlatforms),
                  )
          ],
        ),
      ),
    );
  }
}
