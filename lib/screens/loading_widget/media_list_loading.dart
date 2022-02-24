import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget mediaListLoading(double h, double w) {
  return Container(
    width: w * .8,
    height: h * .1,
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            height: h * .1,
            width: w * .1,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        );
      },
    ),
  );
}
