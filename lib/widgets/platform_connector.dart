import 'package:event_dot_pizza/providers/platform_session.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformConnector extends StatelessWidget {
  PlatformConnector(this.platform, {Key key}) : super(key: key);
  final PlatformSession platform;

  _launchAuthUri() async {
    if (await canLaunch(platform.authUri)) {
      await launch(
        platform.authUri,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not launch ${platform.authUri}';
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
              Text('${platform.name}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Text(
                '${platform.isConnected ? 'Connected' : 'Not Connected'} ',
                style: TextStyle(fontSize: 18),
              ),
              Icon(
                platform.isConnected ? Icons.check : Icons.error,
                color: platform.isConnected
                    ? Theme.of(context).textTheme.body1.color
                    : Theme.of(context).colorScheme.primary,
              )
            ],
          ),
          RaisedButton(
            color: platform.isConnected
                ? Theme.of(context).highlightColor
                : Theme.of(context).colorScheme.primary,
            onPressed:
                platform.isConnected ? platform.disconnect : _launchAuthUri,
            child: Text(
              '${platform.isConnected ? 'Disconnect' : 'Connect'} ${platform.name}',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
