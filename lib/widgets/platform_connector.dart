import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformConnector extends StatelessWidget {
  PlatformConnector({
    @required this.name,
    @required this.authUri,
    @required this.onDisconnect,
    @required this.isConnected,
    this.disabled = false,
    Key key,
  }) : super(key: key);
  final String name;
  final String authUri;
  final bool isConnected, disabled;
  final void Function() onDisconnect;

  _launchAuthUri() async {
    if (await canLaunch(authUri)) {
      await launch(
        authUri,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not launch $authUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                name,
                style: Theme.of(context).textTheme.subtitle,
              ),
              Spacer(),
              Text(
                isConnected
                    ? 'Connected'
                    : disabled ? 'Not Available' : 'Not Connected',
                style: Theme.of(context).textTheme.subtitle,
              ),
              Icon(
                isConnected
                    ? Icons.check
                    : disabled ? Icons.block : Icons.error,
                color: isConnected
                    ? Theme.of(context).textTheme.body1.color
                    : Theme.of(context).colorScheme.primary,
              )
            ],
          ),
          RaisedButton(
            color: isConnected
                ? Theme.of(context).highlightColor
                : Theme.of(context).colorScheme.primary,
            onPressed: !isConnected
                ? disabled ? null : _launchAuthUri
                : this.onDisconnect,
            child: Text(
              '${isConnected ? 'Disconnect' : 'Connect'} $name',
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}
