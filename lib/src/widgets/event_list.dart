import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/routes.dart';
import 'package:provider/provider.dart';
import 'package:event_dot_pizza/src/state/session.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<Session>(context);
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
            if (appState.noPlatformsConnected) ...[
              RaisedButton(
                child: Text('Connect Platforms'),
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.connectPlatforms),
              )
            ] else ...[
              Text('List Of Events')
            ]
          ],
        ),
      ),
    );
  }
}
