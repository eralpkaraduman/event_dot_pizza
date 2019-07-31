import 'package:flutter/material.dart';
import './connectPlatformsPage.dart';
import '../widgets/event_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event.Pizza'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, ConnectPlatformsPage.routeName),
          )
        ],
      ),
      body: EventList(),
    );
  }
}
