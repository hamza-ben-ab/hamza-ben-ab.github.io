import 'package:flutter/material.dart';
import 'package:uy/services/responsiveLayout.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class LoginPageIntro extends StatefulWidget {
  const LoginPageIntro({Key key}) : super(key: key);

  @override
  _LoginPageIntroState createState() => _LoginPageIntroState();
}

class _LoginPageIntroState extends State<LoginPageIntro> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return largeScreen
        ? Container(
            width: w * .6,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: w * .6,
                  child: Center(
                    child: Image.asset(
                      "./assets/images/news5.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: h * .1,
                ),
                /* largeScreen
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: !largeScreen ? w * .43 : w * .4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              googlePlayDownload(),
                              SizedBox(
                                width: 10.0,
                              ),
                              appStoreDownload()
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      )*/
              ],
            ),
          )
        : Container(
            height: 0.0,
            width: w * .1,
          );
  }
/*
  Widget googlePlayDownload() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        html.window.open('https://', "_blank");
      },
      child: Container(
        height: h * .07,
        width: !largeScreen ? w * .2 : w * .17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[00],
          border: Border.all(color: Colors.grey[400]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: h * .05,
              width: h * .05,
              child: Center(
                child: Image.asset("./assets/images/playstore.png"),
              ),
            ),
            Container(
              height: h * .07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get it on",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "SPProtext"),
                  ),
                  Text(
                    "Google Play",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SPProtext"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appStoreDownload() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        html.window.open('https://', "_blank");
      },
      child: Container(
        height: h * .07,
        width: !largeScreen ? w * .2 : w * .17,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[400])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: h * .05,
              width: h * .05,
              child: Center(
                child: Image.asset("./assets/images/apple.png"),
              ),
            ),
            Container(
              height: h * .07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Download on the",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "SPProtext"),
                  ),
                  Text(
                    "App Store",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SPProtext"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
*/

}
