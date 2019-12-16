import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoEventsOverlay extends StatelessWidget {
  const NoEventsOverlay({
    Key key,
    @required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.calendar_today,
              size: 100, color: Theme.of(context).accentColor),
          Text(
            'No events',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 32,
              color: Theme.of(context).accentColor,
            ),
          ),
          Text(this.message,
              style: TextStyle(color: Theme.of(context).accentColor)),
        ]),
      ),
    );
  }
}
