import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loadingCommentPost(double h, double w) {
  return Center(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: w * .2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: w * .2,
              child: Row(
                children: [
                  //image
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
                              //written By
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
                              //Full_name & timeAgo
                              Container(
                                width: w * .1,
                                child: Row(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[200],
                                      highlightColor: Colors.grey[300],
                                      child: Container(
                                        height: h * .015,
                                        width: w * .03,
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
                                        width: w * .05,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ],
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
          ),
          Container(
            width: w * .2,
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    height: h * .05,
                    width: w * .15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
