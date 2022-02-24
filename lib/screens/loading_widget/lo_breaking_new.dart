import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget breakingNewsLoadingWidget(double h, double w) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    width: w * .45,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0), color: Colors.white),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: w * .41,
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
                                width: w * .35,
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
        SizedBox(
          height: h * .02,
        ),
        Container(
          height: h * .05,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  height: h * .015,
                  width: w * .04,
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
                  width: w * .04,
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
                  width: w * .04,
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
                  width: w * .04,
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
                  width: w * .04,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: h * .0325,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    height: h * .06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[200],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        height: h * .015,
                        width: w * .06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        SizedBox(
          height: h * .02,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  height: h * .015,
                  width: w * .2,
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
                  width: w * .2,
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
                  width: w * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
        Container(
          width: w * .45,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  height: h * .03,
                  width: w * .3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  height: h * .47,
                  width: w * .41,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                height: h * .03,
              ),
              Container(
                height: h * .04,
                width: w * .41,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                ),
              ),
              SizedBox(
                height: h * .02,
              )
            ],
          ),
        )
      ],
    ),
  );
}
