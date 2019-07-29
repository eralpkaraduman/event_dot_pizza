class Event {
  String name;
  String link;

  Event({this.name, this.link});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(name: json['name'] as String, link: json['link'] as String);
  }
}
