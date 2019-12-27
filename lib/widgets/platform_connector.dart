import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/platform_session.dart';

class PlatformConnector extends StatelessWidget {
  PlatformConnector(this.platform, {@required this.onDisconnect, Key key})
      : super(key: key);
  final PlatformSession platform;
  final void Function() onDisconnect;

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
                !platform.isConnected ? _launchAuthUri : this.onDisconnect,
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
