import 'package:flutter/material.dart';

class StackNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> _routeStack = List();

  get routeStack => _routeStack;

  bool containsNamedRoute(String name) {
    return _routeStack.indexWhere((route) => route.settings.name == name) != -1;
  }

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    _routeStack.add(route);
  }

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    _routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    _routeStack.removeLast();
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    _routeStack.removeLast();
    _routeStack.add(newRoute);
  }
}
