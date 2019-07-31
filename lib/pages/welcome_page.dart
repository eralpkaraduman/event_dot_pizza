import 'package:flutter/material.dart';
import './connect_platforms_page.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = "welcome";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Event.Pizza'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Welcome!'),
              Text('You need to connect them platforms.'),
              RaisedButton(
                child: Text('Connect Platforms'),
                onPressed: () => Navigator.pushNamed(
                    context, ConnectPlatformsPage.routeName),
              )
            ],
          ),
        ));
  }
}
