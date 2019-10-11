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
      title: Text(
        event.name,
        // TODO: move text styles to a constant somewhere
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${event.formattedLocalDateTime} ${event.venueName}',
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      isThreeLine: false,
      trailing: Text(
        event.matchTypes.map((t) => EventFilterMatchTypeEmojis[t]).join(' '),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        EventDetailPage.routeName,
        arguments: EventDetailPageArgs(event.id),
      ),
    );
  }
}
