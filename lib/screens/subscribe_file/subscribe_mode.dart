import "package:flutter/material.dart";
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/services/responsiveLayout.dart';

class SubscribeMode extends StatefulWidget {
  const SubscribeMode({
    Key key,
  }) : super(key: key);
  @override
  _SubscribeModeState createState() => _SubscribeModeState();
}

class _SubscribeModeState extends State<SubscribeMode> {
  int currentIndex = 10;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: h,
          width: w,
          color: Colors.white,
          child: Column(
            children: [
              TeltrueAppBar(
                backRoute: "/LogIn",
                nextRouteTitle: S.of(context).nextButton,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: h * .6,
                    width: largeScreen ? w * .27 : w * .8,
                    decoration: centerBoxDecoration,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: h * 0.03,
                        ),
                        //Description
                        Container(
                          width: largeScreen ? w * 0.25 : w * .75,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).subtitleSignUpMode,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "SPProtext"),
                              ),
                              SizedBox(
                                height: h * 0.03,
                              ),
                              Text(
                                S.of(context).descriptionSignUpMode,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: "SPProtext"),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                        HoverWidget(
                          child: iAm(
                              false,
                              S.of(context).iamJournalistSignUpMode,
                              0,
                              "/JournalistKind"),
                          hoverChild: iAm(
                              true,
                              S.of(context).iamJournalistSignUpMode,
                              0,
                              "/JournalistKind"),
                          onHover: (onHover) {},
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        HoverWidget(
                          child: iAm(false, S.of(context).iamReaderSignUpMode,
                              1, "/signUpReader"),
                          hoverChild: iAm(
                              true,
                              S.of(context).iamReaderSignUpMode,
                              1,
                              "/signUpReader"),
                          onHover: (onHover) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BottomBarLoginWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget iAm(bool hover, String title, int index, String route) {
    double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;
    // bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      child: Container(
        height: h * 0.07,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext",
            ),
          ),
          Icon(
            LineAwesomeIcons.angle_right,
            color: Colors.black,
          )
        ]),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[300] : Colors.grey[200],
        ),
      ),
      onTap: () async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        setState(() {
          currentIndex = index;
          index == 0
              ? sharedPreferences.setString("userKind", "Journalist")
              : sharedPreferences.setString("userKind", "reader");
        });

        Navigator.of(context).pushNamed(route);
      },
    );
  }
}
