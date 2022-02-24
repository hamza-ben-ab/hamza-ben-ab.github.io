import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uy/screens/search/hover.dart';
//import 'package:intl/intl.dart' as intl;

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  firebase_storage.Reference firebaseStorageRef;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  bool loading = false;
  String time;
  String fileName;
  String extension;
  String postTime;
  String mediaUrl;
  double percentage;
  Uint8List uploadedImage;
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;

  List<String> speakerList = [];
  TextEditingController placeController = TextEditingController();
  TextEditingController speakerController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController sHr = TextEditingController();
  TextEditingController sMin = TextEditingController();
  TextEditingController eHr = TextEditingController();
  TextEditingController eMin = TextEditingController();
  List<String> allSubscribers = [];
  List<String> allSubscribersForNotifi = [];
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  final textFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getAllSubscribers();
    fToast = FToast();
    fToast.init(context);
  }

  Widget buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(5.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onDeleted: () {
        setState(() {
          speakerList.remove(label);
        });
      },
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(10.0),
    );
  }

  doneFunction() {
    postTime = "${DateTime.now()}".split('.').first;

    if (textFormKey.currentState.validate()) {
      users
          .doc(currentUser.uid)
          .collection("Pub")
          .doc("${time != null ? time : postTime}")
          .set({
        "about": aboutController.text.trim(),
        "title": titleController.text.trim(),
        "postKind": "event",
        "timeAgo": DateTime.now(),
        "place": placeController.text.trim(),
        "speaker": speakerList,
        "mediaUrl": mediaUrl,
        "extension": extension,
        "date": "${year.text}-${month.text}-${day.text}",
        "startTime": "${sHr.text.trim()}:${sMin.text.trim()}",
        "endTime": "${eHr.text.trim()}:${eMin.text.trim()}",
      }).then((value) {
        allSubscribers.forEach((element) {
          users
              .doc(element)
              .collection("Home")
              .doc("${currentUser.uid}==${time != null ? time : postTime}")
              .set({
            "timeAgo": DateTime.now(),
            "postKind": "event",
          });
        });
      });
      users
          .doc(currentUser.uid)
          .collection(imagesFormat.contains(extension)
              ? "Post Pictures"
              : " Post Videos")
          .doc(time)
          .set(
        {
          "postKind": "event",
          "mediaUrl": mediaUrl,
          "timeAgo": DateTime.now(),
        },
        SetOptions(merge: true),
      );
      FirebaseFirestore.instance
          .collection("AllPub")
          .doc("${currentUser.uid}==${time != null ? time : postTime}")
          .set({
        "title": titleController.text.trim(),
        "postKind": "event",
        "timeAgo": DateTime.now(),
      }, SetOptions(merge: true));

      Navigator.of(context).pop();
    }
  }

  Future<void> getAllSubscribers() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .collection("Subscribers");

    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.map((doc) => allSubscribers.add(doc.id)).toList();
    allSubscribers.add(currentUser.uid);
    querySnapshot.docs
        .map((doc) => allSubscribersForNotifi.add(doc.id))
        .toList();
  }

  Future<void> filePicker() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    postTime = "${DateTime.now()}".split('.').first;

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;
      extension = ".${result.files.single.extension}";
      setState(() {
        time = postTime;
      });
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Post/$time")
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
        mediaUrl = dowurl.toString();
      });
    }
  }

  Widget uploadWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        FilePickerResult result =
            await FilePicker.platform.pickFiles(type: FileType.media);
        postTime = "${DateTime.now()}".split('.').first;
        if (result != null) {
          Uint8List file = result.files.single.bytes;
          String filename = result.files.single.name;
          extension = ".${result.files.single.extension}";
          setState(() {
            time = postTime;
          });
          firebase_storage.Reference storageRef = firebase_storage
              .FirebaseStorage.instance
              .ref("${currentUser.uid}/")
              .child("Post/$time")
              .child("$filename");
          final firebase_storage.UploadTask uploadTask =
              storageRef.putData(file);

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
            mediaUrl = dowurl.toString();
          });
        }
      },
      child: Container(
        width: w * .2,
        height: h * .4,
        child: loading && (mediaUrl == null)
            ? Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: percentage,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xFF33CC33)),
                    backgroundColor: Color(0xffD6D6D6),
                  ),
                ),
              )
            : !loading && (mediaUrl != null)
                ? Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        width: w * .2,
                        height: h * .4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: imagesFormat.contains(extension)
                            ? Container(
                                width: w * .2,
                                height: h * .4,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: Image.network(
                                    mediaUrl,
                                    fit: BoxFit.cover,
                                  ).image),
                                ),
                              )
                            : videoFormat.contains(extension)
                                ? Container(
                                    width: w * .2,
                                    height: h * .4,
                                    child: ClipRRect(
                                      child: VideoViewChat(
                                        videoUrl: mediaUrl,
                                        isFile: false,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                      ),
                      Positioned(
                        right: 10.0,
                        top: 10.0,
                        child: InkWell(
                          onTap: () async {
                            createPostAllFunctions
                                .deleteFireBaseStorageItem(mediaUrl);
                            setState(() {
                              mediaUrl = null;
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
                  )
                : Center(
                    child: Icon(
                      LineAwesomeIcons.image_1,
                      color: accentColor,
                      size: 40.0,
                    ),
                  ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
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

  Widget cancelButton() {
    double h = MediaQuery.of(context).size.height;
    return HoverWidget(
        child:
            createPostAllFunctions.cancelButtonWidget(false, h, cancelFunction),
        hoverChild:
            createPostAllFunctions.cancelButtonWidget(true, h, cancelFunction),
        onHover: (onHover) {});
  }

  cancelFunction() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (mediaUrl != null ||
        titleController.text.isNotEmpty ||
        placeController.text.isNotEmpty ||
        sHr.text.isNotEmpty ||
        sMin.text.isNotEmpty ||
        eHr.text.isNotEmpty ||
        eMin.text.isNotEmpty ||
        day.text.isNotEmpty ||
        month.text.isNotEmpty ||
        day.text.isNotEmpty ||
        aboutController.text.isNotEmpty) {
      return createPostAllFunctions.unDoneDialog(
          h,
          w,
          context,
          S.of(context).unDoneDialogDiscardPost,
          S.of(context).unDoneDialogDiscardDes,
          S.of(context).unDoneDialogDiscardButton,
          S.of(context).cancelButton,
          discardFunction,
          alertDialogCancelFunction);
    }

    Navigator.of(context).pop();
  }

  alertDialogCancelFunction() {
    Navigator.of(context).pop();
  }

  discardFunction() {
    if (mediaUrl != null) {
      users.doc(currentUser.uid).collection("Pub").doc(time).delete();
      createPostAllFunctions.deleteFireBaseStorageItem(mediaUrl);
    }
    mediaUrl = null;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Builder(builder: (context) {
      return Column(children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            height: h * .1,
            child: Row(
              children: [
                cancelButton(),
                Expanded(
                  child: Center(
                    child: Text(
                      S.of(context).tagEvent,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
                Container(
                  height: h * .08,
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: createPostAllFunctions.doneButton(
                        h, w, S.of(context).doneButton, doneFunction),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: textFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: h * .06,
                      width: w * .45,
                      child: TextFormFieldWidget(
                        validate: true,
                        errorText: "* ${S.of(context).requiredFiled}",
                        controller: titleController,
                        hintText: S.of(context).addEventTitleHint,
                      ),
                    ),
                    SizedBox(
                      height: h * .03,
                    ),
                    Container(
                      height: h * .06,
                      width: w * .45,
                      child: TextFormFieldWidget(
                        validate: true,
                        errorText: "* ${S.of(context).requiredFiled}",
                        controller: placeController,
                        hintText: S.of(context).addEventPlaceHint,
                      ),
                    ),
                    SizedBox(
                      height: h * .03,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: h * .06,
                            width: w * .25,
                            child: TextFormFieldWidget(
                              validate: false,
                              controller: speakerController,
                              hintText: S.of(context).addEventSpeakerHint,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {
                              speakerList.add(speakerController.text.trim());
                              setState(() {});
                              speakerController.clear();
                            },
                            child: HoverWidget(
                                child: createPostAllFunctions.addbuttonWidget(
                                    false, h),
                                hoverChild: createPostAllFunctions
                                    .addbuttonWidget(true, h),
                                onHover: (onHover) {}),
                          ).xShowPointerOnHover,
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: [
                            for (int i = 0; i < speakerList.length; i++)
                              buildChip(speakerList[i], Colors.blueGrey[300])
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        S.of(context).addEventDateLabel,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: "SPProtext",
                        ),
                      ),
                    ),
                    Container(
                      width: w * .3,
                      //padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: h * .06,
                            width: w * .08,
                            child: TextFormFieldWidget(
                              validate: true,
                              errorText: "* ${S.of(context).requiredFiled}",
                              controller: year,
                              hintText: S.of(context).hintTextYear,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            height: h * .06,
                            width: 15.0,
                            child: Center(
                              child: Text(
                                "/",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "SPProtext"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            height: h * .06,
                            width: w * .08,
                            child: Container(
                                height: h * .06,
                                width: w * .1,
                                child: TextFormFieldWidget(
                                  validate: true,
                                  errorText: "* ${S.of(context).requiredFiled}",
                                  controller: month,
                                  hintText: S.of(context).hintTextMonth,
                                )),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            height: h * .06,
                            width: 15.0,
                            child: Center(
                              child: Text(
                                "/",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "SPProtext"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            height: h * .06,
                            width: w * .08,
                            child: Container(
                                height: h * .06,
                                width: w * .1,
                                child: TextFormFieldWidget(
                                  validate: true,
                                  errorText: "* ${S.of(context).requiredFiled}",
                                  controller: day,
                                  hintText: S.of(context).hintTextDay,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Text(
                                    S.of(context).addStartEventTime,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SPProtext"),
                                  ),
                                ),
                                Container(
                                  height: h * .08,
                                  width: w * .15,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: h * .08,
                                        width: (w * .05),
                                        child: TextFormFieldWidget(
                                            validate: true,
                                            errorText:
                                                "* ${S.of(context).requiredFiled}",
                                            controller: sHr,
                                            hintText: "00"),
                                      ),
                                      Container(
                                        height: h * .05,
                                        width: 15.0,
                                        child: Center(
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: h * .06,
                                        width: (w * .05),
                                        child: TextFormFieldWidget(
                                            validate: true,
                                            errorText:
                                                "* ${S.of(context).requiredFiled}",
                                            controller: sMin,
                                            hintText: "00"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: w * .05,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Text(
                                    S.of(context).addEndEventTime,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SPProtext"),
                                  ),
                                ),
                                Container(
                                  height: h * .08,
                                  width: w * .15,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: h * .08,
                                        width: (w * .05),
                                        child: TextFormFieldWidget(
                                            validate: true,
                                            errorText:
                                                "* ${S.of(context).requiredFiled}",
                                            controller: eHr,
                                            hintText: "00"),
                                      ),
                                      Container(
                                        height: h * .05,
                                        width: 15.0,
                                        child: Center(
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: h * .06,
                                        width: (w * .05),
                                        child: TextFormFieldWidget(
                                            validate: true,
                                            errorText:
                                                "* ${S.of(context).requiredFiled}",
                                            controller: eMin,
                                            hintText: "00"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          uploadWidget(),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            height: h * .4,
                            width: w * .25,
                            child: TextFormFieldWidget(
                              validate: true,
                              errorText: "* ${S.of(context).requiredFiled}",
                              controller: aboutController,
                              hintText: S.of(context).addEventAboutHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]);
    });
  }
}
