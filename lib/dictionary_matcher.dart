List<EventFilterMatch> getMatces(String test) => [
      ..._applyMatcher(
        _drinkWordMatcher,
        EventFilterMatchType.Drink,
        test,
      ),
      ..._applyMatcher(
        _foodWordMatcher,
        EventFilterMatchType.Food,
        test,
      ),
      ..._applyMatcher(
        _foodOccuranceMatcher,
        EventFilterMatchType.Food,
        test,
      ),
      ..._applyMatcher(
        _drinkOccuranceMatcher,
        EventFilterMatchType.Drink,
        test,
      ),
    ];

const List<String> _foodWordList = [
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
  "burgers",
  // FR
  "aliments",
  "aliment",
  "boisson",
  "boissons",
  "rafraîchissement",
  "rafraîchissements",
];

const _foodOccurances = ["🍔", "🍕", "🌭", "🌮"];

const List<String> _drinkWordList = [
  "beer",
  "beers",
  "drink",
  "drinks",
  "wine",
  "wines",
  "refreshment",
  "refreshments"
];

const _drinkOccurances = ["🍺", "🍻", "🍷", "🍾", "🍸", "☕️"];

RegExp _createWordMatcher(List<String> wordList) => new RegExp(
      '\\b(${wordList.join('|')})\\b',
      caseSensitive: false,
      multiLine: true,
    );

RegExp _createOccuranceMatcher(List<String> wordList) => new RegExp(
      '(${wordList.join('|')})',
      caseSensitive: false,
      multiLine: true,
    );

RegExp _foodWordMatcher = _createWordMatcher(_foodWordList);
RegExp _drinkWordMatcher = _createWordMatcher(_drinkWordList);
RegExp _foodOccuranceMatcher = _createOccuranceMatcher(_foodOccurances);
RegExp _drinkOccuranceMatcher = _createOccuranceMatcher(_drinkOccurances);

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
