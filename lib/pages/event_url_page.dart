import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/share_button.dart';

class EventUrlPageArgs {
  final String url;
  final String name;
  EventUrlPageArgs(this.url, this.name);
}

class EventUrlPage extends StatefulWidget {
  static const routeName = "eventUrl";

  @override
  _EventUrlPageState createState() => _EventUrlPageState();
}

class _EventUrlPageState extends State<EventUrlPage> {
  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    final EventUrlPageArgs args = ModalRoute.of(context).settings.arguments;
    final String allowedUriHost = Uri.parse(args.url).host;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.name,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 2,
        ),
        actions: <Widget>[
          new ShareButton(
            url: args.url,
            subject: args.name,
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          WebView(
            initialUrl: args.url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) =>
                Uri.parse(request.url).host == allowedUriHost
                    ? NavigationDecision.navigate
                    : NavigationDecision.prevent,
            onPageFinished: (_) => setState(() {
              _loading = false;
            }),
          ),
          Visibility(
            visible: _loading,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
