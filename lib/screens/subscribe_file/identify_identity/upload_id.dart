import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/screens/subscribe_file/identify_identity/identify_card.dart';
import 'package:uy/screens/subscribe_file/identify_identity/passport_type.dart';
import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/responsiveLayout.dart';
//import 'package:intl/intl.dart' as intl;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class IdentifyIdentityUploadId extends StatefulWidget {
  const IdentifyIdentityUploadId({Key key}) : super(key: key);

  @override
  _IdentifyIdentityUploadIdState createState() =>
      _IdentifyIdentityUploadIdState();
}

class _IdentifyIdentityUploadIdState extends State<IdentifyIdentityUploadId> {
  String idFile;
  String firstSide;
  String secondSide;
  bool loading = false;
  double percentage = 0.0;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String idKind;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  Future getKindId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      idKind = sharedPreferences.getString("idKind").toString();
    });
  }

  @override
  void initState() {
    getKindId();
    super.initState();
  }

  Future filePicker(BuildContext context, String url) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Id/")
          .child("$filename");
      final firebase_storage.UploadTask uploadTask = storageRef.putData(file);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            setState(() {
              loading = true;
              uploadTask.snapshotEvents.listen((event) {
                percentage =
                    (event.bytesTransferred.toDouble() / event.totalBytes);
              });
            });
          } else if (snapshot.state == TaskState.success) {
            setState(() {
              loading = false;
            });
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        url = dowurl.toString();
      });
    }
  }

  Widget chooseButton(bool hover, String url) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        filePicker(context, url);
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

  Future sendMessage() async {
    var url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    var response = await http.post(
      url,
      headers: {
        "origin": "http://localhost",
        "Content-Type": "application/json"
      },
      body: json.encode({
        'service_id': 'service_damku6o',
        'template_id': 'template_7sg90bj',
        "user_id": "user_UIfOUgcih7hdH7Fkq8dKg",
        "template_params": {
          "user_name": "David Carlo",
          "user_birth": "17/02/1981",
          "user_homeTown": "Sfax, Tunisia",
          "user_currentTown": "Liverpool, UK",
          "user_email": "David@telltrue.com",
          "user_subject": "Identify request",
          "user_message":
              "You won't see many fireworks better than this on New Years Eve!!"
        }
      }),
    );
    print(response.body);
  }

  /* sendMail() async {
    final googleSignIn = GoogleSignIn(scopes: ["https://mail.google.com/"]);
    final user = await googleSignIn.signIn();
    String username = "telltrue.appnews@gmail.com";
    final auth = await user.authentication;
    String accessToken = auth.accessToken;
    var _emailTransport = gmailSaslXoauth2(username, accessToken);

    var _envelope = new Message()
      ..from = "telltrue.appnews@gmail.com"
      ..recipients.add("support@telltruenews.com")
      ..subject = '{Identity validation request}'
      ..attachments.add(FileAttachment(File('{FILE_PATH}')))
      ..text = '{PLAIN_TEXT_GOES_HERE}'
      ..html = '{HTML_CONTENT_GOES_HERE}';

    send(_envelope, _emailTransport)..then((envelope) => print('Email sent'));
  }*/

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            color: Colors.white,
            height: h,
            width: w,
            child: Column(
              children: [
                TeltrueAppBar(
                  backRoute: "/VerifyYourIdentity",
                  nextRouteTitle: S.of(context).nextButton,
                ),
                Expanded(
                  child: Center(
                      child: Stack(
                    children: [
                      Container(
                        height: h * .72,
                        width: largeScreen ? w * .5 : w * .5,
                        decoration: centerBoxDecoration,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: idKind == "1"
                            ? PassportTypeWidget()
                            : idKind == "2"
                                ? IdentifyCard(
                                    title: S.of(context).nationalId,
                                    des: S.of(context).nationalIdDes,
                                    fontSide:
                                        S.of(context).nationalIdFrontSideTitle,
                                    fontSideDes:
                                        S.of(context).nationalIdFrontSideDes,
                                    backSide:
                                        S.of(context).nationalIdBackSideTitle,
                                    backSideDes:
                                        S.of(context).nationalIdBackSideDes,
                                  )
                                : IdentifyCard(
                                    title: S.of(context).driversLicence,
                                    des: S.of(context).driverLicenceDes,
                                    fontSide: S
                                        .of(context)
                                        .driverLicenceFrontSideTitle,
                                    fontSideDes:
                                        S.of(context).driverLicenceFrontSideDes,
                                    backSide: S
                                        .of(context)
                                        .driverLicenceBackSideTitle,
                                    backSideDes:
                                        S.of(context).driverLicenceBackideDes),
                      ),
                      /* loading
                          ? Container(
                              height: h * .72,
                              width: largeScreen ? w * .4 : w * .5,
                              color: Colors.grey[300].withOpacity(0.3),
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
                            )*/
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
    return idFile == null
        ? InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              //sendMessage();
              setState(() {
                loading = true;
              });
              //sendMail();
              users.doc(currentUser.uid).set({
                "full_name":
                    "${prefs.getString("first_name")} ${prefs.getString("last_name")}",
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
                "identify_file": idFile,
              }, SetOptions(merge: true));
              setState(() {
                loading = false;
              });
              Navigator.of(context).pushNamed("/ReviewPage");
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
}
