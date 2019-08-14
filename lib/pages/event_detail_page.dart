import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import '../providers/event.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event?.name ?? 'Unknown Event',
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 2,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: event == null
                ? Center(child: Text('Unknown Event, Go Back.'))
                : Text(event.description),
          ),
        ),
      ),
    );
  }
}
