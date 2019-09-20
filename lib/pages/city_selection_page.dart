import 'package:flutter/material.dart';

class CitySelectionPage extends StatelessWidget {
  static const routeName = "citySelection";

  @override
  Widget build(BuildContext context) {
    print('CitySelectionPage:Updated');
    return Scaffold(
      appBar: AppBar(
        title: Text('Select City'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('lol city'),
            ],
          ),
        ),
      ),
    );
  }
}
