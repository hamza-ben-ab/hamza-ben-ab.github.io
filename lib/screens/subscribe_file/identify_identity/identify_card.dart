import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/onboarding_file/review.dart';
import 'package:uy/screens/subscribe_file/identify_identity/selfi_upload.dart';

import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/screens/search/hover.dart';

class IdentifyCard extends StatefulWidget {
  final String title;
  final String des;
  final String fontSide;
  final String backSide;
  final String fontSideDes;
  final String backSideDes;

  const IdentifyCard(
      {Key key,
      this.title,
      this.des,
      this.fontSide,
      this.backSide,
      this.fontSideDes,
      this.backSideDes})
      : super(key: key);

  @override
  _IdentifyCardState createState() => _IdentifyCardState();
}

class _IdentifyCardState extends State<IdentifyCard> {
  //variable

  String firstSide;
  String secondSide;
  bool loadingFontSide = false;
  bool loadingBackSide = false;
  double percentage = 0.0;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String idKind;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  Widget deleteButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .04,
      width: h * .04,
      child: Center(
        child: Icon(
          LineAwesomeIcons.times_circle,
          color: Colors.black,
          size: 20.0,
        ),
      ),
      decoration: BoxDecoration(
        color: hover ? Colors.grey[100] : Colors.grey[50],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget chooseOtherOption(bool hover) {
    return Text(
      S.of(context).chooseOtherOption,
      style: TextStyle(
        color: hover ? Colors.blue : Colors.grey[700],
        fontFamily: "SPProtext",
        fontSize: 14.0,
      ),
    ).xShowPointerOnHover;
  }

  Widget continueButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    final locationProvider = Provider.of<CreateLocationProvider>(context);
    return firstSide != null && secondSide != null
        ? InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              users.doc(currentUser.uid).set({
                "firstName": prefs.getString("first_name").toString(),
                "lastName": prefs.getString("last_name").toString(),
                "password": prefs.getString("password").toString(),
                "email": prefs.getString("email").toString(),
                "currentLocation":
                    locationProvider.currentLocationController.text.trim(),
                "homeTownLocation":
                    locationProvider.homeTownLocation.text.trim(),
                "workspace": prefs.getString("workSpace").toString(),
                "birthday": prefs.getString("birthday").toString(),
                "Gender": prefs.getString("gender").toString(),
                "phone": prefs.getString("phone").toString(),
                "kind": prefs.getString("userKind").toString(),
                "journalistKind": prefs.getString("journalistKind").toString(),
                "identify_type": prefs.getString("identify_type"),
                "identify_country": prefs.getString("identify_country"),
                "active": false,
                "font_side": firstSide,
                "back_side": secondSide,
                "firstTime": false
              }, SetOptions(merge: true));

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReviewPage()),
              );
            },
            child: Container(
              height: h * .06,
              width: largeScreen ? w * .2 : w * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: hover ? Colors.blue[800] : Colors.blue),
              child: Center(
                child: Text(
                  S.of(context).confirmButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext",
                    fontSize: largeScreen ? 18.0 : 14.0,
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: h * .06,
            width: largeScreen ? w * .2 : w * .4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[200]),
            child: Center(
              child: Text(
                S.of(context).confirmButton,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontFamily: "SPProtext",
                  fontSize: largeScreen ? 18.0 : 14.0,
                ),
              ),
            ),
          );
  }

  Future filePickerFontSide(BuildContext context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Id/")
          .child("fontSide/$filename");
      final firebase_storage.UploadTask uploadTask = storageRef.putData(file);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            setState(() {
              loadingFontSide = true;
              uploadTask.snapshotEvents.listen((event) {
                percentage =
                    (event.bytesTransferred.toDouble() / event.totalBytes);
              });
            });
          } else if (snapshot.state == TaskState.success) {
            setState(() {
              loadingFontSide = false;
            });
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        firstSide = dowurl.toString();
      });
    }
  }

  Future filePickerBackSide(BuildContext context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Id/")
          .child("backSide/$filename");
      final firebase_storage.UploadTask uploadTask = storageRef.putData(file);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            setState(() {
              loadingBackSide = true;
              uploadTask.snapshotEvents.listen((event) {
                percentage =
                    (event.bytesTransferred.toDouble() / event.totalBytes);
              });
            });
          } else if (snapshot.state == TaskState.success) {
            setState(() {
              loadingBackSide = false;
            });
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        secondSide = dowurl.toString();
      });
    }
  }

  Widget chooseButtonFontSide(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        filePickerFontSide(context);
      },
      child: Container(
        height: h * 0.06,
        width: largeScreen ? w * 0.1 : w * .3,
        child: Center(
          child: Text(
            S.of(context).chooseFile,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.blue[700] : Colors.blue,
        ),
      ),
    );
  }

  Widget chooseButtonBackSide(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        filePickerBackSide(context);
      },
      child: Container(
        height: h * 0.06,
        width: largeScreen ? w * 0.1 : w * .3,
        child: Center(
          child: Text(
            S.of(context).chooseFile,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.blue[700] : Colors.blue,
        ),
      ),
    );
  }

  Widget uploadFirstSideWidget(String title, String des) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    //bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return firstSide == null
        ? Container(
            width: w * .15,
            height: h * .4,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), color: Colors.white),
            child: !loadingFontSide
                ? Container(
                    height: h * .4,
                    width: w * .15,
                    child: Column(
                      children: [
                        SizedBox(
                          height: h * .05,
                        ),
                        Icon(LineAwesomeIcons.file_upload,
                            color: accentColor, size: 50.0),
                        SizedBox(
                          height: h * .03,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "SPProtext",
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: h * .02,
                        ),
                        Text(
                          des,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: "SPProtext",
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: h * .05,
                        ),
                        HoverWidget(
                            child: chooseButtonFontSide(false),
                            hoverChild: chooseButtonFontSide(true),
                            onHover: (onHover) {})
                      ],
                    ),
                  )
                : Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: percentage,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xFF33CC33)),
                        backgroundColor: Color(0xffD6D6D6),
                      ),
                    ),
                  ),
          )
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                height: h * .4,
                width: w * .15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Container(
                    height: h * .4,
                    width: w * .15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(firstSide).image),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 30.0,
                top: 10.0,
                child: InkWell(
                  onTap: () async {
                    createPostAllFunctions.deleteFireBaseStorageItem(firstSide);

                    setState(() {
                      firstSide = null;
                      loadingFontSide = false;
                    });
                  },
                  child: HoverWidget(
                    child: deleteButtonWidget(false),
                    hoverChild: deleteButtonWidget(true),
                    onHover: (onHover) {},
                  ),
                ),
              )
            ],
          );
  }

  Widget uploadBackSideWidget(String title, String des) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return secondSide == null
        ? Container(
            width: w * .15,
            height: h * .4,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: !loadingBackSide
                ? Container(
                    height: h * .4,
                    width: w * .15,
                    child: Column(
                      children: [
                        SizedBox(
                          height: h * .05,
                        ),
                        Icon(LineAwesomeIcons.file_upload,
                            color: accentColor, size: 50.0),
                        SizedBox(
                          height: h * .03,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "SPProtext",
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: h * .02,
                        ),
                        Text(
                          des,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: "SPProtext",
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: h * .05,
                        ),
                        HoverWidget(
                            child: chooseButtonBackSide(false),
                            hoverChild: chooseButtonBackSide(true),
                            onHover: (onHover) {})
                      ],
                    ),
                  )
                : Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: percentage,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xFF33CC33)),
                        backgroundColor: Color(0xffD6D6D6),
                      ),
                    ),
                  ),
          )
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                height: h * .4,
                width: w * .15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Container(
                    height: h * .4,
                    width: w * .15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(secondSide).image),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 30.0,
                top: 10.0,
                child: InkWell(
                  onTap: () async {
                    createPostAllFunctions
                        .deleteFireBaseStorageItem(secondSide);

                    setState(() {
                      secondSide = null;
                      loadingBackSide = false;
                    });
                  },
                  child: HoverWidget(
                    child: deleteButtonWidget(false),
                    hoverChild: deleteButtonWidget(true),
                    onHover: (onHover) {},
                  ),
                ),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Column(
      children: [
        Container(
          width: w * .7,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
        ),
        Container(
          width: largeScreen ? w * .4 : w * .6,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Center(
            child: Text(
              widget.des,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontFamily: "SPProtext",
              ),
            ),
          ),
        ),
        SizedBox(
          height: h * .02,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                uploadFirstSideWidget(widget.fontSide, widget.fontSideDes),
                uploadBackSideWidget(widget.backSide, widget.backSideDes),
                SelfiUpload()
              ],
            ),
          ),
        ),
        SizedBox(
          height: h * .02,
        ),
        HoverWidget(
          child: continueButtonWidget(false),
          hoverChild: continueButtonWidget(true),
          onHover: (onHover) {},
        ),
        SizedBox(
          height: h * .02,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("/VerifyYourIdentity");
          },
          child: HoverWidget(
              child: chooseOtherOption(false),
              hoverChild: chooseOtherOption(true),
              onHover: (onHover) {}),
        ),
      ],
    );
  }
}
