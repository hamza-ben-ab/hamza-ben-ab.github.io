import 'package:uy/screens/profile/centerBar_widget.dart';
import 'package:uy/screens/profile/profile_second_part.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:uy/screens/profile/profile_first_part.dart';
import 'package:uy/services/provider/profile_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
  }) : super(key: key);
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  _ProfileViewState();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference journalists =
      FirebaseFirestore.instance.collection('Users');
  ScrollController profileController = ScrollController();

  FToast fToast;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;

    return Container(
      margin: EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 10.0,
      ),
      width: w * .63,
      height: h * .91,
      child: Scrollbar(
        controller: profileController,
        isAlwaysShown: true,
        radius: Radius.circular(20.0),
        child: SingleChildScrollView(
          controller: profileController,
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: h * .01,
              ),
              FirstPart(),
              Divider(
                color: Colors.grey[400],
                endIndent: w * .2,
              ),
              ProfilCenterBar(),
              ProfileSecondPart(
                userId: userId,
              )
            ],
          ),
        ),
      ),
    );
  }
}
