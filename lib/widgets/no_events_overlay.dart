import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoEventsOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.calendar_today, size: 100, color: Colors.grey),
          Text(
            'No events',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 32,
              color: Colors.grey,
            ),
          ),
          Text('No events were found!', style: TextStyle(color: Colors.grey)),
        ]),
      ),
    );
  }
}
