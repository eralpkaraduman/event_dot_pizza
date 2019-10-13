import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                child: Image(image: AssetImage('assets/images/intro.jpeg')),
                width: 200,
                height: 200,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'HOLD ON...',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
