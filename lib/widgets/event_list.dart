import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/events.dart';
import '../providers/event.dart';
import './event_list_item.dart';

class EventList extends StatelessWidget {
  EventList({
    Key key,
    @required this.onRefresh,
  }) : super(key: key);

  final Function onRefresh;

  @override
  // TODO: Implement pull to refresh https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  Widget build(BuildContext context) {
    print('EventList:build');
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    return Consumer<Events>(
      builder: (_, eventsData, __) => ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
        itemCount: eventsData.events.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
        ),
        itemBuilder: (_, index) => ChangeNotifierProvider<Event>.value(
          value: eventsData.events[index],
          child: EventListItem(),
        ),
      ),
    );
  }
}
