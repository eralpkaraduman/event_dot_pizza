import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/eventbrite_platform_session.dart';
import '../platforms/eventbrite_platform_api.dart';
import 'package:url_launcher/url_launcher.dart';

class EventbriteAuthPage extends StatefulWidget {
  static const routeName = "eventbriteAuth";
  @override
  _EventbriteAuthPage createState() => _EventbriteAuthPage();
}

class _EventbriteAuthPage extends State<EventbriteAuthPage>
    with WidgetsBindingObserver {
  bool _pending = false;
  bool _failed = false;
  StreamSubscription _callbackStream;
  EventbritePlatformSession _eventbritePlatform;

  @override
  void initState() {
    print('EventbriteAuthPage:InitState');
    _eventbritePlatform = Provider.of<EventbritePlatformSession>(
      context,
      listen: false,
    );
    _callbackStream = getLinksStream().listen((String url) {
      setState(() => _pending = false);
      _handleUrlCallback(url);
    }, onError: (err) {
      print("EventBrite:Auth:Failed:$err");
      setState(() {
        _pending = false;
        _failed = true;
      });
    });
    _launchAuthURL();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    print('EventbriteAuthPage:Build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Eventbrite'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: _failed,
                child: Text("Authorization Failed."),
              ),
              Visibility(
                visible: _failed,
                child: RaisedButton(
                  child: Text("Try Again"),
                  onPressed: _launchAuthURL,
                ),
              ),
              Visibility(
                visible: _pending,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchAuthURL() async {
    setState(() {
      _pending = true;
      _failed = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    print(EventbritePlatformApi.authURI);
    if (await canLaunch(EventbritePlatformApi.authURI)) {
      await launch(
        EventbritePlatformApi.authURI,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not launch ${EventbritePlatformApi.authURI}';
    }
  }

  void _handleUrlCallback(String url) {
    print('Handle Auth Callback Url: $url');
    Map<String, String> params = _parseRedirectParams(url);
    if (params.containsKey('error')) {
      this.setState(() => _failed = true);
    } else if (params.containsKey(EventbritePlatformApi.kACCESS_TOKEN)) {
      _eventbritePlatform.connect(params[EventbritePlatformApi.kACCESS_TOKEN]);
      Navigator.popUntil(
        context,
        ModalRoute.withName(Navigator.defaultRouteName),
      );
    } else {
      this.setState(() => _failed = true);
    }
  }

  Map<String, String> _parseRedirectParams(String url) {
    Map<String, String> paramsMap = Map();
    if (url.startsWith(EventbritePlatformApi.CALLBACK_URI)) {
      String query = url.split('#').last;
      List<String> params = query.split('&');
      for (String params in params) {
        List<String> pair = params.split('=');
        paramsMap[pair.first] = pair.last;
      }
    }
    return paramsMap;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Future.delayed(const Duration(seconds: 2), () {
      if (state == AppLifecycleState.resumed && _pending) {
        this.setState(() {
          _pending = false;
          _failed = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _callbackStream.cancel();
    super.dispose();
  }
}
