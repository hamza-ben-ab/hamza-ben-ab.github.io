import 'package:flutter/cupertino.dart';

class CreateLocationProvider with ChangeNotifier {
  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController homeTownLocation = TextEditingController();

  changeCurrentLocation(String newLocation) {
    currentLocationController.text = newLocation;
    notifyListeners();
  }

  changeHomeTownLocation(String newLocation) {
    homeTownLocation.text = newLocation;
    notifyListeners();
  }
}
