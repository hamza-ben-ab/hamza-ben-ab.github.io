import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget searchUserLoading(double h, double w) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
    width: w * .45,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: h * .08,
          width: h * .08,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              height: h * .07,
              width: h * .07,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: h * .06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: h * .02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: h * .04,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[300],
                          child: Container(
                            height: h * .015,
                            width: w * .1,
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
                            width: w * .15,
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
          ),
        ),
      ],
    ),
  );
}
