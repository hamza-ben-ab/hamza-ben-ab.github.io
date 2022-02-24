import 'package:flutter/cupertino.dart';

class AttachementMessageProvider with ChangeNotifier {
  bool attachement = false;
  bool loading = false;

  void trueAtachement() {
    attachement = true;
    notifyListeners();
  }

  void falseAtachement() {
    attachement = false;
    notifyListeners();
  }
}
