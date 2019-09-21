import 'package:flutter/material.dart';

class CityTile extends StatelessWidget {
  final String city;
  final Function onTap;

  CityTile({@required this.city, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            city,
            style: TextStyle(color: Colors.blueAccent, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
