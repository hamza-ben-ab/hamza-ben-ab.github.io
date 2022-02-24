import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uy/screens/login_page/app_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/screens/login_page/intro_widget.dart';
import 'package:uy/screens/login_page/login_widget.dart';
import 'package:uy/services/responsiveLayout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool largeScreen = false;
  CollectionReference collection;
  User currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(builder: (context) {
          return Container(
            width: w,
            height: h,
            color: Colors.white,
            child: Column(
              children: [
                LoginPageAppBar(),
                Expanded(
                  child: Center(
                    child: Container(
                      width: w,
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LoginPageIntro(),
                            LoginPageWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                BottomBarLoginWidget()
              ],
            ),
          );
        }),
      ),
    );
  }
}
