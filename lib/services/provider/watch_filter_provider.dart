import 'package:flutter/material.dart';

class WatchFilterProvider with ChangeNotifier {
  List<String> filterString = [];

  void updateFilterString(String newString) {
    filterString.insert(0, newString);
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
