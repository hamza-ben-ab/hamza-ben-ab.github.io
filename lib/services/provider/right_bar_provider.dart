import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RightBarProvider with ChangeNotifier {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  int currentIndex = 0;
  int cardIndex = 1000000000000;
  int length = 0;

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void changeCardIndex(int index) {
    cardIndex = index;
    notifyListeners();
  }

  void refresh() {
    length = 0;
    notifyListeners();
  }
}
