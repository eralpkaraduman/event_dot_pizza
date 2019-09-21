import './event.dart';
import 'package:flutter/material.dart';

abstract class PlatformEvents {
  bool get refreshing;
  List<Event> get events;
  Future<void> refresh(BuildContext context);
}
