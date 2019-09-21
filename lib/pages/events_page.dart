import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/location.dart';
import '../pages/settings_page.dart';
import '../widgets/event_list.dart';
import '../widgets/event_list_header.dart';
import '../providers/meetup_platform_events.dart';
import '../providers/session.dart';

class EventsPage extends StatefulWidget {
  static const routeName = "events";
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() => _refresh());
  }

  _refresh() {
    Location location = Provider.of<Session>(context, listen: false).location;
    Provider.of<MeetupPlatformEvents>(context).refresh(
      lat: location.lat,
      lon: location.lon,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('EventsPage:Build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Event.Pizza 🍕'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsPage.routeName),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          EventListHeader(onRefresh: _refresh),
          Expanded(child: EventList(onRefresh: _refresh))
        ],
      ),
    );
  }
}
