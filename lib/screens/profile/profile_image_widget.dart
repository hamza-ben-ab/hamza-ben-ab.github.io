import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/services/provider/profile_image_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileImageWidget extends StatefulWidget {
  final String profileImage;
  final String userId;

  const ProfileImageWidget({
    Key key,
    this.profileImage,
    this.userId,
  }) : super(key: key);

  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  _ProfileImageWidgetState();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool loadingProfileImage = false;
  User currentUser = FirebaseAuth.instance.currentUser;
  String imageUrl;
  bool imageExist = false;
  double percentage = 0.0;
  String genderValue;

  imageProfileExist() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    if (doc.data()["image"] == null) {
      setState(() {
        imageExist = false;
      });
    } else {
      setState(() {
        imageExist = true;
      });
    }
  }

  Future filePicker(context, bool profile) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.media);

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      loadingProfileImage = true;
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("profileImage");
      final firebase_storage.UploadTask uploadTask = storageRef.putData(file);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            setState(() {
              uploadTask.snapshotEvents.listen((event) {
                percentage =
                    (event.bytesTransferred.toDouble() / event.totalBytes);
              });
            });
          } else if (snapshot.state == TaskState.success) {
            loadingProfileImage = false;
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        imageUrl = dowurl.toString();
      });

      await users.doc(currentUser.uid).update(
        {"image": imageUrl},
      );
      Provider.of<ProfileImageProvider>(context, listen: false)
          .changeProfileImage(imageUrl);
    }
  }

  getStringGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      genderValue = prefs.getString('genderValue').toString();
    });
  }

  @override
  void initState() {
    getStringGender();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    String imageUrl = Provider.of<ProfileImageProvider>(context).imageUrl;
    return Stack(
      children: [
        !loadingProfileImage && imageUrl != null ||
                widget.profileImage.isNotEmpty
            ? Container(
                height: h * .2,
                width: h * .2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          Image.network(imageUrl ?? widget.profileImage).image,
                      fit: BoxFit.cover),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(24.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                ),
              )
            : imageUrl == null && widget.profileImage == ""
                ? Container(
                    height: h * .2,
                    width: h * .2,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(24.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                    ),
                    child: Center(
                      child: Image.asset(
                          "./assets/images/${genderValue == "male" ? "man" : "women"}.png"),
                    ),
                  )
                : Container(
                    height: h * .2,
                    width: h * .2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(24.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                    ),
                    child: Center(
                      child: SpinKitThreeBounce(
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
                  ),
        currentUser.uid == widget.userId
            ? Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Stack(
                  children: [
                    Container(
                      height: h * 0.06,
                      width: h * 0.06,
                      decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    Container(
                      child: Center(
                        child: IconButton(
                          icon: SvgPicture.asset(
                              "./assets/icons/031-photo camera.svg",
                              height: 25.0,
                              width: 25.0,
                              color: Colors.white),
                          onPressed: () {
                            filePicker(context, true);
                          },
                        ),
                      ),
                      height: h * 0.06,
                      width: h * 0.06,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                height: 0.0,
                width: 0.0,
              ),
      ],
    );
  }
}
