import '../dictionary_matcher.dart';
import 'package:flutter/material.dart';

const _matchTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  decoration: TextDecoration.underline,
);
const _commonTextStyle = TextStyle(fontSize: 18.0);

class EventDescription extends StatelessWidget {
  EventDescription({
    Key key,
    @required this.description,
    @required this.matches,
    String desciption,
  }) : super(key: key);

  final String description;
  final List<EventFilterMatch> matches;

  @override
  Widget build(BuildContext context) {
    this.matches.sort((a, b) => a.start.compareTo(b.start));
    int segmentStartIndex = 0;
    List<TextSpan> segments = [];
    EventFilterMatch currentMatch;
    int previousSegmentEndIndex;
    for (int i = 0; i < matches.length; i++) {
      currentMatch = matches[i];
      previousSegmentEndIndex = i == 0 ? 0 : matches[i - 1].end;
      // Add the text before the match in normal style
      if (currentMatch.start > previousSegmentEndIndex) {
        segments.add(TextSpan(
          text: description.substring(
            previousSegmentEndIndex,
            currentMatch.start,
          ),
        ));
      }
      // Add the found match in special style
      segments.add(TextSpan(
        text: description.substring(currentMatch.start, currentMatch.end),
        style: _matchTextStyle,
      ));
      // Add the emoji for match type
      segments.add(TextSpan(
        text: EventFilterMatchTypeEmojis[currentMatch.type],
      ));
    }
    segments.add(TextSpan(
      text: description.substring(segmentStartIndex, description.length - 1),
    ));
    return Text.rich(
      TextSpan(
        children: segments,
      ),
      style: _commonTextStyle,
      textAlign: TextAlign.start,
    );
  }
}
