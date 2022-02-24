import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:hovering/hovering.dart';
import 'package:uy/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/home/home_View.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    Key key,
  }) : super(key: key);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
                //nextRoute: "/WelcomePage",
                backRoute: "/SuggestionPage",
                nextRouteTitle: S.of(context).nextButton,
              ),
              Expanded(
                child: Center(
                  child: Directionality(
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).signUpFlatButtonLoginPage)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          margin: EdgeInsets.symmetric(horizontal: w * .03),
                          //decoration: centerBoxDecoration,
                          width: w * .3,
                          height: h * .5,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).welcomeToOurteam,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 70.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                                SizedBox(
                                  height: h * .02,
                                ),
                                Text(
                                  S.of(context).subtitleWelcomePage,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[600],
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                                SizedBox(
                                  height: h * .05,
                                ),
                                HoverWidget(
                                    child: startButton(false),
                                    hoverChild: startButton(true),
                                    onHover: (onHover) {})
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: w * .6,
                          child: Center(
                            child: Image.asset(
                              "./assets/images/welcome.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.1,
              ),
              BottomBarLoginWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget startButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        users.doc(currentUser.uid).update({
          "firstTime": true,
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: h * .06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.blue[800] : Colors.blue,
        ),
        child: Center(
          child: Text(S.of(context).startButton,
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontFamily: "SPProtext")),
        ),
      ),
    );
  }
}
