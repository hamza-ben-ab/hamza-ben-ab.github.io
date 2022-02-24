import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MessageProvider with ChangeNotifier {
  String userId;
  bool isBlock = false;
  String blockedBy;
  String userName;

  void changeMessageId(String newUserId) {
    userId = newUserId;
    notifyListeners();
  }

  Future<void> checkBlock() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    User currentUser = FirebaseAuth.instance.currentUser;
    var document =
        await users.doc(currentUser.uid).collection("Block").doc(userId).get();

    if (document.exists) {
      isBlock = true;
      DocumentSnapshot user = await users.doc(userId).get();
      userName = user.data()["full_name"];
      notifyListeners();
    } else {
      isBlock = false;
      notifyListeners();
    }
  }

  Future<void> checkBlockUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    User currentUser = FirebaseAuth.instance.currentUser;
    var document =
        await users.doc(currentUser.uid).collection("Block").doc(userId).get();

    if (document.exists) {
      blockedBy = document.data()["blockedBy"];
      DocumentSnapshot user = await users.doc(userId).get();
      userName = user.data()["full_name"];
      notifyListeners();
    }
  }

  void blockConfirm() {
    isBlock = true;
    notifyListeners();
  }

  void cancelBlock() {
    isBlock = false;
    notifyListeners();
  }
}
