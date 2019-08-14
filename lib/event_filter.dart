class EventFilter {
  RegExp _foodWordMatcher;
  static const List<String> _foodWordList = [
    "pizza",
    "pizzas",
    "snack",
    "snacks",
    "tacos",
    "taco",
    "hotdog",
    "hotdogs",
    "hot dog",
    "hot dogs",
    "meal",
    "meals",
    "food",
    "taste",
    "tasting",
    "burger",
    "burgers"
  ];

  RegExp _drinkWordMatcher;
  static const List<String> _drinkWordList = [
    "beer",
    "beers",
    "drink",
    "drinks",
    "wine",
    "wines",
    "refreshment",
    "refreshments",
  ];

  EventFilter() {
    _foodWordMatcher = _createMatcher(_foodWordList);
    _drinkWordMatcher = _createMatcher(_drinkWordList);
  }

  static RegExp _createMatcher(List<String> wordList) =>
      new RegExp('\\b(${wordList.join('|')})\\b');

  List<EventFilterMatch> _applyMatcher(
    RegExp matcher,
    EventFilterMatchType type,
    String qualifier,
  ) {
    return matcher
        .allMatches(qualifier.toLowerCase())
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
