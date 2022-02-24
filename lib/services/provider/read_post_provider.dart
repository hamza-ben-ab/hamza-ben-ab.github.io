import 'package:flutter/foundation.dart';

class ReadPostProvider with ChangeNotifier {
  String userId;
  String doc;

  void changePostId(String newUser, String newId) {
    userId = newUser;
    doc = newId;
    notifyListeners();
  }
}
