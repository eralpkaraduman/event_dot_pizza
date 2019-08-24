import 'package:event_dot_pizza/utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/meetup_platform_session.dart';
import '../platforms/meetup_platform_api.dart';

class MeetupAuthPage extends StatefulWidget {
  static const routeName = "meetupAuth";
  @override
  _MeetupAuthPageState createState() => _MeetupAuthPageState();
}

class _MeetupAuthPageState extends State<MeetupAuthPage> {
  bool _loading = false;
  MeetupPlatformSession _meetupPlatform;
  WebViewController _webViewController;

  Map<String, String> parseRedirectParams(String url) {
    Map<String, String> paramsMap = Map();
    if (url.startsWith(MeetupPlatformApi.REDIRECT_URI)) {
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
    print('ConnectPlatformsPage:InitState');
    _meetupPlatform =
        Provider.of<MeetupPlatformSession>(context, listen: false);
    setState(() => _loading = true);
    super.initState();
  }

  NavigationDecision navigationDelegate(request) {
    Map<String, String> params = parseRedirectParams(request.url);
    if (params.containsKey('error')) {
      print('errored');
      Navigator.pop(context);
      return NavigationDecision.prevent;
    } else if (params.containsKey(MeetupPlatformApi.kACCESS_TOKEN)) {
      print('contains token');
      _meetupPlatform.connect(params[MeetupPlatformApi.kACCESS_TOKEN]);
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
    print('ConnectPlatformsPage:Build');
    // TODO: Add UI For Back/Forward navigation (there's example in webview_flutter repo)
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Meetup.Com'),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            WebView(
              userAgent: getUserAgent(),
              initialUrl: MeetupPlatformApi.authURI,
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
