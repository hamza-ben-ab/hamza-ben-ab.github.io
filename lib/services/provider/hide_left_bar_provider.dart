import 'package:flutter/foundation.dart';

class HideLeftBarProvider with ChangeNotifier {
  bool show = true;

  void closeleftBar() {
    show = false;
    notifyListeners();
  }

  void openLeftBar() {
    show = true;
    notifyListeners();
  }
}
