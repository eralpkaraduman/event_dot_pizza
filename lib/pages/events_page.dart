import 'dart:async';

import 'package:event_dot_pizza/models/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meetup_platform_session.dart';
import '../providers/session.dart';
import '../pages/settings_page.dart';
import '../widgets/event_list.dart';
import '../widgets/event_list_header.dart';

class EventsPage extends StatefulWidget {
  static const routeName = "events";

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Location _lastLoadedLocation;
  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() => scheduleMicrotask(() {
        Location location = Provider.of<Session>(context).location;
        this.setState(() {
          _lastLoadedLocation = location;
        });
        Provider.of<MeetupPlatformSession>(context).refreshEvents(location);
      });

  @override
  void didUpdateWidget(EventsPage oldWidget) {
    Location currentLocation =
        Provider.of<Session>(context, listen: false).location;
    if (_lastLoadedLocation != null &&
        !_lastLoadedLocation.equalsTo(currentLocation)) {
      _refresh();
    }
    super.didUpdateWidget(oldWidget);
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
          EventListHeader(
            onRefresh: _refresh,
          ),
          Expanded(
            child: EventList(),
          ),
        ],
      ),
    );
  }
}
