import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:intl/intl.dart' as intl;

class BottomBarLoginWidget extends StatefulWidget {
  const BottomBarLoginWidget({Key key}) : super(key: key);

  @override
  _BottomBarLoginWidgetState createState() => _BottomBarLoginWidgetState();
}

class _BottomBarLoginWidgetState extends State<BottomBarLoginWidget> {
  Widget textButtonWidget(bool hover, String title) {
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {},
      child: Container(
        height: h * .07,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              decoration:
                  hover ? TextDecoration.underline : TextDecoration.none,
              fontFamily: "SPProtext",
              fontSize: 12.0,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Directionality(
      textDirection: intl.Bidi.detectRtlDirectionality(S.of(context).copyRight)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        height: h * .06,
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: w * .03),
        child: largeScreen
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: h * .07,
                    child: Center(
                      child: Text(
                        S.of(context).copyRight,
                        textDirection: intl.Bidi.detectRtlDirectionality(
                                S.of(context).copyRight)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: TextStyle(
                          fontFamily: "SPProtext",
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w * .05),
                  HoverWidget(
                    child: textButtonWidget(false, S.of(context).privacyPolicy),
                    hoverChild:
                        textButtonWidget(true, S.of(context).privacyPolicy),
                    onHover: (onHover) {},
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  HoverWidget(
                    child: textButtonWidget(false, S.of(context).cookiePolicy),
                    hoverChild:
                        textButtonWidget(true, S.of(context).cookiePolicy),
                    onHover: (onHover) {},
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  HoverWidget(
                    child:
                        textButtonWidget(false, S.of(context).copyrightPolicy),
                    hoverChild:
                        textButtonWidget(true, S.of(context).copyrightPolicy),
                    onHover: (onHover) {},
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  HoverWidget(
                    child: textButtonWidget(false, S.of(context).terms),
                    hoverChild: textButtonWidget(true, S.of(context).terms),
                    onHover: (onHover) {},
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  HoverWidget(
                    child: textButtonWidget(false, S.of(context).help),
                    hoverChild: textButtonWidget(true, S.of(context).help),
                    onHover: (onHover) {},
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              )
            : Container(
                height: 0.0,
                width: 0.0,
              ),
      ),
    );
  }
}
