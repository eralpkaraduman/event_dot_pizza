import 'package:flutter/material.dart';
import '../navigation_stack_observer.dart';

class NavigationStack extends ChangeNotifier {
  NavigationStackObserver _observer;
  get observer => _observer;

  get stack => _observer.routeStack;

  int _currentStackSize = 0;

  NavigationStack() {
    _observer = NavigationStackObserver(
      onChange: () {
        // Do not notify if stack was empty (there was no screen to listen changes from)
        if (_currentStackSize != 0) {
          _currentStackSize = _observer.routeStack.length;
          notifyListeners();
        }
      },
    );
  }

  bool containsNamedRoute(String name) {
    final index = _observer.routeStack.indexWhere(
      (route) => route.settings.name == name,
    );
    return index != -1;
  }
}
