import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget pubSearchLoading(double h, double w) {
  return Container(
    height: h * .35,
    width: w * .4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white,
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    margin: EdgeInsets.symmetric(vertical: 5.0),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: w * .4,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
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
                                width: w * .25,
                                child: Row(children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[200],
                                    highlightColor: Colors.grey[300],
                                    child: Container(
                                      height: h * .015,
                                      width: w * .1,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
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
                                        borderRadius:
                                            BorderRadius.circular(12.0),
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
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            width: w * .4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[50]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    height: h * .2,
                    width: w * .15,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
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
                    height: h * .2,
                    width: w * .2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: h * .05,
              width: w * .2,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: h * .015,
                      width: w * .03,
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
                      height: h * .015,
                      width: w * .03,
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
                      height: h * .015,
                      width: w * .03,
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
                      height: h * .015,
                      width: w * .03,
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
                      height: h * .015,
                      width: w * .03,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[300],
              child: Container(
                height: h * .04,
                width: w * .07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[300],
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
