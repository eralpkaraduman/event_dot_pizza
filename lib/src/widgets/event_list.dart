import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';
import '../providers/meetup_platform_events.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Events, MeetupPlatformEvents>(
      builder: (_, events, platform0, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('num events: ${events.events.length}'),
            Text(events.refreshing ? 'refreshing' : 'not refreshing'),
            Text('List Of Events'),
            RaisedButton(
              onPressed: () => platform0.refresh(),
              child: Text('Refresh'),
            )
          ],
        ),
      ),
    );
  }
}
