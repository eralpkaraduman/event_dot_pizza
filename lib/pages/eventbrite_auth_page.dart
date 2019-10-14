import 'package:event_dot_pizza/utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/eventbrite_platform_session.dart';
import '../platforms/eventbrite_platform_api.dart';

class EventbriteAuthPage extends StatefulWidget {
  static const routeName = "eventbriteAuth";
  @override
  _EventbriteAuthPage createState() => _EventbriteAuthPage();
}

class _EventbriteAuthPage extends State<EventbriteAuthPage> {
  bool _loading = false;
  EventbritePlatformSession _eventbritePlatform;

  Map<String, String> parseRedirectParams(String url) {
    Map<String, String> paramsMap = Map();
    if (url.startsWith(EventbritePlatformApi.REDIRECT_URI)) {
      String query = url.split('#')[1];
      List<String> params = query.split('&');
      for (String params in params) {
        List<String> pair = params.split('=');
        paramsMap[pair[0]] = pair[1];
      }
    }
    return paramsMap;
  }

  @override
  void initState() {
    print('EventbriteAuthPage:InitState');
    _eventbritePlatform =
        Provider.of<EventbritePlatformSession>(context, listen: false);
    setState(() => _loading = true);
    super.initState();
  }

  NavigationDecision navigationDelegate(request) {
    Map<String, String> params = parseRedirectParams(request.url);
    if (params.containsKey('error')) {
      print('errored');
      Navigator.pop(context);
      return NavigationDecision.prevent;
    } else if (params.containsKey(EventbritePlatformApi.kACCESS_TOKEN)) {
      print('contains token');
      _eventbritePlatform.connect(params[EventbritePlatformApi.kACCESS_TOKEN]);
      Navigator.popUntil(
        context,
        ModalRoute.withName(Navigator.defaultRouteName),
      );
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('EventbriteAuthPage:Build');
    // TODO: Add UI For Back/Forward navigation (there's example in webview_flutter repo)
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Eventbrite'),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            WebView(
              userAgent: getUserAgent(),
              initialUrl: EventbritePlatformApi.authURI,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (_) => setState(() => _loading = false),
              navigationDelegate: navigationDelegate,
            ),
            Visibility(
              visible: _loading,
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
