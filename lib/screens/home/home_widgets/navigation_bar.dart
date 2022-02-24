import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/search/search_page.dart';
import 'package:uy/services/responsiveLayout.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.only(left: w * .03, right: w * .03),
        height: h * .07,
        width: w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: h * .07,
              width: w * .15,
              child: Center(
                child: Text(
                  "Telltrue",
                  style: TextStyle(
                    fontFamily: "MarckScript",
                    fontSize: largeScreen ? 40.0 : 30.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF505072),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SearchPage(),
              ),
            ),
            Container(
              height: h * .07,
              width: w * .22,
            ),
          ],
        ),
      ),
    );
  }
}

class TeltrueAppBar extends StatefulWidget {
  final String backRoute;
  final String nextRoute;
  final String nextRouteTitle;
  final Function() function;
  const TeltrueAppBar({
    Key key,
    this.backRoute,
    this.nextRoute,
    this.nextRouteTitle,
    this.function,
  }) : super(key: key);

  @override
  _TeltrueAppBarState createState() => _TeltrueAppBarState();
}

class _TeltrueAppBarState extends State<TeltrueAppBar> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.only(left: w * .03, right: w * .03),
        height: h * .07,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(widget.backRoute);
              },
              child: HoverWidget(
                  child: backButton(false),
                  hoverChild: backButton(true),
                  onHover: (onHover) {}),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: h * .07,
              child: Center(
                child: Text(
                  "Telltrue",
                  style: TextStyle(
                    fontFamily: "MarckScript",
                    fontSize: largeScreen ? 40.0 : 30,
                    color: Color(0xFF388087),
                  ),
                ),
              ),
            ),
            widget.nextRoute != null || widget.function != null
                ? InkWell(
                    onTap: widget.function != null
                        ? widget.function
                        : () {
                            Navigator.of(context).pushNamed(widget.nextRoute);
                          },
                    child: HoverWidget(
                      child: logInButton(widget.nextRouteTitle, false),
                      hoverChild: logInButton(widget.nextRouteTitle, true),
                      onHover: (onHover) {},
                    ),
                  )
                : Container(
                    height: h * .05,
                    width: w * .1,
                  )
          ],
        ),
      ),
    );
  }

  Widget logInButton(String title, bool hover) {
    double h = MediaQuery.of(context).size.height;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * .1,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.blue[900] : Colors.blue),
      height: h * .05,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "SPProtext",
            fontSize: largeScreen ? 14.0 : 12.0,
          ),
        ),
      ),
    );
  }

  Widget backButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      decoration: BoxDecoration(
        color: hover ? Colors.blue[900] : Colors.blue,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Icon(
          LineAwesomeIcons.angle_left,
          color: Colors.white,
        ),
      ),
    );
  }
}
