import 'package:flutter/foundation.dart';

class SearchArticleProvider with ChangeNotifier {
  List<Map<String, dynamic>> paragraphList = [];

  void addPart(Map<String, dynamic> part) {
    paragraphList.add(part);
    notifyListeners();
  }

  void updateMediaUrl(int index) {
    paragraphList[index]["mediaUrl"] = null;
    notifyListeners();
  }

  void emptyList() {
    paragraphList = [];
    notifyListeners();
  }
}
