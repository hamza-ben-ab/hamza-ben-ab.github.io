import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/services/resetPassword.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/widget/toast.dart';

class PassCode extends StatefulWidget {
  final String nextRoute;
  final String backRoute;

  const PassCode({Key key, this.nextRoute, this.backRoute}) : super(key: key);
  @override
  _PassCodeState createState() => _PassCodeState();
}

class _PassCodeState extends State<PassCode> {
  final TextEditingController code = TextEditingController();
  String fullName;
  bool notValidate = false;
  AuthServices authServices = AuthServices();
  UserCredential userCredential;
  String currentPassword;
  TeltrueWidget toast = TeltrueWidget();
  User currentUser = FirebaseAuth.instance.currentUser;
  FToast fToast;
  bool loading = false;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  void sendOtp() async {
    final prefs = await SharedPreferences.getInstance();
    EmailAuth.sessionName = "Telltrue";

    await EmailAuth.sendOtp(receiverMail: prefs.getString("email").toString());
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
        body: Container(
      height: h,
      width: w,
      color: Colors.white,
      child: Column(
        children: [
          TeltrueAppBar(
            backRoute: widget.backRoute,
          ),
          Expanded(
            child: Row(children: [
              Container(
                width: w * .6,
                child: Center(
                  child: Image.asset(
                    "./assets/images/send.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Stack(children: [
                Container(
                  height: h * .6,
                  width: largeScreen ? w * .27 : w * .8,
                  decoration: centerBoxDecoration,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * .03,
                      ),
                      Text(
                        S.of(context).subtitlePassCode,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontFamily: "SPProtext",
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: h * 0.05,
                      ),
                      Container(
                        height: h * 0.15,
                        width: largeScreen ? w * .25 : w * .55,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: S.of(context).descriptionP1ReviewPage + " ",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: "SPProtext"),
                              children: [
                                TextSpan(
                                  text: fullName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontFamily: "SPProtext",
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: S.of(context).descriptionPassCode,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "SPProtext"),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Container(
                        height: h * .06,
                        width: largeScreen ? w * .2 : w * .45,
                        child: TextFormFieldWidget(
                          controller: code,
                          hintText: S.of(context).hintTextPassCode,
                          validate: false,
                        ),
                      ),
                      Container(
                        height: h * .1,
                        width: w * 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                sendOtp();
                              },
                              child: Text(
                                S.of(context).resendCodeFlatButtonPassCode,
                                style: TextStyle(
                                    color: Colors.blue[300],
                                    fontFamily: "SPProtext"),
                              ),
                            )
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
                                child: verifyButton(false),
                                hoverChild: verifyButton(true),
                                onHover: (onHover) {})),
                      )
                    ],
                  ),
                ),
                loading
                    ? Container(
                        height: h * .6,
                        width: largeScreen ? w * .27 : w * .8,
                        color: Colors.grey[200].withOpacity(0.3),
                        child: Center(
                          child: SpinKitThreeBounce(
                            color: Colors.grey[600],
                            size: 25.0,
                          ),
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      )
              ]),
            ]),
          ),
        ],
      ),
    ));
  }

  void verifyForPassWord() async {
    setState(() {
      loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("Users").doc(id).get();
    prefs.setString("currentPassword", doc.data()["password"]);
    bool validate = EmailAuth.validate(
      receiverMail: prefs.getString("emailSearch").toString(),
      userOTP: code.value.text,
    );

    if (validate) {
      Navigator.of(context).pushNamed(widget.nextRoute);
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: doc.data()["email"], password: doc.data()["password"]);
    } else {
      setState(() {
        loading = false;
      });
      toast.showToast(S.of(context).toastInvalidCode, fToast, Colors.red[400]);
    }
  }

  void verifyForSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });

    bool validate = EmailAuth.validate(
      receiverMail: prefs.getString("email").toString(),
      userOTP: code.value.text,
    );

    if (validate) {
      try {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: prefs.getString("email").toString(),
          password: prefs.getString("password").toString(),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "email-already-in-use") {
          Navigator.of(context).pushNamed(widget.backRoute);
          return toast.showToast(
              S.of(context).theAccountAlready, fToast, Colors.red[400]);
        }
      }
      Navigator.of(context).pushNamed(widget.nextRoute);
    } else {
      setState(() {
        loading = false;
      });
      toast.showToast(S.of(context).toastInvalidCode, fToast, Colors.red[400]);
    }
  }

  Widget verifyButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        widget.backRoute == "/ForgetPassword"
            ? verifyForPassWord()
            : verifyForSignUp();
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
              fontFamily: "SPProtext",
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: !hover ? buttonColor : buttonColorHover,
        ),
      ),
    );
  }
}
