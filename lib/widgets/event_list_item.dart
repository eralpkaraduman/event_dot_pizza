import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event.dart';
import '../pages/event_detail_page.dart';

class EventListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          EventDetailPage.routeName,
          arguments: EventDetailPageArguments(
            id: event.id,
            platform: event.platform,
          ),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.name,
                // TODO: move text styles to a constant somewhere
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
