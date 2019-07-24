import 'package:event_dot_pizza/src/platforms/meetupPlatform.dart';
import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/app.dart';
import 'package:provider/provider.dart';

// void main() => runApp(App());
void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        builder: (_) => MeetupPlatform(),
      )
    ], child: App()));
