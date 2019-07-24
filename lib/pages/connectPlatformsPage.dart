import 'package:event_dot_pizza/routes.dart';
import 'package:flutter/material.dart';
import 'package:event_dot_pizza/pages/meetupAuthPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kMeetupAccessToken = 'meetupAccessToken';

class ConnectPlatformsPage extends StatefulWidget {
  @override
  _ConnectPlatformsPageState createState() => _ConnectPlatformsPageState();
}

class _ConnectPlatformsPageState extends State<ConnectPlatformsPage> {
  String _meetupAccessToken;

  @override
  void initState() {
    super.initState();
    _loadAccessTokens();
  }

  _loadAccessTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _meetupAccessToken = prefs.getString(kMeetupAccessToken) ?? null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Platforms'),
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
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      _meetupAccessToken = null;
                      prefs.remove(kMeetupAccessToken);
                    });
                  }),
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
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      _meetupAccessToken = result.accessToken;
                      prefs.setString(kMeetupAccessToken, result.accessToken);
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
