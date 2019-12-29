import 'package:flutter/material.dart';

class BodyTextWithPadding extends StatelessWidget {
  BodyTextWithPadding(
    this.text, {
    this.bold = false,
    Key key,
  }) : super(key: key);

  final String text;
  final bool bold;
  final TextStyle textStyle = TextStyle(fontSize: 18);
  final TextStyle boldTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: bold ? boldTextStyle : textStyle,
      ),
      padding: EdgeInsets.only(bottom: 20),
    );
  }
}
