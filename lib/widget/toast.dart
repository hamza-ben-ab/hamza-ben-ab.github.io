import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeltrueWidget {
  showToast(String message, FToast fToast, Color color) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: color),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "SPProtext",
            ),
          ),
        ));

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM_LEFT,
      toastDuration: Duration(seconds: 4),
    );
  }
}
