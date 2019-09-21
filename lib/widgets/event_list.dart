import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';
import './event_list_item.dart';

class EventList extends StatelessWidget {
  @override
  // TODO: Implement pull to refresh https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  Widget build(BuildContext context) {
    print('EventList:build');
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    return Consumer<Events>(
      builder: (_, eventsProvider, __) => ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
        itemCount: eventsProvider.events.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
        ),
        itemBuilder: (_, index) => EventListItem(
          event: eventsProvider.events[index],
        ),
      ),
    );
  }
}
