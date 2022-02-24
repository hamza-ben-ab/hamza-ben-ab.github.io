import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget skillsLoading(double h, double w) {
  return Container(
      height: h * .1,
      width: w * .45,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: Container(
              height: h * .06,
              width: h * .06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[300],
                child: Container(
                  height: h * .015,
                  width: w * .27,
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
                  width: w * .4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ],
      ));
}
