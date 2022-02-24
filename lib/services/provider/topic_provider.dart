import 'package:flutter/material.dart';

class TopicProvider with ChangeNotifier {
  String topic;
  List<String> interest = [];
  int index = 0;

  void changeTopic(String newTopic) {
    topic = newTopic;
    notifyListeners();
  }

  void goTo(int next) {
    index = next;
    notifyListeners();
  }

  void backTo(int back) {
    index = back;
    notifyListeners();
  }

  void addInterest(String title) {
    interest.add(title);
    notifyListeners();
  }

  void removeInterest(String title) {
    interest.remove(title);
    notifyListeners();
  }
}
