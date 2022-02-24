import 'package:flutter/cupertino.dart';

class TagPostProvider with ChangeNotifier {
  String tagPerson;
  String tagEvent;
  String tagPlace;
  String topic;
  String smile;
  String feel;

  void changeTagPerson(String person) {
    tagPerson = person;
    notifyListeners();
  }

  void changeTagEvent(String event) {
    tagEvent = event;
    notifyListeners();
  }

  void changeTagPlace(String place) {
    tagPlace = place;
    notifyListeners();
  }

  void changeTagTopic(String newTopic) {
    topic = newTopic;
    notifyListeners();
  }

  void changeTagFeeling(String newFeel, String newSmile) {
    smile = newSmile;
    feel = newFeel;
    notifyListeners();
  }
}
