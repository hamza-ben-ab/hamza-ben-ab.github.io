import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget contactLoading(double h, double w) {
  return Row(
    children: [
      Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[300],
        child: Container(
          height: h * .04,
          width: h * .04,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      SizedBox(
        width: 10.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[300],
        child: Container(
          height: h * .04,
          width: h * .04,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      SizedBox(
        width: 10.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[300],
        child: Container(
          height: h * .04,
          width: h * .04,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      SizedBox(
        width: 10.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[300],
        child: Container(
          height: h * .04,
          width: h * .04,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    ],
  );
}
