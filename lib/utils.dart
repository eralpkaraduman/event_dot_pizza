import 'dart:io' show Platform;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

bool isNullOrEmpty(Object o) => o == null || "" == o;

String parseHtmlText(String htmlText) {
  try {
    Document dom = parse(htmlText);
    return dom.documentElement.text;
  } catch (e) {
    print('Failed to parse html: $e');
    return htmlText;
  }
}

String getUserAgent() {
  if (Platform.isIOS) {
    return 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1';
  }
  if (Platform.isAndroid) {
    return 'Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36';
  }
  throw 'User agent is not determined for the current platform';
}
