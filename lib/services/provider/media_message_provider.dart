import 'package:flutter/foundation.dart';

class MediaMessageProvider with ChangeNotifier {
  int index = 0;

  void changeIndexImage(int currentindex) {
    index = currentindex;
    notifyListeners();
  }
}
