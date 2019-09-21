import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import '../models/event.dart';
import '../widgets/event_description.dart';
import '../widgets/share_button.dart';
import './event_url_page.dart';

class EventDetailPageArgs {
  final String id;
  EventDetailPageArgs(this.id);
}

class EventDetailPage extends StatelessWidget {
  static const routeName = "eventDetail";

  @override
  Widget build(BuildContext context) {
    final EventDetailPageArgs args = ModalRoute.of(context).settings.arguments;
    final Events events = Provider.of<Events>(context, listen: false);
    final Event event = events.find(args.id);
    // TODO: hande if event is not found
    final eventName = event?.name ?? 'Unknown Event';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          eventName,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 2,
        ),
        actions: <Widget>[
          new ShareButton(
            url: event.link,
            subject: eventName,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: event == null
                ? Center(child: Text('Unknown Event, Go Back.'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '📍 ${event.venueName}',
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '🗓 ${event.formattedLocalDateTime}',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      RaisedButton(
                        child: Text('Open Original Event Page'),
                        onPressed: () => Navigator.of(context).pushNamed(
                          EventUrlPage.routeName,
                          arguments: EventUrlPageArgs(event.link, event.name),
                        ),
                      ),
                      EventDescription(
                          description: event.description,
                          matches: event.matches),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
