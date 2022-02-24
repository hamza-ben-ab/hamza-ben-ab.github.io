import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget notificationLoading(double h, double w) {
  return Stack(
    children: [
      Container(
        width: w * .22,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            Container(
              width: w * .05,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: w * .25,
                    height: h * .13,
                    child: Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[200],
                        highlightColor: Colors.grey[300],
                        child: Container(
                          height: h * .075,
                          width: h * .075,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
                child: Column(
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
                          color: Colors.grey[200],
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
                        width: w * .07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.grey[200],
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
                        height: h * .08,
                        width: w * .2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}
