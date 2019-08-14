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

  bool checkFood(String qualifier) {
    List<RegExpMatch> matches = _foodWordMatcher.allMatches(qualifier).toList();
    matches.forEach((match) => print(
        'match: ${match.input.substring(match.start, match.end)} ${match.start}-${match.end}'));
    return matches.length > 0;
  }
}
