import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventListOverlay extends StatelessWidget {
  const EventListOverlay({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.message,
    this.buttonTitle,
    this.onButtonPressed,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String message;
  final String buttonTitle;
  final Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            icon,
            size: 100,
            color: Theme.of(context).textTheme.caption.color,
          ),
          Text(
            title,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 32,
              color: Theme.of(context).textTheme.caption.color,
            ),
          ),
          Text(
            this.message,
            style: TextStyle(color: Theme.of(context).textTheme.caption.color),
          ),
          if (onButtonPressed != null && buttonTitle != null) ...[
            RaisedButton(
              child: Text(buttonTitle),
              onPressed: onButtonPressed,
            ),
          ]
        ]),
      ),
    );
  }
}
