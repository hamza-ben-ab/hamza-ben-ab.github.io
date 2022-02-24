import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/screens/login_page/logInPage.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({
    Key key,
  }) : super(key: key);
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        color: Colors.white,
        child: Column(
          children: [
            TeltrueAppBar(
              backRoute: "/VerifyYourIdentity2",
              nextRouteTitle: S.of(context).accountMenuLogOut,
              function: () async {
                await FirebaseAuth.instance.signOut().then(
                      (value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      ),
                    );
              },
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  width: w * .3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey[400],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        S.of(context).subtitleReviewPage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SPProtext",
                        ),
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      FutureBuilder<DocumentSnapshot>(
                          future: users.doc(currentUser.uid).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> document =
                                  snapshot.data.data();
                              return RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: S.of(context).descriptionP1ReviewPage,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontFamily: "SPProtext",
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${document["firstName"]} ${document["lastName"]}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "SPProtext",
                                        ),
                                      ),
                                      TextSpan(
                                        text: S
                                            .of(context)
                                            .descriptionP3ReviewPage,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontFamily: "SPProtext",
                                        ),
                                      )
                                    ]),
                              );
                            }
                            return Container(
                              height: 0.0,
                              width: 0.0,
                            );
                          }),
                    ],
                  ),
                ),
              ],
            )),
            BottomBarLoginWidget()
          ],
        ),
      ),
    );
  }
}
