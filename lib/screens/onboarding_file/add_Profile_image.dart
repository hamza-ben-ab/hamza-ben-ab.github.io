import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/screens/onboarding_file/add_suggestion.dart';
import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/responsiveLayout.dart';

class AddProfileReaderImage extends StatefulWidget {
  const AddProfileReaderImage({Key key}) : super(key: key);

  @override
  _AddProfileReaderImageState createState() => _AddProfileReaderImageState();
}

class _AddProfileReaderImageState extends State<AddProfileReaderImage> {
  Uint8List profileImage;
  String profileImageUrl;
  bool loading = false;
  double percentage = 0.0;
  //userKind
  //journalistKind

  String time;
  String postTime;
  String genderValue;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String imagePath;
  String genderJournalist;

  Future uploadProfileImage(context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        profileImage = result.files.single.bytes;
      });

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("profileImage");
      final firebase_storage.UploadTask uploadTask =
          storageRef.putData(profileImage);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            loading = true;
            uploadTask.snapshotEvents.listen((event) {
              percentage =
                  (event.bytesTransferred.toDouble() / event.totalBytes);
            });
          } else if (snapshot.state == TaskState.success) {
            loading = false;
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        profileImageUrl = dowurl.toString();
      });
    }
  }

  getStringGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      genderValue = prefs.getString('genderValue').toString();
    });
  }

  getJournalistgender() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    if (doc.data()["Gender"] == "male") {
      setState(() {
        genderJournalist = "male";
      });
    } else {
      setState(() {
        genderJournalist = "women";
      });
    }
  }

  nextFunction() async {
    final locationProvider =
        Provider.of<CreateLocationProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    users.doc(currentUser.uid).set({
      "full_name": prefs.getString("full_name").toString(),
      "password": prefs.getString("password").toString(),
      "email": prefs.getString("email").toString(),
      "currentLocation": locationProvider.currentLocationController.text.trim(),
      "homeTownLocation": locationProvider.homeTownLocation.text.trim(),
      "Gender": prefs.getString("gender").toString(),
      "kind": prefs.getString("userKind").toString(),
      "image": profileImageUrl
    }, SetOptions(merge: true));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddAndFollow()),
    );
  }

  @override
  void initState() {
    getStringGender();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: h,
                width: w,
                child: Column(
                  children: [
                    TeltrueAppBar(
                      function: nextFunction,
                      backRoute: "/PassCode",
                      nextRouteTitle: S.of(context).nextButton,
                    ),
                    Expanded(
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              height: h * .4,
                              width: largeScreen ? w * .2 : w * .4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(color: Colors.grey[400]),
                              ),
                            ),
                            profileImageUrl != null
                                ? Container(
                                    height: h * .4,
                                    width: largeScreen ? w * .2 : w * .4,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15.0),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(
                                            profileImageUrl,
                                          ).image),
                                    ),
                                  )
                                : Container(
                                    height: h * .4,
                                    width: largeScreen ? w * .2 : w * .4,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          "./assets/images/${genderValue == "male" ? "man" : "women"}.png"),
                                    ),
                                  ),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: Stack(
                                children: [
                                  Container(
                                    height: h * 0.06,
                                    width: h * 0.06,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          uploadProfileImage(context);
                                        },
                                      ),
                                    ),
                                    height: h * 0.06,
                                    width: h * 0.06,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BottomBarLoginWidget()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
