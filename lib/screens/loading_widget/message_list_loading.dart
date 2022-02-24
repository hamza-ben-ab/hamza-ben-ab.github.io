import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget messageListLoading(double h, double w) {
  return Container(
    height: h * .7,
    width: w * .4,
    child: ListView.builder(
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return Align(
          alignment: index.isOdd ? Alignment.centerLeft : Alignment.centerRight,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              width: w * .25,
              height: index == 0
                  ? h * .08
                  : index == 1
                      ? h * .07
                      : index == 2
                          ? h * .12
                          : index == 3
                              ? h * .12
                              : h * .05,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: index.isOdd
                    ? BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
