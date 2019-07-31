import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';

class EventList extends StatelessWidget {
  final Function onRefresh;

  EventList({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    print('EventList:build');
    return Consumer<Events>(
      builder: (_, events, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('num events: ${events.events.length}'),
            Text(events.refreshing ? 'refreshing' : 'not refreshing'),
            Text('List Of Events'),
            RaisedButton(
              onPressed: () => onRefresh(),
              child: Text('Refresh'),
            )
          ],
        ),
      ),
    );
  }
}
