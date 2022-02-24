import 'package:flutter/cupertino.dart';

class ProfileCenterBarProvider with ChangeNotifier {
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
