import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uy/services/provider/attachementProvider.dart';
import 'package:uy/services/provider/message_list_provider.dart';
import 'package:uy/services/provider/message_provider.dart';

class UploadFileWidget extends StatefulWidget {
  const UploadFileWidget({Key key}) : super(key: key);

  @override
  _UploadFileWidgetState createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  double percentage;
  File image;
  String postTime;
  String time;
  bool displayOption = false;
  bool loading = false;
  bool attachement = false;
  firebase_storage.Reference firebaseStorageRef;
  TextEditingController controller = new TextEditingController();
  String senderName;
  String receiverName;
  bool isBlock = false;
  String extension;
  String docKind;
  String blockedBy;
  String timeAgo;
  String downloadUrl;

  Future filePicker(context, String userId, bool media, String kind) async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: media ? FileType.media : FileType.any);
    postTime = "${DateTime.now()}".split('.').first;

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;
      String extension = result.files.single.extension;
      setState(() {
        time = postTime;
      });
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Chat/$userId/$time")
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
        downloadUrl = dowurl.toString();
      });
      DocumentSnapshot nameUser = await users.doc(currentUser.uid).get();

      media
          ? users
              .doc(userId)
              .collection("Chat")
              .doc(currentUser.uid)
              .collection("Media")
              .doc(time)
              .set({"message": downloadUrl, "extension": ".$extension"},
                  SetOptions(merge: true))
          : print("object");
      media
          ? users
              .doc(currentUser.uid)
              .collection("Chat")
              .doc(userId)
              .collection("Media")
              .doc(time)
              .set({"message": downloadUrl, "extension": ".$extension"},
                  SetOptions(merge: true))
          : print("object");

      QuerySnapshot mediaLength = await users
          .doc(currentUser.uid)
          .collection("Chat")
          .doc(userId)
          .collection("Media")
          .get();

      await users.doc(currentUser.uid).collection("Chat").doc(userId).set({
        "lastTime": DateTime.now(),
        'messageKind': "media",
        "messageType": "Sender",
        "extension": ".$extension",
        "sendBy": nameUser.data()["full_name"],
      });
      await users
          .doc(currentUser.uid)
          .collection("Chat")
          .doc(userId)
          .collection("Messages")
          .doc(time)
          .set({
        "message": downloadUrl,
        "fileName": filename,
        "messageType": "Sender",
        "timeAgo": DateTime.now(),
        "sendBy": nameUser.data()["full_name"],
        "image": nameUser.data()["image"],
        "messageKind": kind,
        "storageId": time,
        "index": mediaLength.docs.length - 1,
        "extension": ".$extension"
      }, SetOptions(merge: true));
      QuerySnapshot messageList =
          await users.doc(currentUser.uid).collection("Chat").get();
      Provider.of<MessageListProvider>(context, listen: false)
          .addMessageList(messageList.docs.length);

      await users.doc(userId).collection("Chat").doc(currentUser.uid).set(
        {
          "lastTime": DateTime.now(),
          "new message": true,
          'messageKind': "media",
          "messageType": "Receiver",
          "sendBy": nameUser.data()["full_name"],
          "extension": ".$extension",
        },
      );
      await users
          .doc(userId)
          .collection("Chat")
          .doc(currentUser.uid)
          .collection("Messages")
          .doc(time)
          .set({
        "message": downloadUrl,
        "fileName": filename,
        "messageType": "Receiver",
        "timeAgo": DateTime.now(),
        "sendBy": nameUser.data()["full_name"],
        "image": nameUser.data()["image"],
        "messageKind": kind,
        "storageId": time,
        "extension": ".$extension",
        "index": mediaLength.docs.length - 1,
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<MessageProvider>(context).userId;
    bool attachement =
        Provider.of<AttachementMessageProvider>(context).attachement;
    return Container(
      width: w * .4,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
          height: attachement ? h * .07 : 0.0,
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(
              color: attachement ? Colors.grey[400] : Colors.transparent,
            ),
          )),
          width: w * .4,
          child: loading
              ? Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: w * .4,
                    height: h * .008,
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        filePicker(context, userId, true, "media");
                      },
                      child: Container(
                        height: h * .05,
                        width: h * .05,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "./assets/icons/150-picture.svg",
                            height: 20.0,
                            width: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        filePicker(context, userId, false, "file");
                      },
                      child: Container(
                        height: h * .05,
                        width: h * .05,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "./assets/icons/022-file.svg",
                            height: 20.0,
                            width: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: h * .05,
                      width: h * .05,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "./assets/icons/placeholder.svg",
                          height: 20.0,
                          width: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
