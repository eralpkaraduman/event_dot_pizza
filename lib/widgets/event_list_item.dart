import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dictionary_matcher.dart';
import '../models/event.dart';
import '../pages/event_detail_page.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({Key key, @required this.event}) : super(key: key);
  final Event event;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.name, style: Theme.of(context).textTheme.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              event.formattedLocalDateTime,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '@ ${event.venueName}',
              style: Theme.of(context).textTheme.body1,
            ),
          )
        ],
      ),
      isThreeLine: false,
      trailing: Text(
        event.matchTypes.map((t) => EventFilterMatchTypeEmojis[t]).join(' '),
        style: Theme.of(context).textTheme.title,
      ),
      onTap: () => Navigator.of(context).pushNamed(
        EventDetailPage.routeName,
        arguments: EventDetailPageArgs(event.id),
      ),
    );
  }
}
