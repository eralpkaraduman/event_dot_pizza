import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';
import '../platforms/eventbrite_platform_api.dart';
import '../platforms/meetup_platform_api.dart';
import '../utils.dart';

class Deeplink extends ChangeNotifier {
  StreamSubscription _subscription;
  String _lastUrl;
  String _launchUrl;
  String get url {
    if (_lastUrl == null) {
      return _launchUrl;
    }
    return _lastUrl;
  }

  Map<String, String> get params => parseRedirectParams(url);

  String get meetupAccessToken {
    if (url == null) return null;
    if (url.startsWith(MeetupPlatformApi.CALLBACK_URI)) {
      return params[MeetupPlatformApi.kACCESS_TOKEN];
    }
    return null;
  }

  String get eventbriteAccessToken {
    if (url == null) return null;
    if (url.startsWith(EventbritePlatformApi.CALLBACK_URI)) {
      return params[EventbritePlatformApi.kACCESS_TOKEN];
    }
    return null;
  }

  Deeplink() {
    print('Provider:Deeplink:Updated');
    _subscription = getLinksStream().listen((String url) {
      if (url != _lastUrl) {
        _lastUrl = url;
        notifyListeners();
      }
    }, onError: (err) {
      print("Provider:Deeplink:Failed:$err");
    });
    scheduleMicrotask(_setLaunchUrl);
  }

  _setLaunchUrl() async {
    String loadedInitialLink;
    try {
      loadedInitialLink = await getInitialLink();
    } catch (_) {
      print("Provider:Deeplink:SetLaunchUrl:Failed");
    }
    if (loadedInitialLink != null && loadedInitialLink != _launchUrl) {
      _launchUrl = loadedInitialLink;
      notifyListeners();
    }
  }

  clear() {
    _lastUrl = null;
    _launchUrl = null;
    notifyListeners();
  }

  @override
  dispose() {
    if (_subscription != null) _subscription.cancel();
    super.dispose();
  }
}
