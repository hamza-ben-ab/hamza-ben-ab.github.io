import 'package:flutter/cupertino.dart';

class SearchDetailsProvider with ChangeNotifier {
  String searchTyping;
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void changeSearch(String newString) {
    searchTyping = newString;
    notifyListeners();
  }
}
