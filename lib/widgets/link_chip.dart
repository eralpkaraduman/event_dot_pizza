import 'package:event_dot_pizza/models/contributor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkChip extends StatelessWidget {
  final String text, url;
  final ImageProvider image;
  const LinkChip(
    this.text, {
    Key key,
    @required this.url,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: CircleAvatar(
        backgroundImage: image,
        backgroundColor: Theme.of(context).cardColor,
      ),
      label: Text(text),
      onPressed: () => launch(url),
    );
  }
}
