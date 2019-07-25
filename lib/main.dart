import 'package:event_dot_pizza/src/state/meetupPlatformSession.dart';
import 'package:flutter/material.dart';
import 'package:event_dot_pizza/src/app.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        builder: (_) => MeetupPlatformSession(),
      )
    ], child: App()));
