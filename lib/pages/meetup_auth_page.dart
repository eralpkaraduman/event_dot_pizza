import 'package:event_dot_pizza/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meetup_platform_session.dart';
import '../platforms/meetup_platform_api.dart';

import 'dart:async';
import 'package:uni_links/uni_links.dart';

import 'package:url_launcher/url_launcher.dart';
import '../utils.dart';

class MeetupAuthPage extends StatefulWidget {
  static const routeName = "meetupAuth";
  @override
  _MeetupAuthPage createState() => _MeetupAuthPage();
}

class _MeetupAuthPage extends State<MeetupAuthPage>
    with WidgetsBindingObserver {
  bool _pending = false;
  bool _failed = false;
  StreamSubscription _callbackStream;
  MeetupPlatformSession _meetupPlatform;

  @override
  void initState() {
    print('MeetupAuthPage:InitState');
    _meetupPlatform = Provider.of<MeetupPlatformSession>(
      context,
      listen: false,
    );
    _callbackStream = getLinksStream().listen((String url) {
      setState(() => _pending = false);
      _handleUrlCallback(url);
    }, onError: (err) {
      print("Meetup:Auth:Failed:$err");
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
    print('MeetupAuthPage:Build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Meetup'),
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
    print(MeetupPlatformApi.authURI);
    if (await canLaunch(MeetupPlatformApi.authURI)) {
      await launch(
        MeetupPlatformApi.authURI,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not launch ${MeetupPlatformApi.authURI}';
    }
  }

  void _handleUrlCallback(String url) {
    print('Handle Auth Callback Url: $url');
    Map<String, String> params;
    if (url.startsWith(MeetupPlatformApi.CALLBACK_URI)) {
      params = parseRedirectParams(url);
    }
    if (params != null && params.containsKey('error')) {
      this.setState(() => _failed = true);
    } else if (params.containsKey(MeetupPlatformApi.kACCESS_TOKEN)) {
      _meetupPlatform.connect(params[MeetupPlatformApi.kACCESS_TOKEN]);
      Navigator.pop(context);
    } else {
      this.setState(() => _failed = true);
    }
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
