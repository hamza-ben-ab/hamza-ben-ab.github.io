import 'package:flutter/cupertino.dart';

class HomePartIndexProvider with ChangeNotifier {
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
