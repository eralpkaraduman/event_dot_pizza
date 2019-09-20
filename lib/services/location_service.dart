import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class LocationService extends ChangeNotifier {
  final String _cityApi =
      "http://gd.geobytes.com/AutoCompleteCity?callback=?&q=";
  Position position;

  LocationService({this.position});

  Future<List<dynamic>> getSuggestedCites(String keyword) async {
    var emptyCityList = List<String>();

    if (keyword.length < 3) {
      return emptyCityList;
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
        List<dynamic> decodedResponse = jsonDecode(trimmedString);
        return decodedResponse;
      } catch (e) {
        print(e.toString());
        return emptyCityList;
      }
    } else {
      return emptyCityList;
    }
  }

  Future<bool> getCityPosition(String city) async {
    bool success = true;
    try {
      List<Placemark> places = await Geolocator().placemarkFromAddress(city);
      places.forEach((p) => print(p.position.toString()));
      this.position = places.first.position;
      return success;
    } on PlatformException catch (e) {
      print(e);
      return !success;
    }
  }
}
