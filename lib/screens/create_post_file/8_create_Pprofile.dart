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
import 'package:uy/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreatePersonalityProfile extends StatefulWidget {
  const CreatePersonalityProfile({Key key}) : super(key: key);

  @override
  _CreatePersonalityProfileState createState() =>
      _CreatePersonalityProfileState();
}

class _CreatePersonalityProfileState extends State<CreatePersonalityProfile> {
  firebase_storage.Reference firebaseStorageRef;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool loading = false;
  String time;
  String userName;
  String extension;
  String postTime;
  String mediaUrl;
  double percentage;
  Uint8List uploadedImage;
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController hometownController = TextEditingController();
  TextEditingController currentCityController = TextEditingController();
  TextEditingController biograpphyController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController childrenController = TextEditingController();
  TextEditingController relationshipStatusController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  final textFormKey = GlobalKey<FormState>();
  List<String> allSubscribers = [];
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  @override
  void initState() {
    super.initState();
    getAllSubscribers();
    fToast = FToast();
    fToast.init(context);
  }

  doneFunction() {
    postTime = "${DateTime.now()}".split('.').first;

    if (textFormKey.currentState.validate()) {
      if (mediaUrl != null) {
        users
            .doc(currentUser.uid)
            .collection("Pub")
            .doc("${time != null ? time : postTime}")
            .set({
          "postKind": "personality",
          "timeAgo": DateTime.now(),
          "Nationality": nationalityController.text.trim(),
          "full_name": fullNameController.text.trim(),
          "homeTown": hometownController.text.trim(),
          "currentCity": currentCityController.text.trim(),
          "age": ageController.text.trim(),
          "status": relationshipStatusController.text.trim(),
          "description": biograpphyController.text.trim(),
          "Occupation": occupationController.text.trim(),
          "children": childrenController.text.trim(),
          "education": educationController.text.trim(),
          "mediaUrl": mediaUrl,
          "close": false,
        }, SetOptions(merge: true)).then((value) {
          allSubscribers.forEach((element) {
            users
                .doc(element)
                .collection("Home")
                .doc("${currentUser.uid}==${time != null ? time : postTime}")
                .set({
              "postKind": "personality",
              "timeAgo": DateTime.now(),
            });
          });
        }).then(
          (value) => FirebaseFirestore.instance
              .collection("AllPub")
              .doc("${currentUser.uid}==${time != null ? time : postTime}")
              .set(
            {
              "postKind": "personality",
              "timeAgo": DateTime.now(),
              "title": fullNameController.text.trim(),
              "lastRead": 0,
              "lastTimeRead": DateTime.now(),
              "growOrder": 0,
              "close": false,
            },
            SetOptions(merge: true),
          ),
        );
        users
            .doc(currentUser.uid)
            .collection(imagesFormat.contains(extension)
                ? "Post Pictures"
                : " Post Videos")
            .doc(time)
            .set(
          {
            "mediaUrl": mediaUrl,
            "postKind": "personality",
            "timeAgo": DateTime.now(),
          },
          SetOptions(merge: true),
        );
        Navigator.of(context).pop();
      } else {
        if (mediaUrl == null) {
          return toast.showToast(
              S.of(context).snackBarUplodPicture, fToast, Colors.red[400]);
        }
      }
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
    /* querySnapshot.docs
        .map((doc) => allSubscribersForNotifi.add(doc.id))
        .toList();*/
  }

  Future<void> filePicker() async {
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
      await users.doc(currentUser.uid).collection("Pub").doc(time).set(
          {"mediaUrl": mediaUrl, "extension": extension},
          SetOptions(merge: true));
      await users
          .doc(currentUser.uid)
          .collection(imagesFormat.contains(extension)
              ? "Post Pictures"
              : " Post Videos")
          .doc(time)
          .set(
        {"mediaUrl": mediaUrl},
        SetOptions(merge: true),
      );
      FocusManager.instance.primaryFocus.unfocus();
    }
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

  Widget uploadWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return mediaUrl == null
        ? Container(
            height: h * .5,
            width: w * .2,
            child: !loading
                ? InkWell(
                    onTap: () {
                      filePicker();
                    },
                    child: HoverWidget(
                        child: profileImageWidget(false),
                        hoverChild: profileImageWidget(true),
                        onHover: (onHover) {}),
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
                  height: h * .5,
                  width: w * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Container(
                      height: h * .5,
                      width: w * .2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(mediaUrl).image,
                        ),
                      ),
                    ),
                  )),
              Positioned(
                right: 30.0,
                top: 10.0,
                child: InkWell(
                    onTap: () async {
                      createPostAllFunctions
                          .deleteFireBaseStorageItem(mediaUrl);

                      await users
                          .doc(currentUser.uid)
                          .collection("Pub")
                          .doc(time)
                          .delete();
                      setState(() {
                        mediaUrl = null;
                        loading = false;
                      });
                    },
                    child: HoverWidget(
                        child: deleteButtonWidget(false),
                        hoverChild: deleteButtonWidget(true),
                        onHover: (onHover) {})),
              )
            ],
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
        fullNameController.text.isNotEmpty ||
        hometownController.text.isNotEmpty ||
        currentCityController.text.isNotEmpty ||
        biograpphyController.text.isNotEmpty ||
        ageController.text.isNotEmpty ||
        childrenController.text.isNotEmpty ||
        educationController.text.isNotEmpty ||
        relationshipStatusController.text.isNotEmpty) {
      return createPostAllFunctions.unDoneDialog(
        h,
        w,
        context,
        S.of(context).unDoneDialogDiscardPost,
        S.of(context).unDoneDialogDiscardDes,
        S.of(context).unDoneDialogDiscardButton,
        S.of(context).cancelButton,
        discardFunction,
        alertDialogCancelFunction,
      );
    }

    Navigator.of(context).pop();
  }

  discardFunction() {
    if (mediaUrl != null) {
      users.doc(currentUser.uid).collection("Pub").doc(time).delete();
      createPostAllFunctions.deleteFireBaseStorageItem(mediaUrl);
    }

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  alertDialogCancelFunction() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Builder(builder: (context) {
      return Column(
        children: [
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
                        S.of(context).createProfiletitle,
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: "SPProtext"),
                      ),
                    ),
                  ),
                  Container(
                    height: h * .1,
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
              child: Form(
                key: textFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: h * .85,
                      width: w * .5,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          uploadWidget(),
                          Container(
                            height: h * .85,
                            width: w * .28,
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: h * .06,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: true,
                                    errorText:
                                        "* ${S.of(context).requiredFiled}",
                                    controller: fullNameController,
                                    hintText: S
                                        .of(context)
                                        .fullNameTitleSignUpWithEmail,
                                  ),
                                ),
                                Container(
                                  height: h * .06,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: true,
                                    errorText:
                                        "* ${S.of(context).requiredFiled}",
                                    controller: ageController,
                                    hintText:
                                        S.of(context).createProfileAgeHintText,
                                  ),
                                ),
                                Container(
                                  height: h * .06,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: true,
                                    errorText:
                                        "* ${S.of(context).requiredFiled}",
                                    controller: nationalityController,
                                    hintText:
                                        S.of(context).createProfileNationality,
                                  ),
                                ),
                                Container(
                                  height: h * .1,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: false,
                                    controller: relationshipStatusController,
                                    hintText:
                                        S.of(context).createProfileRelation,
                                  ),
                                ),
                                Container(
                                  height: h * .06,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: false,
                                    controller: childrenController,
                                    hintText:
                                        S.of(context).createProfileChildren,
                                  ),
                                ),
                                Container(
                                  height: h * .12,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                      validate: false,
                                      controller: educationController,
                                      hintText:
                                          S.of(context).createProfileEducation),
                                ),
                                Container(
                                  height: h * .12,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: true,
                                    errorText:
                                        "* ${S.of(context).requiredFiled}",
                                    controller: occupationController,
                                    hintText:
                                        S.of(context).createProfileOccupation,
                                  ),
                                ),
                                Container(
                                  height: h * .06,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: true,
                                    errorText:
                                        "* ${S.of(context).requiredFiled}",
                                    controller: hometownController,
                                    hintText: S
                                        .of(context)
                                        .createProfileHomeTwonHintText,
                                  ),
                                ),
                                Container(
                                  height: h * .06,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: true,
                                    errorText:
                                        "* ${S.of(context).requiredFiled}",
                                    controller: currentCityController,
                                    hintText: S
                                        .of(context)
                                        .createProfilecurrentCityHintText,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        height: h * .6,
                        width: w * .45,
                        child: TextFormFieldWidget(
                          validate: true,
                          errorText: "* ${S.of(context).requiredFiled}",
                          controller: biograpphyController,
                          hintText: S.of(context).createProfileCvHintText,
                        ),
                      ),
                    ),
                    SizedBox(height: h * .03)
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget profileImageWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .4,
      width: w * .15,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? Colors.grey[200] : Colors.grey[100],
      ),
      child: Center(
        child: Icon(
          LineAwesomeIcons.user_circle_1,
          size: 40.0,
          color: accentColor,
        ),
      ),
    );
  }
}
