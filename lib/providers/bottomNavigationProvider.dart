import 'dart:ffi';

import 'package:flutter/material.dart';

/**
 * Provider in charge of controlling the navigation of the bottom navigation bar, allows automatic re-directs
 */
class BottomNavigationProvider with ChangeNotifier {
  int _currentIndex = 0;
  /**
   * GETTERS
   */
  int get currentIndex => _currentIndex;
  /**
   * SETTERS
   */
  void set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }
}
