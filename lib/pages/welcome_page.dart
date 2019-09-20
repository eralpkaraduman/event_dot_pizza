import 'package:event_dot_pizza/pages/city_selection_page.dart';
import 'package:flutter/material.dart';
import './connect_platforms_page.dart';
import '../providers/session.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = "welcome";
  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context, listen: true);

    Widget platforms = Visibility(
      visible: !session.anyPlatformConnected,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'I rely on external event organization platforms to show nearby events to you. You need to log in to at least one of them to continue.',
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              child: Text('Connect Platforms'),
              onPressed: () =>
                  Navigator.pushNamed(context, ConnectPlatformsPage.routeName),
            )
          ],
        ),
      ),
    );

    Widget location = Visibility(
      visible: session.location == null,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'I need to know which city you are at, so I can show you the closest events.',
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              child: Text('Select Your City'),
              onPressed: () =>
                  Navigator.pushNamed(context, CitySelectionPage.routeName),
            )
          ],
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Event.Pizza'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Hi! 👋',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Before we begin, we need to set a coupe of things;',
                  ),
                ),
                platforms,
                location,
              ],
            ),
          ),
        ));
  }
}
