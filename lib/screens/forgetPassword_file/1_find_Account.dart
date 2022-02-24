import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/forgetPassword_file/2_pass_code.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/loading_widget/find_account_loading.dart';
import 'package:uy/services/responsiveLayout.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController searchEmailAccountController =
      TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  bool searchAccount = false;
  String id;
  bool loading = false;

  void getEmailResetPassWord() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Users");

    QuerySnapshot querySnapshot = await _collectionRef.get();

    setState(() {
      final results = querySnapshot.docs.where((document) =>
          document.data()["email"].toString() ==
          searchEmailAccountController.text.trim());

      id = results.first.id;
      //loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
      backgroundColor: mainColor,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(builder: (context) {
          return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  height: h,
                  width: w,
                  child: Column(children: [
                    TeltrueAppBar(
                      backRoute: "/LogIn",
                    ),
                    Expanded(
                      child: Row(children: [
                        Container(
                          width: w * .6,
                          child: Center(
                            child: Image.asset(
                              "./assets/images/search.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: centerBoxDecoration,
                          height: h * .65,
                          width: largeScreen ? w * .25 : w * .8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: h * .03,
                              ),
                              Text(
                                S.of(context).subtitleResetPassword,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: "SPProtext",
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                              Container(
                                padding: EdgeInsets.all(25.0),
                                width: largeScreen ? w * .4 : w * .8,
                                child: Text(
                                  S.of(context).descriptionResetPassword,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "SPProtext"),
                                ),
                              ),
                              !searchAccount
                                  ? Container(
                                      height: h * .3,
                                      width: largeScreen ? w * .4 : w * .8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: h * .06,
                                            width:
                                                largeScreen ? w * .2 : w * .7,
                                            child: TextFormFieldWidget(
                                              controller:
                                                  searchEmailAccountController,
                                              hintText: S
                                                  .of(context)
                                                  .hintTextResetPassword,
                                              validate: true,
                                              errorText:
                                                  "* ${S.of(context).requiredFiled}",
                                            ),
                                          ),
                                          Container(
                                            height: h * .1,
                                            width:
                                                largeScreen ? w * .4 : w * .6,
                                            child: Center(
                                              child: HoverWidget(
                                                child: verifyButton(false),
                                                hoverChild: verifyButton(true),
                                                onHover: (onHover) {},
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Container(
                                        width: w * .4,
                                        child: loading
                                            ? verifyAccountLoading(
                                                h, w, largeScreen)
                                            : id == null
                                                ? noAccountAttached()
                                                : accountConfirm(id),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ])));
        }),
      ),
    );
  }

  Widget accountConfirm(String id) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return verifyAccountLoading(h, w, largeScreen);
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
              margin: EdgeInsets.all(5.0),
              width: largeScreen ? w * .12 : w * .4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Container(
                    height: h * .15,
                    width: h * .15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                          image: Image.network(data["image"]).image,
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    width: largeScreen ? w * .12 : w * .4,
                    height: h * .05,
                    child: Center(
                      child: Text(
                        data["full_name"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SPProtext",
                        ),
                      ),
                    ),
                  ),
                  Text(
                    data["email"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                      fontFamily: "SPProtext",
                    ),
                  ),
                  Container(
                    height: h * .14,
                    width: w * .4,
                    child: Center(
                        child: HoverWidget(
                            child: itsMe(false),
                            hoverChild: itsMe(true),
                            onHover: (onHover) {})),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            );
          }
          return verifyAccountLoading(h, w, largeScreen);
        });
  }

  Widget verifyButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        setState(() {
          searchAccount = true;
          getEmailResetPassWord();
          loading = true;
        });
        Timer(Duration(seconds: 4), () {
          setState(() {
            loading = false;
          });
        });
      },
      child: Container(
        height: h * 0.05,
        width: largeScreen ? w * .1 : w * .3,
        child: Center(
          child: Text(
            S.of(context).verifybuttonPassCode,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: "SPProtext"),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: hover ? buttonColorHover : buttonColor),
      ),
    );
  }

  Widget itsMe(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        sendOtp();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PassCode(
              nextRoute: "/ForgetPassword3",
              backRoute: "/ForgetPassword",
            ),
          ),
        );
      },
      child: Container(
        height: h * 0.05,
        width: largeScreen ? w * .1 : w * .3,
        child: Center(
          child: Text(
            S.of(context).yesItsMeButton,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: "SPProtext"),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: hover ? buttonColorHover : buttonColor,
        ),
      ),
    );
  }

  Widget tryAgainButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          searchAccount = false;
        });
      },
      child: Container(
        height: h * 0.05,
        width: w * .1,
        child: Center(
          child: Text(
            S.of(context).tryAgainButton,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: "SPProtext"),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: hover ? buttonColor.withOpacity(0.7) : buttonColor),
      ),
    );
  }

  Widget noAccountAttached() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      margin: EdgeInsets.all(5.0),
      width: largeScreen ? w * .12 : w * .4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: h * 0.02,
          ),
          Expanded(
            child: Container(
              width: w * .4,
              child: Center(
                child: Text(
                  S.of(context).noAccountAttachedDes,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontFamily: "SPProtext"),
                ),
              ),
            ),
          ),
          Container(
            height: h * .14,
            width: w * .4,
            child: Center(
                child: HoverWidget(
                    child: tryAgainButton(false),
                    hoverChild: tryAgainButton(true),
                    onHover: (onHover) {})),
          ),
        ],
      ),
    );
  }

  void sendOtp() async {
    final prefs = await SharedPreferences.getInstance();
    EmailAuth.sessionName = "Teltrue";

    await EmailAuth.sendOtp(
        receiverMail: searchEmailAccountController.value.text);
    prefs.setString("emailSearch", searchEmailAccountController.text.trim());
    prefs.setString("id", id);
  }
}
