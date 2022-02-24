import 'package:flutter/foundation.dart';

class MessageListProvider with ChangeNotifier {
  int list = 0;

  void addMessageList(int newList) {
    list = newList;
    notifyListeners();
  }
}
