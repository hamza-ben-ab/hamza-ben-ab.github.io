import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget pubLoading(double h, double w) {
  return Container(
    height: h * .2,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  height: h * .05,
                  width: h * .05,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                  height: h * .06,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[200],
                              highlightColor: Colors.grey[300],
                              child: Container(
                                height: h * .015,
                                width: w * .07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          ),
                          Row(children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200],
                              highlightColor: Colors.grey[300],
                              child: Container(
                                height: h * .015,
                                width: w * .1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200],
                              highlightColor: Colors.grey[300],
                              child: Container(
                                height: h * .015,
                                width: w * .12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          ])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
