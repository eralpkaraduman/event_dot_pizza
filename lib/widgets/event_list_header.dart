import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';

class EventListHeader extends StatelessWidget {
  final Function onRefresh;

  EventListHeader({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    print('flutter: EventListHeader:build');
    return Consumer<Events>(
      builder: (_, eventsData, __) => Container(
          color: Theme.of(context).secondaryHeaderColor,
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            bottom: false,
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: eventsData.refreshing ? null : onRefresh,
                      child: Text('Refresh'),
                    ),
                    Text(eventsData.refreshing
                        ? 'refreshing'
                        : 'not refreshing'),
                    Text(
                      '#events: ${eventsData.allEvents.length}',
                    ),
                    Text(
                      '#matching events: ${eventsData.events.length}',
                    ),
                  ],
                ),
                Container(
                  child: eventsData.refreshing
                      ? CircularProgressIndicator()
                      : null,
                  padding: const EdgeInsets.all(8.0),
                )
              ],
            ),
          )),
    );
  }
}
