import 'package:flutter/material.dart';

class SearchWidgets {
  Widget seeMoreWidget(bool hover, double h, double w, String title) {
    return Container(
      height: h * .08,
      width: w * .4,
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[300] : Colors.grey[200]),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            fontFamily: "SPProtext",
          ),
        ),
      ),
    );
  }
}
