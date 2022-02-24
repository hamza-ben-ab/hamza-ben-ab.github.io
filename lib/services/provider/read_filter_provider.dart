import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  List<String> filterString = [];

  void updateFilterString(String newString) {
    filterString.add(newString);
    notifyListeners();
  }

  void removeFilterString(String newString) {
    filterString.remove(newString);
    notifyListeners();
  }

  void emptyFilterString() {
    filterString.clear();
    notifyListeners();
  }
}

class FilterProviderChangeState with ChangeNotifier {
  bool activeFilter = false;

  void activeAndinactiveFilter() {
    activeFilter = !activeFilter;
    notifyListeners();
  }

  void inactive() {
    activeFilter = false;
    notifyListeners();
  }
}
