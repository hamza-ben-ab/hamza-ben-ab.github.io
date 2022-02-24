import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  String userId;

  void changeProfileId(String newUser) {
    userId = newUser;
    notifyListeners();
  }
}
