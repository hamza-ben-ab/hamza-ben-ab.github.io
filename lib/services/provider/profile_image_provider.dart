import 'package:flutter/cupertino.dart';

class ProfileImageProvider with ChangeNotifier {
  String imageUrl;

  void changeProfileImage(String newImage) {
    imageUrl = newImage;
    notifyListeners();
  }
}
