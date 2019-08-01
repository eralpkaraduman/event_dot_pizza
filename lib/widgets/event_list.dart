import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';
import '../providers/event.dart';
import './event_list_item.dart';

class EventList extends StatelessWidget {
  final Function onRefresh;

  EventList({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    print('EventList:build');
    return Consumer<Events>(
      builder: (_, eventsData, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Theme.of(context).secondaryHeaderColor,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('num events: ${eventsData.events.length}'),
                Text(eventsData.refreshing ? 'refreshing' : 'not refreshing'),
                Text('List Of Events'),
                RaisedButton(
                  onPressed: onRefresh,
                  child: Text('Refresh'),
                ),
              ],
            ),
          ),
          Expanded(
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
        ],
      ),
    );
  }
}

// {
//   return Container(
//     child: Center(
//       child: Text('item $index'),
//     ),
//   );
// },
