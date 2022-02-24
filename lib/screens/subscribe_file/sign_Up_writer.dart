import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:uy/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/forgetPassword_file/2_pass_code.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/screens/menu/edit_location/create_location.dart';
import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/widget/toast.dart';

class SignUpWithEmail extends StatefulWidget {
  @override
  _SubscribeJournalistState createState() => _SubscribeJournalistState();
}

class _SubscribeJournalistState extends State<SignUpWithEmail> {
  bool selectMale = false;
  bool selectFemale = false;
  bool loading = false;

  List<String> currentDate = DateTime.now().toString().split("-");
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;
  UserCredential userCredential;
  final TextEditingController _day = TextEditingController();
  final TextEditingController _month = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController typeAheadController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final TextEditingController phone1Controller = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();
  final TextEditingController homelocationController = TextEditingController();
  final TextEditingController currentlocationController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final textFormKey1 = GlobalKey<FormState>();
  final textFormKey2 = GlobalKey<FormState>();
  bool emailValidation = true;

  void sendOtp() async {
    EmailAuth.sessionName = "Telltrue";

    await EmailAuth.sendOtp(receiverMail: emailController.value.text);
  }

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

  Widget nextButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      child: Container(
        width: largeScreen ? w * .1 : w * .2,
        height: h * .05,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey[400]),
            color: hover ? Colors.grey[100] : Colors.white),
        child: Center(
          child: Text(
            S.of(context).nextButton,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: largeScreen ? 18.0 : 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget passWordTextField(TextEditingController controller, String hintText) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      height: h * .06,
      width: largeScreen ? w * .7 : w * .6,
      child: TextFormField(
        validator: (text) {
          if (text == null || text.isEmpty) {
            return S.of(context).requiredFiled;
          }
          return null;
        },
        textDirection: intl.Bidi.detectRtlDirectionality(hintText)
            ? TextDirection.rtl
            : TextDirection.ltr,
        style: TextStyle(
            color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
        textAlign: TextAlign.center,
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintTextDirection: intl.Bidi.detectRtlDirectionality(hintText)
              ? TextDirection.rtl
              : TextDirection.ltr,
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          fillColor: Colors.white,
          filled: true,
          labelText: hintText,
          hintText: hintText,
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
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
            borderRadius: BorderRadius.circular(15.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[600],
              width: 0.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
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
              fontSize: 14.0,
              color: Colors.grey[700],
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
              fontSize: 14.0,
              color: Colors.grey[700],
              fontFamily: "SPProtext",
            ),
          ),
        ),
      ),
    );
  }

  Widget birthdayTextField() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      height: h * .07,
      width: largeScreen ? w * .4 : w * .7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: h * .06,
            width: largeScreen ? w * .07 : w * .18,
            child: TextFormField(
              style: TextStyle(
                  color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
              textAlign: TextAlign.center,
              onSaved: (value) => _day.text = value.trim(),
              controller: _day,
              inputFormatters: [
                LengthLimitingTextInputFormatter(2),
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                fillColor: Colors.white,
                filled: true,
                labelText: S.of(context).hintTextDay,
                hintText: S.of(context).hintTextDay,
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
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[600],
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintTextDirection:
                    intl.Bidi.detectRtlDirectionality(S.of(context).hintTextDay)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
              ),
            ),
          ),
          Text(
            "/",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
              fontFamily: "SPProtext",
            ),
          ),
          Container(
            height: h * .06,
            width: largeScreen ? w * .07 : w * .18,
            child: TextFormField(
              style: TextStyle(
                  color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
              textAlign: TextAlign.center,
              onSaved: (value) => _month.text = value.trim(),
              controller: _month,
              inputFormatters: [
                LengthLimitingTextInputFormatter(2),
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                fillColor: Colors.white,
                filled: true,
                labelText: S.of(context).hintTextMonth,
                hintText: S.of(context).hintTextMonth,
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
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[600],
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintTextDirection: intl.Bidi.detectRtlDirectionality(
                        S.of(context).hintTextMonth)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
            ),
          ),
          Text(
            "/",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
              fontFamily: "SPProtext",
            ),
          ),
          Container(
            height: h * .06,
            width: largeScreen ? w * .07 : w * .18,
            child: TextFormField(
              style: TextStyle(
                  color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
              textAlign: TextAlign.center,
              onSaved: (value) => _year.text = value.trim(),
              controller: _year,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                fillColor: Colors.white,
                filled: true,
                labelText: S.of(context).hintTextYear,
                hintText: S.of(context).hintTextYear,
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
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[600],
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintTextDirection: intl.Bidi.detectRtlDirectionality(
                        S.of(context).hintTextYear)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget alertBox(String title) {
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      width: largeScreen ? w * .7 : w * .6,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontFamily: "SPProtext",
        ),
      ),
    );
  }

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
    bool mediumScreen = ResponsiveLayout.isMediumScreen(context);
    final locationProvider =
        Provider.of<CreateLocationProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (context) {
          return Container(
            color: Colors.white,
            height: h,
            width: w,
            child: Column(
              children: [
                TeltrueAppBar(
                    backRoute: "/JournalistKind",
                    nextRouteTitle: S.of(context).nextButton,
                    function: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool validateDay = (_day.text.isNotEmpty &&
                              int.parse(_day.text) > 0 &&
                              int.parse(_day.text) <= 31)
                          ? true
                          : false;
                      bool validateMonth = (_month.text.isNotEmpty &&
                              int.parse(_month.text) > 0 &&
                              int.parse(_month.text) <= 12)
                          ? true
                          : false;
                      bool validateYear =
                          (_year.text.isNotEmpty && int.parse(_year.text) > 0)
                              ? true
                              : false;

                      if (textFormKey1.currentState.validate()) {
                        if (emailValidator(emailController.text.trim()) &&
                            passwordController.text.length >= 8 &&
                            confirmpassword.text.trim() ==
                                passwordController.text.trim()) {
                          setState(() {
                            loading = true;
                          });
                          prefs.setString(
                              "first_name", firstnameController.text.trim());
                          prefs.setString(
                              "last_name", lastnameController.text.trim());
                          prefs.setString(
                              "password", passwordController.text.trim());
                          prefs.setString("email", emailController.text.trim());
                          prefs.setString("currentLocation",
                              currentlocationController.text.trim());
                          prefs.setString("homeTownLocation",
                              homelocationController.text.trim());
                          prefs.setString(
                              "workSpace", typeAheadController.text.trim());
                          prefs.setString("birthday",
                              "${_day.text.trim()}/${_month.text.trim()}/${_year.text.trim()}");
                          prefs.setString(
                              "gender", selectMale ? "male" : "female");
                          prefs.setString("phone",
                              "${phone1Controller.text.trim()} ${phone2Controller.text.trim()}");
                          sendOtp();
                          setState(() {
                            loading = false;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PassCode(
                                nextRoute: "/VerifyYourIdentity",
                                backRoute: "/SignUpWithEmail",
                              ),
                            ),
                          );
                        }
                      } else {
                        if (!emailValidator(emailController.text.trim()) &&
                            emailController.text.trim() != null) {
                          return toast.showToast(
                              S.of(context).snackBarInvalidEmail,
                              fToast,
                              Colors.red[400]);
                        } else if (passwordController.text.length < 8) {
                          return toast.showToast(
                              S.of(context).snackBarInvalidPassword,
                              fToast,
                              Colors.red[400]);
                        } else if (passwordController.text.trim() !=
                            confirmpassword.text.trim()) {
                          return toast.showToast(
                              S.of(context).snackBarInvalidConfirmPassword,
                              fToast,
                              Colors.red[400]);
                        } else if (!selectFemale && !selectMale) {
                          return toast.showToast(
                              "Select Gender", fToast, Colors.red[400]);
                        } else if (!validateDay ||
                            !validateMonth ||
                            !validateYear) {
                          return toast.showToast(
                              S.of(context).snackBarInvalidBirthday,
                              fToast,
                              Colors.red[400]);
                        }
                      }
                    }),
                largeScreen
                    ? Expanded(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Center(
                            child: Stack(
                              children: [
                                Form(
                                  key: textFormKey1,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: h * .85,
                                        width: mediumScreen ? w * .8 : w * .72,
                                        decoration: centerBoxDecoration,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 10.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: w * .27,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: h * .02,
                                                  ),
                                                  //first_name
                                                  Container(
                                                    height: h * .06,
                                                    width: largeScreen
                                                        ? w * .7
                                                        : w * .6,
                                                    child: TextFormFieldWidget(
                                                      controller:
                                                          firstnameController,
                                                      validate: true,
                                                      errorText:
                                                          "* ${S.of(context).requiredFiled}",
                                                      hintText: S
                                                          .of(context)
                                                          .firstAndlastName,
                                                    ),
                                                  ),
                                                  alertBox(S
                                                      .of(context)
                                                      .spellYourName),
                                                  SizedBox(
                                                    height: h * .02,
                                                  ),
                                                  //lastName
                                                  Container(
                                                    height: h * .06,
                                                    width: largeScreen
                                                        ? w * .7
                                                        : w * .6,
                                                    child: TextFormFieldWidget(
                                                        controller:
                                                            lastnameController,
                                                        validate: true,
                                                        errorText:
                                                            "* ${S.of(context).requiredFiled}",
                                                        hintText: S
                                                            .of(context)
                                                            .fullLegalLastName),
                                                  ),
                                                  alertBox(S
                                                      .of(context)
                                                      .spellYourName),
                                                  SizedBox(
                                                    height: h * .02,
                                                  ),
                                                  //email
                                                  Container(
                                                    height: h * .06,
                                                    width: largeScreen
                                                        ? w * .7
                                                        : w * .6,
                                                    child: TextFormFieldWidget(
                                                      controller:
                                                          emailController,
                                                      validate: true,
                                                      errorText:
                                                          "* ${S.of(context).requiredFiled}",
                                                      hintText: S
                                                          .of(context)
                                                          .emailTitleSignUpWithEmail,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: h * .02,
                                                  ),
                                                  //hometownLocation
                                                  Container(
                                                    height: h * .06,
                                                    width: w * .7,
                                                    child: TextFormFieldWidget(
                                                      validate: true,
                                                      errorText:
                                                          "* ${S.of(context).requiredFiled}",
                                                      hintText: S
                                                          .of(context)
                                                          .createProfileHomeTwonHintText,
                                                      func: () {
                                                        showDialog(
                                                            context: _scaffoldKey
                                                                .currentContext,
                                                            builder:
                                                                (dialogcontext) {
                                                              return Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0)),
                                                                elevation: 0.0,
                                                                child:
                                                                    CreateLocation(
                                                                  current:
                                                                      false,
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      controller: Provider.of<
                                                          CreateLocationProvider>(
                                                        context,
                                                      ).homeTownLocation,
                                                    ),
                                                  ),
                                                  alertBox(S
                                                      .of(context)
                                                      .spellHomeTwon),
                                                  SizedBox(
                                                    height: h * .02,
                                                  ),
                                                  //currentlocation
                                                  Container(
                                                      height: h * .06,
                                                      width: w * .7,
                                                      child:
                                                          TextFormFieldWidget(
                                                        validate: true,
                                                        errorText:
                                                            "* ${S.of(context).requiredFiled}",
                                                        hintText: S
                                                            .of(context)
                                                            .createProfilecurrentCityHintText,
                                                        func: () {
                                                          showDialog(
                                                              context: _scaffoldKey
                                                                  .currentContext,
                                                              builder:
                                                                  (dialogcontext) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0)),
                                                                  elevation:
                                                                      0.0,
                                                                  child:
                                                                      CreateLocation(
                                                                    current:
                                                                        true,
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        controller: Provider.of<
                                                            CreateLocationProvider>(
                                                          context,
                                                        ).currentLocationController,
                                                      )),
                                                  alertBox(S
                                                      .of(context)
                                                      .spellCurrentLocation),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: w * .05,
                                            ),
                                            Container(
                                              width: w * .35,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: h * .02,
                                                      ),
                                                      passWordTextField(
                                                        passwordController,
                                                        S
                                                            .of(context)
                                                            .hintTextPasswordSignUpWithEmail,
                                                      ),
                                                      alertBox(S
                                                          .of(context)
                                                          .passwordConditions),
                                                      SizedBox(
                                                          height: h * 0.01),
                                                      passWordTextField(
                                                        confirmpassword,
                                                        S
                                                            .of(context)
                                                            .hintTextConfirmPasswordSignUpWithEmail,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15.0,
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .genderSignUpWithEmail,
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.blue,
                                                            fontFamily:
                                                                "SPProtext",
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: h * .05,
                                                        width: largeScreen
                                                            ? w * .4
                                                            : w * .5,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            HoverWidget(
                                                                child:
                                                                    maleButton(
                                                                        false),
                                                                hoverChild:
                                                                    maleButton(
                                                                        true),
                                                                onHover:
                                                                    (onHover) {}),
                                                            HoverWidget(
                                                                child:
                                                                    femaleButton(
                                                                        false),
                                                                hoverChild:
                                                                    femaleButton(
                                                                        true),
                                                                onHover:
                                                                    (onHover) {})
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15.0,
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .subtitleJournalistSignUpWorkSpace,
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.blue,
                                                            fontFamily:
                                                                "SPProtext",
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: h * .06,
                                                        width: largeScreen
                                                            ? w * .7
                                                            : w * .6,
                                                        child:
                                                            TextFormFieldWidget(
                                                          controller:
                                                              typeAheadController,
                                                          validate: false,
                                                          hintText: S
                                                              .of(context)
                                                              .subtitleJournalistSignUpWorkSpace,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15.0,
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .subtitleJournalistSignUpBirthday,
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.blue,
                                                            fontFamily:
                                                                "SPProtext",
                                                          ),
                                                        ),
                                                      ),
                                                      birthdayTextField(),
                                                      alertBox(S
                                                          .of(context)
                                                          .birthDayCondition),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0,
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                          S.of(context).phone,
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.blue,
                                                            fontFamily:
                                                                "SPProtext",
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: w * .7,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              height: h * .06,
                                                              width: w * .07,
                                                              child:
                                                                  TextFormFieldWidget(
                                                                validate: true,
                                                                errorText:
                                                                    "* ${S.of(context).requiredFiled}",
                                                                controller:
                                                                    phone1Controller,
                                                                hintText:
                                                                    "+xxx",
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                height: h * .06,
                                                                child: TextFormFieldWidget(
                                                                    validate:
                                                                        true,
                                                                    errorText:
                                                                        "* ${S.of(context).requiredFiled}",
                                                                    controller:
                                                                        phone2Controller,
                                                                    hintText: S
                                                                        .of(context)
                                                                        .phoneNumber),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                loading
                                    ? Container(
                                        height: h * .85,
                                        width: mediumScreen ? w * .8 : w * .72,
                                        color:
                                            Colors.grey[300].withOpacity(0.3),
                                        child: Center(
                                          child: SpinKitThreeBounce(
                                            color: Colors.black,
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
                      )
                    :

                    //Second Half
                    Expanded(
                        child: Center(
                            child: Stack(
                          children: [
                            Container(
                              height: h * .8,
                              width: w * .8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[400]),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: h * .02,
                                    ),
                                    Container(
                                      height: h * .06,
                                      width: w * .6,
                                      child: TextFormFieldWidget(
                                        controller: firstnameController,
                                        validate: false,
                                        hintText:
                                            S.of(context).firstAndMiddleName,
                                      ),
                                    ),
                                    alertBox(
                                      S.of(context).spellYourName,
                                    ),
                                    SizedBox(
                                      height: h * .02,
                                    ),
                                    Container(
                                      height: h * .06,
                                      width: w * .6,
                                      child: TextFormFieldWidget(
                                        controller: lastnameController,
                                        validate: false,
                                        hintText:
                                            S.of(context).fullLegalLastName,
                                      ),
                                    ),
                                    alertBox(S.of(context).spellYourName),
                                    SizedBox(
                                      height: h * .02,
                                    ),
                                    Container(
                                      height: h * .06,
                                      width: w * .6,
                                      child: TextFormFieldWidget(
                                        controller: emailController,
                                        validate: false,
                                        hintText: S
                                            .of(context)
                                            .emailTitleSignUpWithEmail,
                                      ),
                                    ),
                                    SizedBox(
                                      height: h * .02,
                                    ),
                                    Container(
                                      height: h * .06,
                                      width: w * .6,
                                      child: TextFormFieldWidget(
                                        func: () {
                                          showDialog(
                                              context:
                                                  _scaffoldKey.currentContext,
                                              builder: (context) {
                                                return Dialog();
                                              });
                                        },
                                        controller: homelocationController,
                                        validate: false,
                                        hintText: S
                                            .of(context)
                                            .createProfileHomeTwonHintText,
                                      ),
                                    ),
                                    alertBox(S.of(context).spellHomeTwon),
                                    SizedBox(
                                      height: h * .02,
                                    ),
                                    Container(
                                      height: h * .06,
                                      width: w * .6,
                                      child: TextFormFieldWidget(
                                        controller: currentlocationController,
                                        validate: false,
                                        hintText: S
                                            .of(context)
                                            .locationTitleSignUpWithEmail,
                                      ),
                                    ),
                                    alertBox(
                                        S.of(context).spellCurrentLocation),
                                    SizedBox(
                                      height: h * .02,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 10.0),
                                      child: Text(
                                        S
                                            .of(context)
                                            .subtitleJournalistSignUpWorkSpace,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontFamily: "SPProtext",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: h * .06,
                                      width: w * .6,
                                      child: TextFormFieldWidget(
                                        controller: typeAheadController,
                                        validate: false,
                                        hintText: S
                                            .of(context)
                                            .subtitleJournalistSignUpWorkSpace,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 10.0),
                                      child: Text(
                                        S
                                            .of(context)
                                            .subtitleJournalistSignUpBirthday,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontFamily: "SPProtext",
                                        ),
                                      ),
                                    ),
                                    birthdayTextField(),
                                    alertBox(S.of(context).birthDayCondition),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 10.0),
                                      child: Text(
                                        S.of(context).phone,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontFamily: "SPProtext",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: h * .06,
                                            width: w * .17,
                                            child: TextFormFieldWidget(
                                              controller: phone1Controller,
                                              hintText: "+xxx",
                                            ),
                                          ),
                                          Container(
                                            width: w * .45,
                                            height: h * .06,
                                            child: TextFormFieldWidget(
                                              controller: phone2Controller,
                                              hintText:
                                                  S.of(context).phoneNumber,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            loading
                                ? Container(
                                    height: h * .8,
                                    width: largeScreen ? w * .72 : w * .8,
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
                        )),
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
