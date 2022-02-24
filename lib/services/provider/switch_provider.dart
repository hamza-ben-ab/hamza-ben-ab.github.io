import 'package:flutter/foundation.dart';

class SwitchProvider with ChangeNotifier {
  int listLength = 0;

  Future getlistLength(int l) async {
    listLength = l;
    notifyListeners();
  }
}
