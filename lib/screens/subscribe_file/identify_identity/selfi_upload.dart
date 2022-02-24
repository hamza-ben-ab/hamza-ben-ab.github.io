import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';

import 'package:uy/services/responsiveLayout.dart';

class SelfiUpload extends StatefulWidget {
  const SelfiUpload({Key key}) : super(key: key);

  @override
  _SelfiUploadState createState() => _SelfiUploadState();
}

class _SelfiUploadState extends State<SelfiUpload> {
  //Variable
  bool loadingSelfi = false;
  String selfi;
  double percentage;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  //Func

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

  Future filePickerSelfi(BuildContext context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;

      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Id/")
          .child("selfi/$filename");
      final firebase_storage.UploadTask uploadTask = storageRef.putData(file);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            setState(() {
              loadingSelfi = true;
              uploadTask.snapshotEvents.listen((event) {
                percentage =
                    (event.bytesTransferred.toDouble() / event.totalBytes);
              });
            });
          } else if (snapshot.state == TaskState.success) {
            setState(() {
              loadingSelfi = false;
            });
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        selfi = dowurl.toString();
      });
      users
          .doc(currentUser.uid)
          .set({"selfie": selfi}, SetOptions(merge: true));
    }
  }

  Widget chooseButtonSelfi(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () async {
        filePickerSelfi(context);
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
    return selfi == null
        ? Container(
            width: w * .15,
            height: h * .4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: !loadingSelfi
                ? Container(
                    width: w * .15,
                    height: h * .4,
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
                          "Selfie",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SPProtext",
                          ),
                        ),
                        SizedBox(
                          height: h * .12,
                        ),
                        HoverWidget(
                            child: chooseButtonSelfi(false),
                            hoverChild: chooseButtonSelfi(true),
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
                width: w * .15,
                height: h * .4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: Image.network(selfi).image),
                ),
              ),
              Positioned(
                right: 30.0,
                top: 10.0,
                child: InkWell(
                  onTap: () async {
                    createPostAllFunctions.deleteFireBaseStorageItem(selfi);

                    setState(() {
                      selfi = null;
                      loadingSelfi = false;
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
}
