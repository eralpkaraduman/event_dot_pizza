import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';
import '../providers/event.dart';
import './event_list_item.dart';

class EventList extends StatelessWidget {
  final Function onRefresh;

  EventList({this.onRefresh});

  @override
  // TODO: Implement pull to refresh https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  Widget build(BuildContext context) {
    print('EventList:build');
    return Consumer<Events>(
      builder: (_, eventsData, __) => SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          itemCount: eventsData.events.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
          ),
          itemBuilder: (_, index) => ChangeNotifierProvider<Event>.value(
            value: eventsData.events[index],
            child: EventListItem(),
          ),
        ),
      ),
    );
  }
}
