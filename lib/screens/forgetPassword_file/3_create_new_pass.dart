import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/services/routing.dart';
import 'package:uy/widget/toast.dart';
import 'package:intl/intl.dart' as intl;

class ForgetPassword3 extends StatefulWidget {
  @override
  _ForgetPassword3State createState() => _ForgetPassword3State();
}

class _ForgetPassword3State extends State<ForgetPassword3> {
  final TextEditingController newPassWordController = TextEditingController();
  final TextEditingController confirmNewPassWordController =
      TextEditingController();
  TeltrueWidget toast = TeltrueWidget();
  User currentUser = FirebaseAuth.instance.currentUser;
  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        height: h,
        width: w,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TeltrueAppBar(
              backRoute: "/PassCode",
            ),
            Expanded(
              child: Center(
                child: Container(
                  decoration: centerBoxDecoration,
                  height: h * .6,
                  width: largeScreen ? w * .27 : w * .8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * .03,
                      ),
                      Text(
                        S.of(context).subtitleCreateNewPassword,
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
                        width: w,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          S.of(context).descriptionCreateNewPassword,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600], fontFamily: "SPProtext"),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.1,
                      ),
                      Form(
                        child: Column(
                          children: [
                            SizedBox(
                              height: h * .03,
                            ),
                            createNewPassWord(),
                            SizedBox(
                              height: 5.0,
                            ),
                            confirmNewPassWord(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Container(
                        height: h * .1,
                        width: w * .4,
                        child: Center(
                            child: HoverWidget(
                                child: resetButton(false),
                                hoverChild: resetButton(true),
                                onHover: (onHover) {})),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget resetButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();

        if (newPassWordController.text.trim() ==
            confirmNewPassWordController.text.trim()) {
          changePassWord(
              prefs.getString("emailSearch").toString(),
              prefs.getString("currentPassword").toString(),
              newPassWordController.text.trim());
          Navigator.pushNamed(context, RoutesName.Home_PAGE);
        } else {
          toast.showToast(
              S.of(context).taostConfirmThePassWord, fToast, Colors.red[400]);
        }
      },
      child: Container(
        height: h * 0.05,
        width: largeScreen ? w * .1 : w * .3,
        child: Center(
          child: Text(
            S.of(context).doneButton,
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

  Widget createNewPassWord() {
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .06,
      width: largeScreen ? w * .2 : w * .6,
      child: TextFormField(
        obscureText: true,
        style: TextStyle(
            color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
        textAlign: TextAlign.center,
        controller: newPassWordController,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: S.of(context).hintTextNewPassword,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
            fontFamily: "SPProtext",
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget confirmNewPassWord() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      height: h * .06,
      width: largeScreen ? w * .2 : w * .6,
      child: TextFormField(
        obscureText: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontFamily: "SPProtext",
        ),
        textAlign: TextAlign.center,
        controller: confirmNewPassWordController,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: S.of(context).hintTextConfirmNewPassword,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
            fontFamily: "SPProtext",
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  void changePassWord(
      String email, String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final cred =
        EmailAuthProvider.credential(email: email, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(prefs.getString("id").toString())
            .update({"password": newPassword});
      }).catchError((error) {
        print("Error Update");
      });
    }).catchError((err) {});
  }
}
