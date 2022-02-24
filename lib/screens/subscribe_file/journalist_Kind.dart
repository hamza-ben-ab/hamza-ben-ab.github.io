import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/widget/toast.dart';

class JournalistKind extends StatefulWidget {
  @override
  _JournalistKindState createState() => _JournalistKindState();
}

class _JournalistKindState extends State<JournalistKind> {
  int currentIndex = 100;
  ScrollController controller = ScrollController();
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  Widget journalistKindItem(int index, bool hover, String title, String image) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        setState(() {
          currentIndex = index;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("journalistKind", title);
      },
      child: Container(
        height: h * .3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color: currentIndex == index
                    ? Colors.blueAccent
                    : hover
                        ? Colors.blue
                        : Colors.grey[400]),
            color: currentIndex == index ? Colors.blueAccent : Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: largeScreen ? h * .08 : h * .06,
              width: largeScreen ? h * .08 : h * .06,
              child: Image.asset(
                "./assets/images/journalistKind/$image",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: largeScreen ? h * 0.01 : h * .005,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: largeScreen ? 14.0 : 10,
                fontWeight: FontWeight.w500,
                color: currentIndex == index ? Colors.white : Colors.black,
                fontFamily: "SPProtext",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otherWidget(int index, bool hover) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        height: h * .3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color: currentIndex == index
                    ? Colors.blueAccent
                    : hover
                        ? Colors.blue
                        : Colors.grey[400]),
            color: currentIndex == index ? Colors.blueAccent : Colors.white),
        child: Center(
          child: Text(
            S.of(context).other,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: largeScreen ? 14.0 : 10,
              fontWeight: FontWeight.w500,
              color: currentIndex == index ? Colors.white : Colors.black,
              fontFamily: "SPProtext",
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

    return Scaffold(
        body: Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(builder: (context) {
        return Container(
          color: Colors.white,
          height: h,
          width: w,
          child: Column(
            children: [
              TeltrueAppBar(
                nextRoute: "/SignUpWithEmail",
                backRoute: "/Sign_Up_choice",
                nextRouteTitle: S.of(context).nextButton,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: largeScreen ? w * .5 : w * .9,
                    height: largeScreen ? h * .8 : h * .9,
                    child: GridView.count(
                      crossAxisCount: largeScreen ? 4 : 3,
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      shrinkWrap: true,
                      primary: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        HoverWidget(
                            child: journalistKindItem(
                                0,
                                false,
                                S.of(context).journalistReporter,
                                "reporter.png"),
                            hoverChild: journalistKindItem(
                                0,
                                true,
                                S.of(context).journalistReporter,
                                "reporter.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(1, false,
                                S.of(context).journalistWriter, "writer.png"),
                            hoverChild: journalistKindItem(1, true,
                                S.of(context).journalistWriter, "writer.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(
                                3,
                                false,
                                S.of(context).journalistAnimator,
                                "presenter.png"),
                            hoverChild: journalistKindItem(
                                3,
                                true,
                                S.of(context).journalistAnimator,
                                "presenter.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(4, false,
                                S.of(context).photoJournalist, "photo.png"),
                            hoverChild: journalistKindItem(4, true,
                                S.of(context).photoJournalist, "photo.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(5, false,
                                S.of(context).journalistEditor, "editor.png"),
                            hoverChild: journalistKindItem(5, true,
                                S.of(context).journalistEditor, "editor.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(
                                6,
                                false,
                                S.of(context).onlineJournalistBloger,
                                "bloger.png"),
                            hoverChild: journalistKindItem(
                                6,
                                true,
                                S.of(context).onlineJournalistBloger,
                                "bloger.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(7, false,
                                S.of(context).tvColumnist, "columinst.png"),
                            hoverChild: journalistKindItem(7, true,
                                S.of(context).tvColumnist, "columinst.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(
                                8, false, "Politician", "politician.png"),
                            hoverChild: journalistKindItem(
                                8, true, "Politician", "politician.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(
                                9, false, "Searcher", "searcher.png"),
                            hoverChild: journalistKindItem(
                                9, true, "Searcher", "searcher.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(
                                10,
                                false,
                                S.of(context).freelanceJournalist,
                                "freeLance.png"),
                            hoverChild: journalistKindItem(
                                10,
                                true,
                                S.of(context).freelanceJournalist,
                                "freeLance.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: journalistKindItem(
                                11,
                                false,
                                S.of(context).investigativeJournalist,
                                "detective.png"),
                            hoverChild: journalistKindItem(
                                11,
                                true,
                                S.of(context).investigativeJournalist,
                                "detective.png"),
                            onHover: (onHover) {}),
                        HoverWidget(
                            child: otherWidget(12, false),
                            hoverChild: otherWidget(12, true),
                            onHover: (onHover) {})
                      ],
                    ),
                  ),
                ),
              ),
              BottomBarLoginWidget()
            ],
          ),
        );
      }),
    ));
  }

  Widget nextButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        if (currentIndex != 100) {
          Navigator.of(context).pushNamed("/SignUpWithEmail");
        } else {
          return toast.showToast(
              S.of(context).snackBarSelectOption, fToast, Colors.red[400]);
        }
      },
      child: Container(
        width: largeScreen ? w * .1 : w * .2,
        height: h * .05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey[400]),
          color: hover ? Colors.grey[200] : Colors.white,
        ),
        child: Center(
          child: Text(
            S.of(context).nextButton,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: largeScreen ? 18.0 : 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
