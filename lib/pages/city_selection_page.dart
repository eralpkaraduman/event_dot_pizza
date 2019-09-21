import 'package:flutter/material.dart';
import 'package:event_dot_pizza/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:event_dot_pizza/widgets/city_tile.dart';
import 'package:event_dot_pizza/pages/events_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      _service = Provider.of<LocationService>(this.context);
      _service.cleanCities();
      _service.cleanLocation(); // reset location
    });
    super.initState();
  }

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
          _service.cleanCities();
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
        child: ModalProgressHUD(
          inAsyncCall: _service.isBusy,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      height: 50,
                      child: Visibility(
                        visible: _chosenCity != ""
                            ? true
                            : false, //TODO: refactor this shit
                        child: Center(
                            child: FlatButton(
                                onPressed: () async {
                                  bool success = await _service
                                      .setCityPosition(_textController.text);
                                  if (success) {
                                    Navigator.of(context)
                                        .pushNamed(EventsPage.routeName);
                                  } else {
                                    //TODO: show the error message properly somewhere else in another widget
                                    _textController.text =
                                        "Invalid city name, retry";
                                    _chosenCity = "";
                                    _service.cleanCities();
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
