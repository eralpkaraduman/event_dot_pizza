import 'package:flutter/material.dart';
import '../widgets/async_version_text.dart';
import '../widgets/share_button.dart';

class AboutPage extends StatelessWidget {
  static const routeName = "about";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        actions: <Widget>[
          ShareButton(
            url: 'https://event.pizza',
            subject: 'Event.Pizza',
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text('Event.Pizza'),
              AsyncVersionText(),
            ],
          ),
        ),
      ),
    );
  }
}
