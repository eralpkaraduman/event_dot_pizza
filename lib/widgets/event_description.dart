import '../dictionary_matcher.dart';
import 'package:flutter/material.dart';

const _matchTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  decoration: TextDecoration.underline,
);
const _commonTextStyle = TextStyle(fontSize: 18.0);

class EventDescription extends StatelessWidget {
  final String description;
  final List<EventFilterMatch> _matches;
  EventDescription(this.description, this._matches) {
    this._matches.sort((a, b) => a.start.compareTo(b.start));
  }

  @override
  Widget build(BuildContext context) {
    int segmentStartIndex = 0;
    List<TextSpan> segments = [];
    EventFilterMatch currentMatch;
    int previousSegmentEndIndex;
    for (int i = 0; i < _matches.length; i++) {
      currentMatch = _matches[i];
      previousSegmentEndIndex = i == 0 ? 0 : _matches[i - 1].end;
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
