import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget menuPartOneLoading(double h, double w) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    width: w * .22,
    height: h * .095,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          child: Container(
            margin: EdgeInsets.only(left: 5.0),
            height: h * .08,
            width: h * .08,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    height: h * .015,
                    width: w * .07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(
                  height: h * .01,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    height: h * .015,
                    width: w * .085,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey[300],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
