import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget profilefirstPartLoading(double h, double w) {
  return Container(
    height: h * .45,
    width: w * .63,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    ),
    margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 20.0),
    padding: EdgeInsets.all(10.0),
    child: Row(
      children: [
        Container(
          width: w * .25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: h * .01,
              ),
              Container(
                height: h * .22,
                width: h * .22,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    height: h * .2,
                    width: h * .2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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
              ),
              SizedBox(
                height: h * .02,
              ),
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
              SizedBox(
                height: h * .02,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  height: h * .015,
                  width: w * .14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: h * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: h * .04,
                      width: w * .15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * .02,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: h * .04,
                      width: w * .15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  height: h * .2,
                  width: w * .3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: h * .04,
                      width: w * .1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: h * .04,
                      width: w * .1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: h * .04,
                      width: w * .1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
