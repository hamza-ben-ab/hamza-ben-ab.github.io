import 'package:flutter/material.dart';

class AlertWidgets {
  Widget errorWidget(double h, double w, String title) {
    return Container(
      width: w * .45,
      height: h * .93,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: h * .12,
            width: h * .12,
            child: Image.asset("./assets/images/exclamation-mark.png"),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
        ],
      ),
    );
  }

  Widget emptyWidget(double h, double w, String title) {
    return Container(
      width: w * .45,
      height: h * .93,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: h * .12,
            width: h * .12,
            child: Image.asset("./assets/images/exclamation-mark.png"),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
        ],
      ),
    );
  }

  Widget emptyLiveWidget(double h, double w, String title) {
    return Container(
      width: w * .45,
      height: h * .93,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: h * .12,
            width: h * .12,
            child: Image.asset("./assets/images/live-streaming.png"),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
        ],
      ),
    );
  }

  Widget emptyBreakingNews(double h, double w, String firstTitle, String des) {
    return Container(
      height: h * .93,
      width: w * .24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            firstTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
          SizedBox(
            height: h * .02,
          ),
          Text(
            des,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.0,
                fontFamily: "SPProtext"),
          ),
        ],
      ),
    );
  }
}
