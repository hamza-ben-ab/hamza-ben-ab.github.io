import 'package:flutter/foundation.dart';

class SettingProvider with ChangeNotifier {
  int page = 0;

  void goToPage(int index) {
    page = index;
    notifyListeners();
  }
}
