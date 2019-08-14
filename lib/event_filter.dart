class EventFilter {
  RegExp _foodWordMatcher;
  static const List<String> _foodWordList = [
    "pizza",
    "pizzas",
    "snack",
    "snacks",
    "taco",
    "tacos",
    "hotdog",
    "hotdogs",
    "hot dog",
    "hot dogs",
    "meal",
    "food",
    "taste",
    "tasting"
  ];

  RegExp _drinkWordMatcher;
  static const List<String> _drinkWordList = [
    "beer",
    "beers",
    "drink",
    "drinks",
    "wine",
    "wines",
  ];

  EventFilter() {
    _foodWordMatcher = _createMatcher(_foodWordList);
    _drinkWordMatcher = _createMatcher(_drinkWordList);
  }

  static RegExp _createMatcher(List<String> wordList) =>
      new RegExp('(${wordList.join('|')})');

  List<EventFilterMatch> _applyMatcher(
    RegExp matcher,
    EventFilterMatchType type,
    String qualifier,
  ) {
    return matcher
        .allMatches(qualifier)
        .map((match) => EventFilterMatch(type, match.start, match.end))
        .toList();
  }

  List<EventFilterMatch> checkMatces(String test) => [
        ..._applyMatcher(_drinkWordMatcher, EventFilterMatchType.Drink, test),
        ..._applyMatcher(_foodWordMatcher, EventFilterMatchType.Food, test),
      ];
}

enum EventFilterMatchType { Food, Drink }

const Map<EventFilterMatchType, String> EventFilterMatchTypeEmojis = {
  EventFilterMatchType.Food: '🍕',
  EventFilterMatchType.Drink: '🍺',
};

class EventFilterMatch {
  int start, end;
  EventFilterMatchType type;
  EventFilterMatch(this.type, this.start, this.end);
}
