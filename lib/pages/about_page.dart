import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/async_version_text.dart';
import '../widgets/share_button.dart';

const String _content = '''
Event.Pizza is an app that helps you find professional gathering events that offer free snacks and drinks.
So you can learn new things while not thinking what to eat for dinner!

Event.Pizza looks up events happening near you from various 3rd party event orgnization platforms.
Events you may see here are not organized by us.

This app was created and maintained by Eralp Karaduman <eralp@eralpkaraduman.com>, for exploring the cross platform app development tool Flutter<flutter.dev>.

You can find the source code and contribute to development from the web site
https://event.pizza

Special Thanks To QVIK for allowing the time for development and research.
Go to qvik.fi to learn more (they are hiring)

Please share this app to your friends and colleagues by sending the url https://event.pizza !
''';

class AboutPage extends StatefulWidget {
  static const routeName = "about";

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<String> _contributors = [];
  bool _contributorsPending = false;

  @override
  void initState() {
    fetchContributors();
    super.initState();
  }

  void fetchContributors() async {
    this.setState(() => _contributorsPending = true);
    http.Response response = await http.get(
      'https://api.github.com/repos/eralpkaraduman/event_dot_pizza/contributors',
    );
    print(_contributors);
    this.setState(() => _contributorsPending = false);
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = jsonDecode(response.body);
      List<String> updatedContributors = decodedResponse
          .map((contributor) => contributor['login'].toString())
          .toList();
      print(updatedContributors);
      this.setState(() => _contributors = updatedContributors);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Event.Pizza'),
        actions: <Widget>[
          ShareButton(
            url: 'https://event.pizza',
            subject: 'Event.Pizza',
          )
        ],
      ),
      body: Scrollbar(
        child: Scrollable(
          axisDirection: AxisDirection.down,
          viewportBuilder: (_, __) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Event.Pizza'),
                  AsyncVersionText(),
                  Text(''),
                  Text(_content),
                  Text('Contributors:'),
                  _contributorsPending
                      ? Text('Loading...')
                      : _contributors.length == 0
                          ? Text('Failed to load.')
                          : _contributors
                              .map(
                                (contributor) => Text(contributor),
                              )
                              .toList(),
                ],
              ),
            );
          },
          // ,
        ),
      ),
    );
  }
}
