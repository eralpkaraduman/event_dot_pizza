import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';

class EventDetailPageArguments {
  final String id;
  final String platform; // TODO: Move to enum
  EventDetailPageArguments({this.id, this.platform});
}

class EventDetailPage extends StatelessWidget {
  static const routeName = "eventDetail";
  @override
  Widget build(BuildContext context) {
    final EventDetailPageArguments args =
        ModalRoute.of(context).settings.arguments;
    final event = Provider.of<Events>(
      context,
      listen: false,
    ).find(
      id: args.id,
      platform: args.platform,
    );
    // TODO: handle when event wasnt found
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Detail'),
      ),
      body: Center(
        child: Text(event.name),
      ),
    );
  }
}
