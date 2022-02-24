import 'package:flutter/cupertino.dart';

class SearchFieldProvider with ChangeNotifier {
  String searchTypingField;

  void changeSearchField(String newString) {
    searchTypingField = newString;
    notifyListeners();
  }
}
