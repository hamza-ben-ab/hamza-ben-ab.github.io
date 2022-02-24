import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CenterBoxProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String docId = "";
  int currentIndex = 0;

  String get count => docId;
  int get getIndex => currentIndex;

  void changeCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
    //currentIndex = 0;
  }

  void changeDocId(String newDocId) {
    docId = newDocId;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('docId', docId));
  }
}
