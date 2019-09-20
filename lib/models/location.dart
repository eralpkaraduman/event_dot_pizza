class Location {
  final String city, country;
  final double lat, lon;

  Location({this.city, this.country, this.lat, this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      country: json['localized_country_name'],
      lat: json['lat'] as double,
      lon: json['lon'] as double,
    );
  }

  equalsTo(Location other) {
    if (other == null) {
      return false;
    }
    return lat == other.lat && lon == other.lon;
  }
}
