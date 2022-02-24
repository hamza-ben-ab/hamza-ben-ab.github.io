import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:uy/screens/constant.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/loading_widget/menu_loading.dart';
import 'package:uy/screens/login_page/lang_items.dart';
import 'package:uy/screens/menu/edit_location/edit_location.dart';
import 'package:uy/screens/profile/profile_image_widget.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/services/place_service/main_maps.dart';
import 'package:uy/services/place_service/model/place.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/current_position_provider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/provider/right_bar_provider.dart';
import 'package:uy/services/provider/settings_provider.dart';
import 'package:uy/widget/toast.dart';

class MenuListButton extends StatefulWidget {
  const MenuListButton({Key key}) : super(key: key);

  @override
  _MenuListButtonState createState() => _MenuListButtonState();
}

class _MenuListButtonState extends State<MenuListButton> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController newEmailController = TextEditingController();
  TextEditingController newPassWordController = TextEditingController();
  TextEditingController confirmNewPassWordController = TextEditingController();
  TextEditingController currentPassWordController = TextEditingController();
  TextEditingController homeTwonLocationController = TextEditingController();
  bool add = false;
  bool tape = false;
  TeltrueWidget toast = TeltrueWidget();
  String genderValue;
  FToast fToast;

  getStringGender() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    if (doc.data()["Gender"] == "male") {
      setState(() {
        genderValue = "male";
      });
    } else {
      setState(() {
        genderValue = "women";
      });
    }
  }

  Widget menuPartOne(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(currentUser.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> doc = snapshot.data.data();
            return InkWell(
              onTap: doc["kind"] == "Journalist"
                  ? () {
                      Provider.of<HideLeftBarProvider>(context, listen: false)
                          .closeleftBar();
                      Provider.of<CenterBoxProvider>(context, listen: false)
                          .changeCurrentIndex(7);
                      Provider.of<ProfileProvider>(context, listen: false)
                          .changeProfileId(currentUser.uid);
                      Provider.of<RightBarProvider>(context, listen: false)
                          .changeIndex(0);
                    }
                  : () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 0.0,
                              child: readerProfile(
                                  doc["image"],
                                  doc["full_name"],
                                  doc["location"],
                                  doc["homeLocation"],
                                  currentUser.uid),
                            );
                          });
                    },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                width: w * .22,
                height: h * .095,
                decoration: BoxDecoration(
                  color: !hover ? Colors.white : Colors.grey[300],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      height: h * .08,
                      width: h * .08,
                      decoration: BoxDecoration(
                        image: doc["image"] == "" && genderValue == "male"
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.asset("./assets/images/man.png")
                                    .image)
                            : doc["image"] == "" && genderValue == "women"
                                ? DecorationImage(
                                    image:
                                        Image.asset("./assets/images/women.png")
                                            .image)
                                : DecorationImage(
                                    image: Image.network(doc["image"]).image),
                        borderRadius: intl.Bidi.detectRtlDirectionality(
                                S.of(context).postViewWrittenBy)
                            ? BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              )
                            : BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${doc["firstName"]} ${doc["lastName"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "SPProtext"),
                            ),
                            Text(
                              S.of(context).seeYourProfile,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SPProtext"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).xShowPointerOnHover;
          }
          return menuPartOneLoading(h, w);
        });
  }

  Widget deleteButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      child: Center(
        child: Icon(
          LineAwesomeIcons.times_circle,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      decoration: BoxDecoration(
          color: hover ? Colors.red[500] : Colors.red[700],
          borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget readerProfile(String image, String name, String currentLocation,
      String homeLocation, String userId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .6,
      width: w * .25,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * .07,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: HoverWidget(
                      child: deleteButtonWidget(false),
                      hoverChild: deleteButtonWidget(true),
                      onHover: (onHover) {},
                    ),
                  ),
                ],
              ),
            ),
            ProfileImageWidget(
              profileImage: image,
              userId: userId,
            ),
            SizedBox(
              height: h * .02,
            ),
            Container(
              width: w * .25,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SPProtext",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * .02,
            ),
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                "./assets/icons/placeholder.svg",
                height: 25.0,
                width: 25.0,
                color: Colors.grey[600],
              ),
              label: Text(
                currentLocation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                  fontFamily: "SPProtext",
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                "./assets/icons/placeholder.svg",
                height: 25.0,
                width: 25.0,
                color: Colors.grey[600],
              ),
              label: Text(
                homeLocation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                  fontFamily: "SPProtext",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuPartTwo(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        // border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Provider.of<SettingProvider>(context, listen: false).goToPage(1);
        },
        title: Text(
          S.of(context).accountMenuProfileSetting,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset(
          "./assets/icons/174-settings.svg",
          height: 20.0,
          width: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget menuPartFour(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        // border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {},
        title: Text(
          S.of(context).helpAndSupport,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset("./assets/icons/160-question.svg",
            height: 20.0, width: 20.0, color: Colors.blue),
      ),
    );
  }

  Widget menuPartFive(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        //border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () async {
          await FirebaseAuth.instance
              .signOut()
              .then((value) => Navigator.of(context).pushNamed("/LogIn"));
        },
        title: Text(
          S.of(context).accountMenuLogOut,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset("./assets/icons/108-logout.svg",
            height: 20.0, width: 20.0, color: Colors.blue),
      ),
    );
  }

  Widget goBackWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? Colors.orange[400] : Colors.orange[300],
      ),
      child: Center(
        child: Icon(
          LineAwesomeIcons.angle_left,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget settingAccountContact(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        // border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Provider.of<SettingProvider>(context, listen: false).goToPage(2);
        },
        title: Text(
          S.of(context).accountEmail,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //  fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset(
          "./assets/icons/012-arroba.svg",
          height: 20.0,
          width: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget settingAccountPass(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        // border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Provider.of<SettingProvider>(context, listen: false).goToPage(3);
        },
        title: Text(
          S.of(context).changePassword,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //  fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset(
          "./assets/icons/105-padlock.svg",
          height: 20.0,
          width: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget settingAccountLocation(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        //  border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Provider.of<SettingProvider>(context, listen: false).goToPage(4);
        },
        title: Text(
          S.of(context).location,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset(
          "./assets/icons/placeholder.svg",
          height: 20.0,
          width: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget setCurrentLocation(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        //  border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Provider.of<SettingProvider>(context, listen: false).goToPage(6);
        },
        title: Text(
          S.of(context).createProfilecurrentCityHintText,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset(
          "./assets/icons/placeholder.svg",
          height: 20.0,
          width: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget setHomeTownLocation(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        //  border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Provider.of<SettingProvider>(context, listen: false).goToPage(7);
        },
        title: Text(
          S.of(context).createProfileHomeTwonHintText,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset(
          "./assets/icons/placeholder.svg",
          height: 20.0,
          width: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget settingAccountLanguage(bool hover) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: w * .22,
      decoration: BoxDecoration(
        // border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
        color: !hover ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          Provider.of<SettingProvider>(context, listen: false).goToPage(5);
        },
        title: Text(
          S.of(context).language,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              //fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        ),
        trailing: SvgPicture.asset(
          "./assets/icons/083-worldwide.svg",
          height: 20.0,
          width: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget goToPreviousPage(int index, String title) {
    double h = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: h * .06,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Provider.of<SettingProvider>(context, listen: false)
                    .goToPage(index);
                setState(() {
                  tape = false;
                  add = false;
                });
              },
              child: HoverWidget(
                child: goBackWidget(false),
                hoverChild: goBackWidget(true),
                onHover: (onHover) {},
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.w500,
                fontSize: 14.0,
                fontFamily: "SPProtext",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
        height: h * .05,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: hover
              ? buttonColorHover
              : !tape && add
                  ? Colors.grey[400]
                  : buttonColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: tape && !add
            ? Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 15.0,
                ),
              )
            : !tape && add
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).doneButton,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: "SPProtext",
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(LineAwesomeIcons.check, color: Colors.white),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).addButton,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontFamily: "SPProtext"),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(LineAwesomeIcons.plus, color: Colors.white),
                    ],
                  ));
  }

  Widget accountEmailDetails() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Container(
            width: w * .22,
            child: Text(
              S.of(context).newEmailDescription,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: w * .22,
            height: h * .05,
            child: TextFormFieldWidget(
              controller: newEmailController,
              hintText: S.of(context).newEmail,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  setState(() {
                    tape = true;
                  });
                  DocumentSnapshot doc = await users.doc(currentUser.uid).get();

                  var credential = EmailAuthProvider.credential(
                    email: currentUser.email,
                    password: doc.data()["password"],
                  );
                  await currentUser.reauthenticateWithCredential(credential);
                  await currentUser.updateEmail(newEmailController.text);
                  setState(() {
                    tape = false;
                    add = true;
                  });
                },
                child: HoverWidget(
                    child: addButton(false),
                    hoverChild: addButton(true),
                    onHover: (onHover) {}),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget currentPassWord() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: h * .055,
      width: w * .22,
      child: TextFormField(
        style: TextStyle(
            color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
        textAlign: TextAlign.center,
        controller: currentPassWordController,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 14,
            height: 0.6,
          ),
          isDense: true,
          alignLabelWithHint: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: Colors.white,
          filled: true,
          labelText: S.of(context).currentPassword,
          hintText: S.of(context).currentPassword,
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
              intl.Bidi.detectRtlDirectionality(S.of(context).currentPassword)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
        ),
        obscureText: true,
      ),
    );
  }

  Widget createNewPassWord() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .055,
      width: w * .22,
      child: TextFormField(
        style: TextStyle(
            color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
        textAlign: TextAlign.center,
        controller: newPassWordController,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 14,
            height: 0.6,
          ),
          isDense: true,
          alignLabelWithHint: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: Colors.white,
          filled: true,
          labelText: S.of(context).hintTextNewPassword,
          hintText: S.of(context).hintTextNewPassword,
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
                  S.of(context).hintTextNewPassword)
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
        obscureText: true,
      ),
    );
  }

  Widget confirmNewPassWord() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: h * .055,
      width: w * .22,
      child: TextFormField(
        style: TextStyle(
            color: Colors.black, fontSize: 17.0, fontFamily: "SPProtext"),
        textAlign: TextAlign.center,
        controller: confirmNewPassWordController,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 14,
            height: 0.6,
          ),
          isDense: true,
          alignLabelWithHint: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: Colors.white,
          filled: true,
          labelText: S.of(context).hintTextConfirmNewPassword,
          hintText: S.of(context).hintTextConfirmNewPassword,
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
                  S.of(context).hintTextConfirmNewPassword)
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
        obscureText: true,
      ),
    );
  }

  void changePassWord() async {
    setState(() {
      tape = true;
    });
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    var credential = EmailAuthProvider.credential(
      email: doc.data()["email"],
      password: doc.data()["password"],
    );

    await currentUser.reauthenticateWithCredential(credential);
    await currentUser.updatePassword(confirmNewPassWordController.text);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .update({"password": confirmNewPassWordController.text});

    setState(() {
      tape = false;
      add = true;
    });
  }

  Widget resetButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        setState(() {
          tape = true;
          add = false;
        });
        DocumentSnapshot doc = await users.doc(currentUser.uid).get();
        String currentPassword = doc.data()["password"];

        if (newPassWordController.text.trim() ==
                confirmNewPassWordController.text.trim() &&
            currentPassword == currentPassWordController.text.trim()) {
          changePassWord();
          setState(() {
            add = true;
            tape = false;
          });
        } else {
          setState(() {
            tape = false;
            add = false;
          });

          if (currentPassWordController.text.trim() != currentPassword) {
            return toast.showToast(
              S.of(context).currentPassIsWrong,
              fToast,
              Colors.red[400],
            );
          } else if (newPassWordController.text !=
              confirmNewPassWordController.text) {
            return toast.showToast(
              S.of(context).taostConfirmThePassWord,
              fToast,
              Colors.red[400],
            );
          } else if (confirmNewPassWordController.text.length < 8) {
            return toast.showToast(
              S.of(context).passWordCondition,
              fToast,
              Colors.red[400],
            );
          }
        }
      },
      child: Container(
        height: h * .05,
        width: w * .1,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: hover
              ? button2ColorHover
              : !tape && add
                  ? Colors.grey[400]
                  : button2Color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: tape && !add
            ? Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 15.0,
                ),
              )
            : !tape && add
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).doneButton,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: "SPProtext",
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(LineAwesomeIcons.check, color: Colors.white),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).doneButton,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontFamily: "SPProtext"),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(LineAwesomeIcons.redo, color: Colors.white),
                    ],
                  ),
      ),
    );
  }

  @override
  void initState() {
    getStringGender();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int page = Provider.of<SettingProvider>(context).page;

    return page == 0
        ? Directionality(
            textDirection:
                intl.Bidi.detectRtlDirectionality(S.of(context).account)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            child: Column(
              children: [
                HoverWidget(
                    child: menuPartOne(false),
                    hoverChild: menuPartOne(true),
                    onHover: (event) {}),
                HoverWidget(
                    child: menuPartTwo(false),
                    hoverChild: menuPartTwo(true),
                    onHover: (event) {}),
                HoverWidget(
                    child: menuPartFour(false),
                    hoverChild: menuPartFour(true),
                    onHover: (event) {}),
                HoverWidget(
                    child: menuPartFive(false),
                    hoverChild: menuPartFive(true),
                    onHover: (event) {}),
              ],
            ),
          )
        : page == 1
            ? Directionality(
                textDirection:
                    intl.Bidi.detectRtlDirectionality(S.of(context).account)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      goToPreviousPage(
                          0, S.of(context).accountMenuProfileSetting),
                      HoverWidget(
                        child: settingAccountContact(false),
                        hoverChild: settingAccountContact(true),
                        onHover: (event) {},
                      ),
                      HoverWidget(
                        child: settingAccountPass(false),
                        hoverChild: settingAccountPass(true),
                        onHover: (event) {},
                      ),
                      HoverWidget(
                        child: settingAccountLocation(false),
                        hoverChild: settingAccountLocation(true),
                        onHover: (event) {},
                      ),
                      HoverWidget(
                        child: settingAccountLanguage(false),
                        hoverChild: settingAccountLanguage(true),
                        onHover: (event) {},
                      ),
                    ],
                  ),
                ),
              )
            : page == 2
                ? Directionality(
                    textDirection:
                        intl.Bidi.detectRtlDirectionality(S.of(context).account)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          goToPreviousPage(
                            1,
                            S.of(context).accountEmail,
                          ),
                          accountEmailDetails(),
                        ],
                      ),
                    ),
                  )
                : page == 3
                    ? Directionality(
                        textDirection: intl.Bidi.detectRtlDirectionality(
                                S.of(context).account)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              goToPreviousPage(
                                1,
                                S.of(context).changePassword,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              currentPassWord(),
                              SizedBox(
                                height: 15.0,
                              ),
                              createNewPassWord(),
                              SizedBox(
                                height: 15.0,
                              ),
                              confirmNewPassWord(),
                              SizedBox(
                                height: 20.0,
                              ),
                              HoverWidget(
                                child: resetButton(false),
                                hoverChild: resetButton(true),
                                onHover: (onHover) {},
                              )
                            ],
                          ),
                        ),
                      )
                    : page == 4
                        ? Directionality(
                            textDirection: intl.Bidi.detectRtlDirectionality(
                                    S.of(context).account)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  goToPreviousPage(
                                    1,
                                    S.of(context).location,
                                  ),
                                  HoverWidget(
                                    child: setCurrentLocation(false),
                                    hoverChild: setCurrentLocation(true),
                                    onHover: (event) {},
                                  ),
                                  HoverWidget(
                                    child: setHomeTownLocation(false),
                                    hoverChild: setHomeTownLocation(true),
                                    onHover: (event) {},
                                  ),
                                ],
                              ),
                            ),
                          )
                        : page == 5
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  children: [
                                    goToPreviousPage(
                                      1,
                                      S.of(context).language,
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    languageList()
                                  ],
                                ),
                              )
                            : page == 6
                                ? EditLocation(
                                    current: true,
                                  )
                                : page == 7
                                    ? EditLocation(
                                        current: false,
                                      )
                                    : Column();
  }

  Widget languageItemHover(String title) {
    return HoverWidget(
      child: LangItem(
        width: .1,
        title: title,
        hover: false,
      ),
      hoverChild: LangItem(
        width: .1,
        title: title,
        hover: true,
      ),
      onHover: (onHover) {},
    );
  }

  Widget languageList() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w * .24,
      height: h * .7,
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            runSpacing: 10.0,
            spacing: 10.0,
            children: [
              languageItemHover("Arabic"),
              languageItemHover("Bengali-বাংলা"),
              languageItemHover("German-Deutsche"),
              languageItemHover("Greek-Ελληνικά"),
              languageItemHover("English"),
              languageItemHover("Spanish"),
              languageItemHover("French"),
              languageItemHover("Hindi-हिंदी"),
              languageItemHover("Indonesian-bahasa Indonesia"),
              languageItemHover("Italian"),
              languageItemHover("Japanese-日本語"),
              languageItemHover("Korean-한국어"),
              languageItemHover("Panjabi-ਪੰਜਾਬੀ"),
              languageItemHover("Portuguese"),
              languageItemHover("Russian"),
              languageItemHover("Turkish"),
              languageItemHover("Chinese-中国人"),
            ]),
      ),
    );
  }
}
