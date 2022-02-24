import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uy/screens/home/home_View.dart';
import 'package:uy/services/responsiveLayout.dart';

class GoogleLogin extends StatefulWidget {
  final bool hover;
  const GoogleLogin({Key key, this.hover}) : super(key: key);

  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    UserCredential user =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);

    User currentUser = FirebaseAuth.instance.currentUser;
    final User userId = user.user;

    if (user != null) {
      assert(currentUser.uid != null);
      assert(currentUser.email != null);

      assert(!currentUser.isAnonymous);
      assert(await currentUser.getIdToken() != null);

      FirebaseFirestore.instance.collection("Users").doc(userId.uid).set({
        "full_name": userId.displayName,
        "email": userId.email,
        "image": userId.photoURL,
        "kind": "reader",
        "uid": userId.uid,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        signInWithGoogle();
      },
      child: Container(
        height: h * .06,
        width: largeScreen ? w * .4 : w * .6,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: widget.hover ? Colors.grey[300] : Colors.grey[200]),
        child: Row(
          children: [
            Container(
              height: h * .05,
              width: h * .05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    "./assets/images/Google.png",
                    fit: BoxFit.cover,
                  ).image,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: h * .06,
                child: Center(
                  child: Text(
                    "Google",
                    style: TextStyle(
                      fontFamily: "SPProtext",
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: widget.hover ? Colors.blue : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
