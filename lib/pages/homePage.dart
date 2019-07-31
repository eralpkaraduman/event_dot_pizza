import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './connectPlatformsPage.dart';
import '../widgets/event_list.dart';
import '../providers/meetup_platform_events.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() => _refresh());
  }

  _refresh() {
    Provider.of<MeetupPlatformEvents>(context).refresh();
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage:Build');
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
      body: EventList(
        onRefresh: _refresh,
      ),
    );
  }
}
