import 'package:flutter/material.dart';
import 'package:event_dot_pizza/pages/meetupAuthPage.dart';
import 'package:event_dot_pizza/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _meetupAccessToken;
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
            Visibility(
              visible: _meetupAccessToken != null,
              child: RaisedButton(
                color: Theme.of(context).errorColor,
                child: Text('Disconnect Meetup.com'),
                onPressed: () => setState(() {
                  _meetupAccessToken = null;
                }),
              ),
            ),
            Visibility(
              visible: _meetupAccessToken == null,
              child: RaisedButton(
                child: Text('Connect Meetup.com'),
                onPressed: () async {
                  final result =
                      await Navigator.pushNamed(context, Routes.meetupAuth)
                          as MeetupAuthPageResult;
                  if (result != null && result.accessToken != null) {
                    setState(() {
                      _meetupAccessToken = result.accessToken;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
