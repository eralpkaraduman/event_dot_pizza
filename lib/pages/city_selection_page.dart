import 'package:flutter/material.dart';
import 'package:event_dot_pizza/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:event_dot_pizza/widgets/city_tile.dart';
import 'package:event_dot_pizza/pages/events_page.dart';

class CitySelectionPage extends StatefulWidget {
  static const routeName = "citySelection";

  @override
  State<StatefulWidget> createState() {
    return CitySelectionState();
  }
}

class CitySelectionState extends State<CitySelectionPage> {
  final TextEditingController _textController = TextEditingController();
  LocationService _service;
  String _chosenCity = "";

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  List<Widget> _cityTiles(List<String> cities) {
    List<Widget> cityTiles = [];
    cities.forEach((city) {
      cityTiles.add(CityTile(
        city: city,
        onTap: () {
          _textController.text = city;
          _chosenCity = city;
          _service.clean();
        },
      ));
    });
    return cityTiles;
  }

  @override
  Widget build(BuildContext context) {
    print('CitySelectionPage:Updated');
    _service = Provider.of<LocationService>(this.context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select City'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _textController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "Where are you, Chief?",
                      hintStyle: TextStyle(color: Colors.grey)),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  onChanged: (change) {
                    _service.generateSuggestedCites(change);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  child: ListView(
                    children: _cityTiles(_service.suggestedCites),
                  ),
                ),
                Container(
                  height: 50,
                  child: Visibility(
                    visible: _chosenCity != "" ? true : false,
                    child: Center(
                        child: FlatButton(
                            onPressed: () async {
                              bool success =
                                  await _service.setCityPosition(_chosenCity);
                              if (success) {
                                Navigator.of(context)
                                    .pushNamed(EventsPage.routeName);
                              } else {
                                _textController.text =
                                    "Invalid city name, retry";
                              }
                            },
                            child: Text(
                              "Onward!",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                            ))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
