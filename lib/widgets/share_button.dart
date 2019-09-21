import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:share/share.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key key,
    @required this.url,
    @required this.subject,
  }) : super(key: key);

  final String url;
  final String subject;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () => Share.share(url, subject: subject),
    );
  }
}
