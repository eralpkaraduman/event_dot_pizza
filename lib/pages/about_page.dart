import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/async_version_text.dart';
import '../widgets/share_button.dart';
import '../widgets/contributors.dart';
import '../widgets/link_chip.dart';

const String _content = '''
Event.Pizza is an app that helps you find professional gathering events that offer free snacks and drinks.
So you can learn new things while not thinking what to eat for dinner!

Event.Pizza looks up events happening near you from various 3rd party event organization platforms.
Events you may see here are not organized by us.

This app was created and maintained by Eralp Karaduman, mainly for the purpose of exploring the cross platform app development tool Flutter (flutter.dev).

You can find the source code and contribute to development from the project web site (https://event.pizza)

Special Thanks To QVIK for allowing the time for development and research.
Go to qvik.fi to learn more (they are hiring)

Please share this app with your friends and colleagues by sending the url: https://event.pizza !
''';

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
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Event.Pizza'),
                  AsyncVersionText(),
                  Text(''),
                  Text(_content),
                  Row(),
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: <Widget>[
                      LinkChip(
                        'QVIK',
                        url: 'https://qvik.fi',
                        image: AssetImage('assets/images/qvik.png'),
                      ),
                      LinkChip(
                        'Event.Pizza',
                        url: 'https://event.pizza',
                        image: AssetImage('assets/images/pizza.jpeg'),
                      ),
                      LinkChip(
                        'Flutter',
                        url: 'https://flutter.dev',
                        image: AssetImage('assets/images/flutter.png'),
                      ),
                    ],
                  ),
                  Text(''),
                  Contributors(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
