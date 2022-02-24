import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/forgetPassword_file/2_pass_code.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/screens/menu/edit_location/create_location.dart';
import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uy/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/widget/toast.dart';

class SignUpReader extends StatefulWidget {
  const SignUpReader({Key key}) : super(key: key);

  @override
  _SignUpReaderState createState() => _SignUpReaderState();
}

class _SignUpReaderState extends State<SignUpReader> {
  bool selectMale = false;
  bool selectFemale = false;
  bool loading = false;
  final TextEditingController firstnameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  final TextEditingController homelocationController = TextEditingController();
  final TextEditingController currentlocationController =
      TextEditingController();
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  final textFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  sendOtp() async {
    EmailAuth.sessionName = "Telltrue";
    await EmailAuth.sendOtp(receiverMail: emailController.value.text);
  }

  Widget maleButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          selectMale = !selectMale;
          selectFemale = false;
        });
        if (selectMale) {
          prefs.setString("genderValue", "male");
        }
      },
      child: Container(
        height: h * .045,
        width: largeScreen ? w * .1 : w * .2,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border:
              Border.all(color: !selectMale ? Colors.grey[400] : Colors.blue),
        ),
        child: Center(
          child: Text(
            S.of(context).hintTextSelectMale,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
              fontFamily: "SPProtext",
            ),
          ),
        ),
      ),
    );
  }

  Widget femaleButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          selectFemale = !selectFemale;
          selectMale = false;
        });
        if (selectFemale) {
          prefs.setString("genderValue", "female");
        }
      },
      child: Container(
        height: h * .045,
        width: largeScreen ? w * .1 : w * .2,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border:
              Border.all(color: !selectFemale ? Colors.grey[400] : Colors.blue),
        ),
        child: Center(
          child: Text(
            S.of(context).hintTextSelectFemale,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
              fontFamily: "SPProtext",
            ),
          ),
        ),
      ),
    );
  }

  nextFunction() async {
    final locationProvider =
        Provider.of<CreateLocationProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (textFormKey.currentState.validate()) {
      if (firstnameController.text.split(" ").length >= 2 &&
              emailValidator(emailController.text.trim()) &&
              passwordController.text.length >= 8 &&
              confirmpassword.text.trim() == passwordController.text.trim() &&
              selectFemale ||
          selectMale) {
        setState(() {
          loading = true;
        });
        prefs.setString("full_name", firstnameController.text.trim());
        prefs.setString("password", passwordController.text.trim());
        prefs.setString("email", emailController.text.trim());
        prefs.setString("currentLocation",
            locationProvider.currentLocationController.text.trim());
        prefs.setString(
            "homeTownLocation", locationProvider.homeTownLocation.text.trim());

        prefs.setString("gender", selectMale ? "male" : "female");

        sendOtp();
        setState(() {
          loading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PassCode(
              nextRoute: "/AddProfileImage",
              backRoute: "/signUpReader",
            ),
          ),
        );
      } else {
        if (firstnameController.text.split(" ").length < 2) {
          return toast.showToast(
              S.of(context).snackBarInvalidFullName, fToast, Colors.red[400]);
        } else if (!emailValidator(emailController.text.trim())) {
          return toast.showToast(
              S.of(context).snackBarInvalidEmail, fToast, Colors.red[400]);
        } else if (passwordController.text.length < 8) {
          return toast.showToast(
              S.of(context).snackBarInvalidPassword, fToast, Colors.red[400]);
        } else if (confirmpassword.text.trim() !=
            passwordController.text.trim()) {
          return toast.showToast(S.of(context).snackBarInvalidConfirmPassword,
              fToast, Colors.red[400]);
        } else if (!selectFemale && !selectMale) {
          return toast.showToast("Select Gender", fToast, Colors.red[400]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (context) {
          double h = MediaQuery.of(context).size.height;
          double w = MediaQuery.of(context).size.width;
          bool largeScreen = ResponsiveLayout.isLargeScreen(context);

          return Container(
            color: Colors.white,
            height: h,
            width: w,
            child: Column(
              children: [
                TeltrueAppBar(
                  backRoute: "/Sign_Up_choice",
                  nextRouteTitle: S.of(context).nextButton,
                  function: nextFunction,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Expanded(
                    child: Center(
                      child: Stack(
                        children: [
                          Directionality(
                            textDirection: intl.Bidi.detectRtlDirectionality(
                                    S.of(context).fullNameTitleSignUpWithEmail)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Container(
                              height: h * .75,
                              width: largeScreen ? w * .3 : w * .6,
                              decoration: centerBoxDecoration,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Form(
                                key: textFormKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: h * .06,
                                      width: largeScreen ? w * .3 : w * .5,
                                      child: TextFormFieldWidget(
                                        controller: firstnameController,
                                        validate: true,
                                        errorText: S.of(context).requiredFiled,
                                        hintText:
                                            S.of(context).firstAndlastName,
                                      ),
                                    ),
                                    Container(
                                      height: h * .06,
                                      width: largeScreen ? w * .3 : w * .5,
                                      child: TextFormFieldWidget(
                                        controller: emailController,
                                        validate: true,
                                        errorText: S.of(context).requiredFiled,
                                        hintText: S
                                            .of(context)
                                            .emailTitleSignUpWithEmail,
                                      ),
                                    ),
                                    Container(
                                        height: h * .06,
                                        width: largeScreen ? w * .7 : w * .6,
                                        child: TextFormFieldWidget(
                                          validate: true,
                                          errorText:
                                              "* ${S.of(context).requiredFiled}",
                                          hintText: S
                                              .of(context)
                                              .createProfileHomeTwonHintText,
                                          func: () {
                                            showDialog(
                                                context:
                                                    _scaffoldKey.currentContext,
                                                builder: (dialogcontext) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                    elevation: 0.0,
                                                    child: CreateLocation(
                                                      current: false,
                                                    ),
                                                  );
                                                });
                                          },
                                          controller: Provider.of<
                                              CreateLocationProvider>(
                                            context,
                                          ).homeTownLocation,
                                        )),

                                    //currentlocation
                                    Container(
                                        height: h * .06,
                                        width: largeScreen ? w * .7 : w * .6,
                                        child: TextFormFieldWidget(
                                          validate: true,
                                          errorText:
                                              "* ${S.of(context).requiredFiled}",
                                          hintText: S
                                              .of(context)
                                              .createProfilecurrentCityHintText,
                                          func: () {
                                            showDialog(
                                                context:
                                                    _scaffoldKey.currentContext,
                                                builder: (dialogcontext) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                    elevation: 0.0,
                                                    child: CreateLocation(
                                                      current: true,
                                                    ),
                                                  );
                                                });
                                          },
                                          controller: Provider.of<
                                              CreateLocationProvider>(
                                            context,
                                          ).currentLocationController,
                                        )),
                                    Container(
                                      height: h * .06,
                                      width: largeScreen ? w * .35 : w * .5,
                                      child: TextFormField(
                                        textDirection:
                                            intl.Bidi.detectRtlDirectionality(
                                          S
                                              .of(context)
                                              .hintTextConfirmPasswordSignUpWithEmail,
                                        )
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontFamily: "SPProtext"),
                                        textAlign: TextAlign.center,
                                        controller: confirmpassword,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintTextDirection:
                                              intl.Bidi.detectRtlDirectionality(
                                            S
                                                .of(context)
                                                .hintTextPasswordSignUpWithEmail,
                                          )
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                          alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: S
                                              .of(context)
                                              .hintTextPasswordSignUpWithEmail,
                                          hintText: S
                                              .of(context)
                                              .hintTextPasswordSignUpWithEmail,
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontFamily: "SPProtext",
                                            letterSpacing: 1.2,
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontFamily: "SPProtext",
                                            letterSpacing: 1.2,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[600],
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[600],
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[600],
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey[600],
                                              width: 0.5,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: h * .06,
                                      width: largeScreen ? w * .35 : w * .5,
                                      child: TextFormField(
                                        textDirection:
                                            intl.Bidi.detectRtlDirectionality(
                                          S
                                              .of(context)
                                              .hintTextPasswordSignUpWithEmail,
                                        )
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontFamily: "SPProtext"),
                                        textAlign: TextAlign.center,
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintTextDirection:
                                              intl.Bidi.detectRtlDirectionality(
                                            S
                                                .of(context)
                                                .hintTextPasswordSignUpWithEmail,
                                          )
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                          alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: S
                                              .of(context)
                                              .hintTextPasswordSignUpWithEmail,
                                          hintText: S
                                              .of(context)
                                              .hintTextConfirmPasswordSignUpWithEmail,
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontFamily: "SPProtext",
                                            letterSpacing: 1.2,
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontFamily: "SPProtext",
                                            letterSpacing: 1.2,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[600],
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[600],
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[600],
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey[600],
                                              width: 0.5,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: h * .06,
                                      width: largeScreen ? w * .3 : w * .5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          HoverWidget(
                                              child: maleButton(false),
                                              hoverChild: maleButton(true),
                                              onHover: (onHover) {}),
                                          HoverWidget(
                                              child: femaleButton(false),
                                              hoverChild: femaleButton(true),
                                              onHover: (onHover) {})
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          loading
                              ? Container(
                                  height: h * .87,
                                  width: largeScreen ? w * .3 : w * .6,
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
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * .02,
                ),
                BottomBarLoginWidget()
              ],
            ),
          );
        },
      ),
    );
  }
}
