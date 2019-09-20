import 'dart:async';

import 'package:event_dot_pizza/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/event_list.dart';
import '../widgets/event_list_header.dart';
import '../providers/meetup_platform_events.dart';
import 'package:event_dot_pizza/services/location_service.dart';

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
//    suggestedCities();
  }

  suggestedCities() async {
    var cities =
        await Provider.of<LocationService>(context).getSuggestedCites("hels");
    cities.forEach((city) {
      print(city as String);
      //      var placeMarkers =
      //          await Geolocator().placemarkFromAddress(city as String);
      //      placeMarkers.forEach((place) => print(place.position.toString()));
    });

    await Provider.of<LocationService>(context).getCityPosition("helsinki");
  }

  _refresh() async {
    await Provider.of<MeetupPlatformEvents>(context).refresh();
    suggestedCities();
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
