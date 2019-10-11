import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';

class EventListHeader extends StatelessWidget {
  EventListHeader({
    Key key,
    @required this.onRefresh,
  }) : super(key: key);

  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    print('flutter: EventListHeader:build');
    return Consumer<Events>(
      builder: (_, eventsProvider, __) => Container(
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
                      onPressed:
                          eventsProvider.refreshing ? null : this.onRefresh,
                      child: Text('Refresh'),
                    ),
                    Text(eventsProvider.refreshing
                        ? 'refreshing'
                        : 'not refreshing'),
                    Text(
                      '#events: ${eventsProvider.allEvents.length}',
                    ),
                    Text(
                      '#matching events: ${eventsProvider.events.length}',
                    ),
                  ],
                ),
                Container(
                  child: eventsProvider.refreshing
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
