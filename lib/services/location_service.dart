import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class LocationService extends ChangeNotifier {
  final String _cityApi =
      "http://gd.geobytes.com/AutoCompleteCity?callback=?&q=";
  Position _position;
  List<String> _suggestedCites = List<String>();

//  LocationService();

  void generateSuggestedCites(String keyword) async {
    if (keyword.length < 3) {
      clean();
      return;
    }
    http.Response response = await http.get(_cityApi + keyword.toLowerCase());
    if (response.statusCode == 200) {
      print(response.headers);
      print(response.body);
      String trimmedString = response.body
          .substring(2)
          .replaceAll(")", "")
          .replaceAll(";", "")
          .replaceAll(", ", " "); // Fuck this weird body format
      print(trimmedString);

      try {
        _suggestedCites = List<String>.from(jsonDecode(trimmedString));
        notifyListeners();
      } catch (e) {
        print(e.toString());
      }
    } else {}
  }

  List<String> get suggestedCites => _suggestedCites;

  clean() {
    _suggestedCites = [];
    notifyListeners();
  }

  Future<bool> setCityPosition(String city) async {
    bool success = true;
    try {
      List<Placemark> places = await Geolocator().placemarkFromAddress(city);
      places.forEach((p) => print(p.position.toString()));
      this._position = places.first.position;
      notifyListeners();
      return success;
    } on PlatformException catch (e) {
      print(e);
      return !success;
    }
  }

  Position get position => _position;
}
