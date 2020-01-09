import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session.dart';
import './city_selection_page.dart';
import './connect_platforms_page.dart';

class WelcomePage extends StatelessWidget {
  static const whitespace = SizedBox(height: 20.0);
  static const routeName = "welcome";
  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Event.Pizza'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  session.ready ? 'Setup Complete!' : 'Hi! 👋',
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                whitespace,
                Text(
                  session.ready
                      ? 'You have set up everything necessary!'
                      : 'Before we begin, we need to set a coupe of things;',
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,
                ),
                whitespace,
                Icon(
                  session.ready ? Icons.assignment_turned_in : Icons.assignment,
                  size: 60,
                  color: Theme.of(context).accentColor,
                ),
                whitespace,
                if (session.location == null) ...[
                  whitespace,
                  Text(
                    'We need to know which city you are at, so I can show you the closest events.',
                    style: Theme.of(context).textTheme.subhead,
                    textAlign: TextAlign.center,
                  ),
                  whitespace,
                  RaisedButton(
                    child: Text('Select Your City'),
                    onPressed: () => Navigator.pushNamed(
                        context, CitySelectionPage.routeName),
                  )
                ],
                if (!session.anyPlatformConnected) ...[
                  whitespace,
                  Text(
                    'We are relying on external event organization platforms to show nearby events to you. You need to log in to at least one of them to continue.',
                    style: Theme.of(context).textTheme.subhead,
                    textAlign: TextAlign.center,
                  ),
                  whitespace,
                  RaisedButton(
                    child: Text('Connect Event Sources'),
                    onPressed: () => Navigator.pushNamed(
                        context, ConnectPlatformsPage.routeName),
                  )
                ],
                Spacer(),
                FlatButton(
                  color: session.ready
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).highlightColor,
                  child: Text(
                    session.ready ? 'Continue' : 'Let\'s do this later',
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    Provider.of<Session>(context).ready
                        ? (route) => route.isFirst
                        : null,
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
