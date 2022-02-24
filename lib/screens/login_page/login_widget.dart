import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/home/home_View.dart';
import 'package:uy/screens/login_page/facebookLogin.dart';
import 'package:uy/screens/login_page/google_login.dart';
import 'package:uy/screens/onboarding_file/add_profile_Journalist_image.dart';
import 'package:uy/screens/onboarding_file/review.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/home_partProvider.dart';
import 'package:uy/services/provider/right_bar_provider.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/widget/toast.dart';
import 'package:intl/intl.dart' as intl;

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key key}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  CollectionReference collection;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;
  bool loading = false;

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
    return Container(
      width: largeScreen ? w * .4 : w * .8,
      child: Center(
        child: Container(
          decoration: centerBoxDecoration,
          height: h * .6,
          width: largeScreen ? w * .25 : w * .8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _globalKey,
                child: Column(
                  children: [
                    Container(
                      height: h * .06,
                      width: largeScreen ? w * .22 : w * .6,
                      child: TextFormField(
                        textDirection: intl.Bidi.detectRtlDirectionality(
                                S.of(context).formIdentifierLoginPage)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        controller: emailController,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        maxLength: null,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: "SPProtext",
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 14,
                            height: 0.6,
                          ),
                          isDense: true,
                          alignLabelWithHint: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: S.of(context).formIdentifierLoginPage,
                          hintText: S.of(context).formIdentifierLoginPage,
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
                            borderSide:
                                BorderSide(color: Colors.grey[600], width: 0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[600], width: 0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[600], width: 0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[600],
                              width: 0.5,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          hintTextDirection: intl.Bidi.detectRtlDirectionality(
                                  S.of(context).formIdentifierLoginPage)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Container(
                      height: h * .06,
                      width: largeScreen ? w * .22 : w * .6,
                      child: TextFormField(
                        textDirection: intl.Bidi.detectRtlDirectionality(
                                S.of(context).formIdentifierLoginPage)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: "SPProtext",
                        ),
                        controller: passwordController,
                        onEditingComplete: () {
                          loginInFunction();
                        },
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: S.of(context).formPasswordLoginPage,
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
                            borderSide:
                                BorderSide(color: Colors.grey[600], width: 0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[600], width: 0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[600], width: 0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[600],
                              width: 0.5,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          hintTextDirection: intl.Bidi.detectRtlDirectionality(
                                  S.of(context).formPasswordLoginPage)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                  ],
                ),
              ),
              Text(
                S.of(context).onlyReaderOptionSignIn,
                style: TextStyle(color: Colors.black, fontFamily: "SPProtext"),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    //facebook_Button
                    HoverWidget(
                        child: FacebookLogin(
                          hover: false,
                        ),
                        hoverChild: FacebookLogin(
                          hover: true,
                        ),
                        onHover: (onHover) {}),
                    SizedBox(
                      height: 10.0,
                    ),
                    //Google_button
                    HoverWidget(
                        child: GoogleLogin(
                          hover: false,
                        ),
                        hoverChild: GoogleLogin(
                          hover: true,
                        ),
                        onHover: (onHover) {}),
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("/ForgetPassword");
                    },
                    child: HoverWidget(
                      child: forgetPasswordWidget(false),
                      hoverChild: forgetPasswordWidget(true),
                      onHover: (onHover) {},
                    ),
                  )
                ],
              ),
              SizedBox(
                height: h * 0.02,
              ),
              !loading
                  ? InkWell(
                      child: HoverWidget(
                        child: loginButtonWidget(false),
                        hoverChild: loginButtonWidget(true),
                        onHover: (onHover) {},
                      ),
                      onTap: () async {
                        loginInFunction();
                      },
                    )
                  : CircularProgressIndicator(
                      color: Colors.grey[400],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      height: h * .06,
      width: largeScreen ? w * .15 : w * .6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? buttonColorHover : buttonColor,
      ),
      child: !loading
          ? Center(
              child: Text(
                S.of(context).connectButtonLoginPage,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext"),
              ),
            )
          : Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 15.0,
              ),
            ),
    );
  }

  Widget forgetPasswordWidget(bool hover) {
    return Text(
      S.of(context).forgotPasswordLoginPage,
      style: TextStyle(
        color: hover ? Colors.blue : Colors.black,
        fontFamily: "SPProtext",
        fontSize: 14.0,
      ),
    );
  }

  void loginInFunction() async {
    if (emailController.text != null && passwordController.text != null) {
      setState(() {
        loading = true;
      });
      try {
        UserCredential user =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        String uid = user.user.uid;
        DocumentSnapshot doc = await users.doc(uid).get();

        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeCurrentIndex(0);
        Provider.of<RightBarProvider>(context, listen: false).changeIndex(0);
        Provider.of<HomePartIndexProvider>(context, listen: false)
            .changeIndex(0);
        Provider.of<HideLeftBarProvider>(context, listen: false).openLeftBar();

        doc.data()["kind"] == "reader"
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              )
            : doc.data()["kind"] == "Journalist" &&
                    doc.data()["active"] == true &&
                    doc.data()["firstTime"] == true
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  )
                : doc.data()["kind"] == "Journalist" &&
                        doc.data()["active"] == true &&
                        doc.data()["firstTime"] == false
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProfileJournalistImage()),
                      )
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ReviewPage()),
                      );
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading = false;
        });
        if (e.code == "user-not-found") {
          return toast.showToast(
              S.of(context).snackBarNoUserFound, fToast, Colors.red[400]);
        }
        if (e.code == "wrong-password") {
          return toast.showToast(
              S.of(context).snackBarWrongPassword, fToast, Colors.red[400]);
        }
      }
    }
  }
}
