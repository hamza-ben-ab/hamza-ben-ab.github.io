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
import 'package:uy/screens/subscribe_file/identify_identity/selfi_upload.dart';
import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/screens/search/hover.dart';

class PassportTypeWidget extends StatefulWidget {
  const PassportTypeWidget({Key key}) : super(key: key);

  @override
  _PassportTypeWidgetState createState() => _PassportTypeWidgetState();
}

class _PassportTypeWidgetState extends State<PassportTypeWidget> {
  //Variable
  String idFile;
  bool loadingPass = false;
  double percentage = 0.0;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String idKind;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  Widget passportUpload() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return idFile == null
        ? Container(
            width: w * .2,
            height: h * .4,
            child: !loadingPass
                ? Container(
                    height: h * .4,
                    width: w * .2,
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
                          S.of(context).passportUploadDes,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "SPProtext",
                            fontSize: largeScreen ? 18.0 : 14.0,
                          ),
                        ),
                        SizedBox(
                          height: h * .12,
                        ),
                        HoverWidget(
                            child: chooseButtonPass(false),
                            hoverChild: chooseButtonPass(true),
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
                          Color(0xFF33CC33),
                        ),
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
                width: w * .2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: Image.network(idFile).image),
                ),
              ),
              Positioned(
                right: 30.0,
                top: 10.0,
                child: InkWell(
                  onTap: () async {
                    createPostAllFunctions.deleteFireBaseStorageItem(idFile);

                    setState(() {
                      idFile = null;
                      loadingPass = false;
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
     // ..attachments.add(FileAttachment(File('{FILE_PATH}')))
      ..text = '{PLAIN_TEXT_GOES_HERE}'
      ..html = '{HTML_CONTENT_GOES_HERE}';

    send(_envelope, _emailTransport)..then((envelope) => print('Email sent'));
  }*/

  Widget continueButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    final locationProvider = Provider.of<CreateLocationProvider>(context);
    return idFile != null
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
                "identify_file": idFile,
                //"selfie": selfi
              }, SetOptions(merge: true));

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

  Future filePickerPass(BuildContext context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Id/")
          .child("IdFile/$filename");
      final firebase_storage.UploadTask uploadTask = storageRef.putData(file);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            setState(() {
              loadingPass = true;
              uploadTask.snapshotEvents.listen((event) {
                percentage =
                    (event.bytesTransferred.toDouble() / event.totalBytes);
              });
            });
          } else if (snapshot.state == TaskState.success) {
            setState(() {
              loadingPass = false;
            });
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        idFile = dowurl.toString();
      });
    }
  }

  Widget chooseButtonPass(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        filePickerPass(context);
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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: largeScreen ? w * .4 : w * .6,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Center(
            child: Text(
              S.of(context).passport,
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
              S.of(context).passportDes,
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
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              passportUpload(),
              SizedBox(
                width: w * .02,
              ),
              SelfiUpload(),
            ],
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
