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
