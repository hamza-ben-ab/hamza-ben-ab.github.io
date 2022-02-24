import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

Widget picturesloading(double h, double w) {
  return StaggeredGridView.countBuilder(
    primary: false,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 4,
    itemCount: 10,
    itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[300],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    staggeredTileBuilder: (int index) =>
        new StaggeredTile.count(1, index.isEven ? 1 : 1.5),
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
  );
}
