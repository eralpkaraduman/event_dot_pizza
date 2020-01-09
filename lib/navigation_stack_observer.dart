import 'package:flutter/material.dart';

class NavigationStackObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = List();
  Function() onChange;

  NavigationStackObserver({@required this.onChange});

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    routeStack.add(route);
    onChange();
  }

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    routeStack.removeLast();
    onChange();
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    routeStack.removeLast();
    onChange();
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute);
    onChange();
  }
}
