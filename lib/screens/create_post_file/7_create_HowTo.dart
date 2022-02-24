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
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/services/provider/article_search_provider.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:uy/services/provider/topic_provider.dart';
import 'package:uy/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart' as intl;
import 'package:uy/widget/topic_list.dart';

class CreateHowTo extends StatefulWidget {
  const CreateHowTo({Key key}) : super(key: key);

  @override
  _CreateHowToState createState() => _CreateHowToState();
}

class _CreateHowToState extends State<CreateHowTo> {
  firebase_storage.Reference firebaseStorageRef;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool loading = false;
  String time;
  String extension;
  String postTime;
  String mediaUrl;
  String firstName;
  double percentage;
  Uint8List uploadedImage;
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;
  TextEditingController stepsDetailsController = TextEditingController();
  TextEditingController stepTitleController = TextEditingController();
  TextEditingController needController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List<String> allSubscribers = [];
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  final textFormKey = GlobalKey<FormState>();
  final paragraphFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getAllSubscribers();
    getTheFirstName();
    fToast = FToast();
    fToast.init(context);
  }

  void refresh() {
    setState(() {});
  }

  doneFunction() {
    List<Map<String, dynamic>> stepsList =
        Provider.of<SearchArticleProvider>(context, listen: false)
            .paragraphList;
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;

    postTime = "${DateTime.now()}".split('.').first;

    if (textFormKey.currentState.validate()) {
      if (topic != null && stepsList.isNotEmpty) {
        users
            .doc(currentUser.uid)
            .collection("Pub")
            .doc("${time != null ? time : postTime}")
            .set({
          "postKind": "howTo",
          "timeAgo": DateTime.now(),
          "title": titleController.text.trim(),
          "topic": topic,
          "mediaUrl": mediaUrl,
          "needs": needController.text.trim(),
          "extension": extension,
          "steps": stepsList,
          "readers": 0,
          "report": 0
        }, SetOptions(merge: true)).then((value) {
          allSubscribers.forEach((element) {
            users
                .doc(element)
                .collection("Home")
                .doc("${currentUser.uid}==${time != null ? time : postTime}")
                .set({
              "postKind": "howTo",
              "timeAgo": DateTime.now(),
              "topic": topic,
              "seen": false,
            });
          });
        }).then((value) => FirebaseFirestore.instance
                    .collection("AllPub")
                    .doc(
                        "${currentUser.uid}==${time != null ? time : postTime}")
                    .set({
                  "postKind": "howTo",
                  "timeAgo": DateTime.now(),
                  "title": titleController.text.trim(),
                  "topic": topic,
                  "needs": needController.text.trim(),
                  "steps": stepsList,
                  "lastRead": 0,
                  "lastTimeRead": DateTime.now(),
                  "growOrder": 0,
                }, SetOptions(merge: true)));
        users
            .doc(currentUser.uid)
            .collection(imagesFormat.contains(extension)
                ? "Post Pictures"
                : " Post Videos")
            .doc(time)
            .set(
          {
            "mediaUrl": mediaUrl,
            "postKind": "howTo",
            "timeAgo": DateTime.now(),
          },
          SetOptions(merge: true),
        );
        Navigator.of(context).pop();
      } else {
        if (topic == null) {
          return toast.showToast(
              S.of(context).snackBarTopic, fToast, Colors.red[400]);
        } else if (stepsList.isEmpty) {
          return toast.showToast(
              S.of(context).snackBarAddSteps, fToast, Colors.red[400]);
        }
      }
    }
  }

  Future<void> getTheFirstName() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();

    setState(() {
      firstName = doc.data()["full_name"].toString().split(" ").first;
    });
  }

  Future<void> getAllSubscribers() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .collection("Subscribers");

    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.map((doc) => allSubscribers.add(doc.id)).toList();
    allSubscribers.add(currentUser.uid);
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
      /* await users.doc(currentUser.uid).collection("Pub").doc(time).set(
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
      */
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
                              loading = false;
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

  Function cancelFunction() {
    List<Map<String, dynamic>> stepsList =
        Provider.of<SearchArticleProvider>(context, listen: false)
            .paragraphList;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (needController.text.isNotEmpty ||
        stepTitleController.text.isNotEmpty ||
        stepsDetailsController.text.isNotEmpty ||
        mediaUrl != null ||
        stepsList.isNotEmpty) {
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
    //ShowTopicList.topic = null;
    Navigator.of(context).pop();
    return null;
  }

  discardFunction() {
    if (mediaUrl != null) {
      users.doc(currentUser.uid).collection("Pub").doc(time).delete();
      createPostAllFunctions.deleteFireBaseStorageItem(mediaUrl);
    }
    Provider.of<TagPostProvider>(context, listen: false).changeTagTopic(null);
    Provider.of<SearchArticleProvider>(context, listen: false).emptyList();
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
    String topic = Provider.of<TagPostProvider>(context).topic;
    List<Map<String, dynamic>> stepsList =
        Provider.of<SearchArticleProvider>(context).paragraphList;
    return Builder(builder: (context) {
      return Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              height: h * .1,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  cancelButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        S.of(context).createHowToTitle,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: textFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<TopicProvider>(context, listen: false)
                                  .backTo(0);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      elevation: 0.0,
                                      child: ShowTopicList(
                                        interest: false,
                                      ),
                                    );
                                  });
                            },
                            child: HoverWidget(
                              child: createPostAllFunctions.topicButton(
                                  false, h, w, S.of(context).topicButton),
                              hoverChild: createPostAllFunctions.topicButton(
                                  true, h, w, S.of(context).topicButton),
                              onHover: (onHover) {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      topic != null
                          ? createPostAllFunctions.topicWidget(h, topic)
                          : Container(
                              height: 0.0,
                              width: 0.0,
                            ),
                      SizedBox(
                        height: h * .05,
                      ),
                      Container(
                        height: h * .07,
                        width: w * .4,
                        child: TextFormFieldWidget(
                          validate: true,
                          errorText: "* ${S.of(context).requiredFiled}",
                          controller: titleController,
                          hintText: S.of(context).addPostArticleGeneralTitle,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Row(
                          children: [
                            Text(
                              S.of(context).createHowToSuplliesHintText,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SPProtext"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: h * .25,
                        width: w * .35,
                        child: TextFormFieldWidget(
                          validate: true,
                          errorText: "* ${S.of(context).requiredFiled}",
                          controller: needController,
                          hintText: S.of(context).createHowToSuplliesHintText,
                        ),
                      ),
                      SizedBox(
                        height: h * .025,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Row(
                          children: [
                            Text(
                              S.of(context).createHowToThinkInStep,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SPProtext"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: h * .06,
                        width: w * .35,
                        child: TextFormFieldWidget(
                          validate: false,
                          controller: stepTitleController,
                          hintText: S.of(context).createHowToStepTitleHintText,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: h * .2,
                        width: w * .42,
                        child: Form(
                          key: paragraphFormKey,
                          child: TextFormFieldWidget(
                            validate: true,
                            errorText: "* ${S.of(context).requiredFiled}",
                            controller: stepsDetailsController,
                            hintText:
                                S.of(context).createHowToStepDetailsHintText,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [addStep()],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      for (int i = 0; i < stepsList.length; i++)
                        Center(
                          child: GlobalStepWidget(
                            list: stepsList,
                            width: .42,
                            callback: refresh,
                            i: i,
                            currentDetails: stepsList[i]["details"],
                            currentTitle: stepsList[i]["title"],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Row(
                          children: [
                            Text(
                              S.of(context).createHowToShowResult,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SPProtext"),
                            ),
                          ],
                        ),
                      ),
                      uploadWidget(),
                      SizedBox(
                        height: h * .02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget addStep() {
    double h = MediaQuery.of(context).size.height;

    return InkWell(
        child: HoverWidget(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: h * .05,
            decoration: BoxDecoration(
              color: button2Color,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).createHowToAddStepButton,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: "SPProtext"),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Icon(LineAwesomeIcons.plus, color: Colors.white),
              ],
            ),
          ),
          hoverChild: Container(
            height: h * .05,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: button2ColorHover,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).createHowToAddStepButton,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: "SPProtext"),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Icon(LineAwesomeIcons.plus, color: Colors.white),
              ],
            ),
          ),
          onHover: (onHover) {},
        ),
        onTap: () {
          if (paragraphFormKey.currentState.validate()) {
            if (stepsDetailsController.text.isNotEmpty) {
              Provider.of<SearchArticleProvider>(context, listen: false)
                  .addPart({
                "title": stepTitleController.text.trim(),
                "details": stepsDetailsController.text.trim()
              });
              stepTitleController.clear();
              stepsDetailsController.clear();
            }
          }
        });
  }
}

class GlobalStepWidget extends StatefulWidget {
  final Function callback;
  final int i;
  final String currentTitle;
  final String currentDetails;
  final double width;
  final List list;
  final String mediaUrl;

  const GlobalStepWidget({
    Key key,
    this.i,
    this.currentTitle,
    this.currentDetails,
    this.callback,
    this.width,
    this.list,
    this.mediaUrl,
  }) : super(key: key);

  @override
  _GlobalStepWidgetState createState() => _GlobalStepWidgetState();
}

class _GlobalStepWidgetState extends State<GlobalStepWidget> {
  bool modify = false;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  TextEditingController titleModiferController = TextEditingController();
  TextEditingController detailsModiferController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String currentTitle;
  String currentDetails;

  @override
  void initState() {
    titleModiferController = TextEditingController(text: widget.currentTitle);
    detailsModiferController =
        TextEditingController(text: widget.currentDetails);
    currentTitle = widget.currentTitle;
    currentDetails = widget.currentDetails;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: w * widget.width,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey[400])),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //pen
                InkWell(
                  onTap: () {
                    setState(() {
                      modify = true;
                    });
                  },
                  child: HoverWidget(
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey[50],
                        radius: 17.0,
                        child: Icon(
                          LineAwesomeIcons.pen,
                          color: Colors.grey[600],
                        ),
                      ),
                      hoverChild: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 17.0,
                        child: Icon(
                          LineAwesomeIcons.pen,
                          color: Colors.grey[600],
                        ),
                      ),
                      onHover: (onHover) {}),
                ),
                SizedBox(
                  width: 10.0,
                ),
                //delete
                InkWell(
                  onTap: () {
                    widget.list.removeAt(widget.i);
                    widget.callback();
                  },
                  child: HoverWidget(
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey[50],
                        radius: 17.0,
                        child: Icon(
                          LineAwesomeIcons.times_circle,
                          color: Colors.grey[600],
                        ),
                      ),
                      hoverChild: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 17.0,
                        child: Icon(
                          LineAwesomeIcons.times_circle,
                          color: Colors.grey[600],
                        ),
                      ),
                      onHover: (onHover) {}),
                ),
              ],
            ),
            modify
                ? Container(
                    width: w * widget.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.mediaUrl != null
                                  ? Stack(
                                      children: [
                                        Container(
                                          height: h * .3,
                                          width: w * .15,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            image: DecorationImage(
                                              image:
                                                  Image.network(widget.mediaUrl)
                                                      .image,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10.0,
                                          top: 10.0,
                                          child: InkWell(
                                            onTap: () {
                                              Provider.of<SearchArticleProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateMediaUrl(widget.i);
                                              createPostAllFunctions
                                                  .deleteFireBaseStorageItem(
                                                      widget.mediaUrl);
                                            },
                                            child: HoverWidget(
                                              child: deleteButtonWidget(false),
                                              hoverChild:
                                                  deleteButtonWidget(true),
                                              onHover: (onHover) {},
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Container(
                                width: w * .35,
                                height: h * .15,
                                child: TextFormFieldWidget(
                                  controller: titleModiferController,
                                  hintText: S
                                      .of(context)
                                      .createHowToStepTitleHintText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: w * widget.width,
                          height: h * .25,
                          child: TextFormFieldWidget(
                            controller: detailsModiferController,
                            hintText:
                                S.of(context).createHowToStepDetailsHintText,
                          ),
                        ),
                        Container(
                          height: h * .07,
                          width: w * widget.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Container(
                                  height: h * 0.04,
                                  width: w * .1,
                                  child: Center(
                                    child: Text(
                                      S.of(context).saveButton,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontFamily: "SPProtext"),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.blue),
                                ),
                                onTap: () async {
                                  currentTitle =
                                      titleModiferController.text.trim();
                                  currentDetails =
                                      detailsModiferController.text.trim();
                                  setState(() {
                                    modify = false;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              InkWell(
                                child: Container(
                                  height: h * 0.04,
                                  width: w * .1,
                                  child: Center(
                                    child: Text(
                                      S.of(context).cancelButton,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontFamily: "SPProtext"),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: buttonColor,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    modify = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Row(
                          children: [
                            widget.mediaUrl != null
                                ? Container(
                                    height: h * .3,
                                    width: w * .15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      image: DecorationImage(
                                          image: Image.network(widget.mediaUrl)
                                              .image,
                                          fit: BoxFit.contain),
                                    ),
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Container(
                              width: w * .35,
                              child: Center(
                                child: Text(
                                  currentTitle,
                                  textDirection:
                                      intl.Bidi.detectRtlDirectionality(
                                              currentTitle)
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "SPProtext"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: w * widget.width,
                        child: Center(
                          child: Text(
                            currentDetails,
                            textDirection: intl.Bidi.detectRtlDirectionality(
                                    currentDetails)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontFamily: "SPProtext"),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
