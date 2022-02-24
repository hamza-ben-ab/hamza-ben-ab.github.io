import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget userLoading(double h, double w, double x) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: w * x,
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
                borderRadius: BorderRadius.circular(12.0),
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
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: w * .35,
                          child: Row(children: [
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
                            SizedBox(width: 10.0),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200],
                              highlightColor: Colors.grey[300],
                              child: Container(
                                height: h * .015,
                                width: w * .12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          ])),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget userBreakingNewsLoading(double h, double w) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: w * .22,
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
                borderRadius: BorderRadius.circular(12.0),
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
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: w * .1,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[300],
                          child: Container(
                            height: h * .015,
                            width: w * .12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
