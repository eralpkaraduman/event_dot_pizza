import 'package:flutter/material.dart';

class BodyTextWithPadding extends StatelessWidget {
  BodyTextWithPadding(
    this.text, {
    this.bold = false,
    Key key,
  }) : super(key: key);

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: bold
            ? Theme.of(context).textTheme.title
            : Theme.of(context).textTheme.subtitle,
      ),
      padding: EdgeInsets.only(bottom: 20),
    );
  }
}
