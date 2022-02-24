import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget verifyAccountLoading(double h, double w, bool largeScreen) {
  return Container(
    margin: EdgeInsets.all(5.0),
    width: largeScreen ? w * .12 : w * .4,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: h * 0.02,
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            height: h * .15,
            width: h * .15,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          child: Container(
            height: h * .015,
            width: largeScreen ? w * .07 : w * .27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey[300],
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          child: Container(
            height: h * .015,
            width: largeScreen ? w * .12 : w * .35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey[300],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            height: h * 0.04,
            width: largeScreen ? w * .1 : w * .3,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    ),
  );
}
