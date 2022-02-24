import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/search/hover.dart';

class PostFunctions {
  Widget readButton(bool hover, double h, double w, String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: h * .04,
        width: w * .08,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontFamily: "SPProtext",
              ),
            ),
            SizedBox(
              width: 7.0,
            ),
            SvgPicture.asset(
              "./assets/icons/book.svg",
              color: Colors.white,
              height: 20.0,
              width: 20.0,
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: hover ? buttonColorHover : buttonColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ).xShowPointerOnHover,
    );
  }

  Widget readButtonWidget(double h, double w, String title) {
    return HoverWidget(
      child: readButton(false, h, w, title),
      hoverChild: readButton(true, h, w, title),
      onHover: (onHover) {},
    );
  }

  Widget watchButton(bool hover, double h, double w, String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: h * .04,
        width: w * .08,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 12.0, fontFamily: "SPProtext"),
            ),
            SizedBox(
              width: 7.0,
            ),
            SvgPicture.asset(
              "./assets/icons/streaming.svg",
              color: Colors.white,
              height: 20.0,
              width: 20.0,
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: hover ? buttonColorHover : buttonColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ).xShowPointerOnHover,
    );
  }

  Widget watchButtonWidget(double h, double w, String title) {
    return HoverWidget(
      child: watchButton(false, h, w, title),
      hoverChild: watchButton(true, h, w, title),
      onHover: (onHover) {},
    );
  }
}
