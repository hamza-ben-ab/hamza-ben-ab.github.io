import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: h,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: w,
              height: h * .08,
              child: Center(
                child: Text(
                  "Telltrue",
                  style: TextStyle(
                    fontFamily: "MarckScript",
                    fontSize: 70.0,
                    letterSpacing: 3.0,
                    color: Color(0xFF446865),
                  ),
                ),
              ),
            ),
            Container(
              width: w,
              height: h * .03,
              child: Row(
                children: [
                  SizedBox(
                    width: w * .54,
                  ),
                  TypewriterAnimatedTextKit(
                    repeatForever: false,
                    text: ["Be Honest", "Be Professional"],
                    speed: Duration(milliseconds: 100),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "SPProtext",
                      color: Colors.black,
                    ),
                    stopPauseOnTap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
