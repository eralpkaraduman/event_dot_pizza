import 'package:event_dot_pizza/event_filter.dart';
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
    for (EventFilterMatch match in _matches) {
      segments.add(TextSpan(
        text: description.substring(segmentStartIndex, match.start),
      ));
      segments.add(TextSpan(
        text: description.substring(match.start, match.end),
        style: _matchTextStyle,
      ));
      segments.add(TextSpan(
        text: EventFilterMatchTypeEmojis[match.type],
      ));
      segmentStartIndex = match.end;
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
