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
import 'package:uy/screens/create_post_file/7_create_HowTo.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/services/provider/article_search_provider.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:uy/services/provider/topic_provider.dart';
import 'package:uy/widget/toast.dart';
import 'package:uy/widget/topic_list.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateAnalysisAndReview extends StatefulWidget {
  final String create;
  const CreateAnalysisAndReview({Key key, this.create}) : super(key: key);

  @override
  _CreateAnalysisAndReviewState createState() =>
      _CreateAnalysisAndReviewState();
}

class _CreateAnalysisAndReviewState extends State<CreateAnalysisAndReview> {
  firebase_storage.Reference firebaseStorageRef;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  bool loading = false;
  String time;
  String userName;
  String extension;
  String postTime;
  String mediaUrl;
  String firstName;

  VideoPlayerController videoPlayerController;
  double percentage;
  Uint8List uploadedImage;
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;

  TextEditingController titleController = TextEditingController();
  TextEditingController paragraphdescriptionController =
      TextEditingController();
  TextEditingController paragraphtitleController = TextEditingController();
  TextEditingController currentCityController = TextEditingController();
  TextEditingController biograpphyController = TextEditingController();
  List<String> allSubscribers = [];
  final textFormKey = GlobalKey<FormState>();
  final paragraphFormKey = GlobalKey<FormState>();
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

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

  Widget opitionsWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HoverWidget(
            child: createPostAllFunctions.uploadButton(
                false, h, w, filePicker, S.of(context).uploadButton),
            hoverChild: createPostAllFunctions.uploadButton(
                true, h, w, filePicker, S.of(context).uploadButton),
            onHover: (onHover) {}),

        //topic
        InkWell(
          onTap: () {
            Provider.of<TopicProvider>(context, listen: false).backTo(0);
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
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

        //tag Person
        HoverWidget(
            child: createPostAllFunctions.tagPersonButton(
              false,
              h,
              w,
            ),
            hoverChild: createPostAllFunctions.tagPersonButton(
              true,
              h,
              w,
            ),
            onHover: (onHover) {}),
        //tag event
        HoverWidget(
            child: createPostAllFunctions.tagEventButton(
              false,
              h,
              w,
            ),
            hoverChild: createPostAllFunctions.tagEventButton(
              true,
              h,
              w,
            ),
            onHover: (onHover) {}),
        //tag place
        HoverWidget(
            child: createPostAllFunctions.tagPlaceButton(
              false,
              h,
              w,
            ),
            hoverChild: createPostAllFunctions.tagPlaceButton(
              true,
              h,
              w,
            ),
            onHover: (onHover) {}),
      ],
    );
  }

  doneFunction() {
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    String tagPerson =
        Provider.of<TagPostProvider>(context, listen: false).tagPerson;
    String tagEvent =
        Provider.of<TagPostProvider>(context, listen: false).tagEvent;
    String tagPlace =
        Provider.of<TagPostProvider>(context, listen: false).tagPlace;
    List<Map<String, dynamic>> parapraphList =
        Provider.of<SearchArticleProvider>(context, listen: false)
            .paragraphList;
    postTime = "${DateTime.now()}".split('.').first;

    if (textFormKey.currentState.validate()) {
      if (topic != null && parapraphList.isNotEmpty) {
        users
            .doc(currentUser.uid)
            .collection("Pub")
            .doc("${time != null ? time : postTime}")
            .set({
          "postKind":
              widget.create == "analysis" ? "analysis" : "investigation",
          "topic": topic,
          "timeAgo": DateTime.now(),
          "title": titleController.text.trim(),
          "person": tagPerson,
          "event": tagEvent,
          "place": tagPlace,
          "paragraph": parapraphList,
          "mediaUrl": mediaUrl,
          "readers": 0,
          widget.create == "analysis" ? null : "false": 0,
          "report": 0
        }, SetOptions(merge: true)).then((value) {
          allSubscribers.forEach((element) {
            users
                .doc(element)
                .collection("Home")
                .doc("${currentUser.uid}==${time != null ? time : postTime}")
                .set({
              "timeAgo": DateTime.now(),
              "postKind":
                  widget.create == "analysis" ? "analysis" : "investigation",
              "topic": topic,
              "seen": false,
            });
          });
        }).then(
          (value) => FirebaseFirestore.instance
              .collection("AllPub")
              .doc("${currentUser.uid}==${time != null ? time : postTime}")
              .set(
            {
              "title": titleController.text.trim(),
              "postKind":
                  widget.create == "analysis" ? "analysis" : "investigation",
              "timeAgo": DateTime.now(),
              "topic": topic,
              "person": tagPerson,
              "event": tagEvent,
              "place": tagPlace,
              "lastRead": 0,
              "lastTimeRead": DateTime.now(),
              "growOrder": 0,
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
            "postKind":
                widget.create == "analysis" ? "analysis" : "investigation",
            "timeAgo": DateTime.now(),
          },
          SetOptions(merge: true),
        );
        Navigator.of(context).pop();
      } else {
        if (topic == null) {
          return toast.showToast(
              S.of(context).snackBarTopic, fToast, Colors.red[400]);
        } else if (parapraphList.isEmpty) {
          return toast.showToast("", fToast, Colors.red[400]);
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

  Widget uploadWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return mediaUrl == null
        ? Container(
            width: w * .3,
            height: h * .4,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: !loading
                ? Center(
                    child: Container(
                      height: h * .4,
                      width: w * .3,
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
                width: w * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: imagesFormat.contains(extension)
                    ? Center(
                        child: Container(
                          height: h * .4,
                          width: w * .3,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: Image.network(mediaUrl).image,
                            ),
                          ),
                        ),
                      )
                    : videoFormat.contains(extension)
                        ? Center(
                            child: Container(
                              height: h * .4,
                              width: w * .3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: VideoViewChat(
                                  videoUrl: mediaUrl,
                                  isFile: false,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),
              ),
              Positioned(
                right: 30.0,
                top: 10.0,
                child: InkWell(
                  onTap: () async {
                    await users
                        .doc(currentUser.uid)
                        .collection("Pub")
                        .doc(time)
                        .delete();
                    createPostAllFunctions.deleteFireBaseStorageItem(mediaUrl);

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
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    String tagPerson =
        Provider.of<TagPostProvider>(context, listen: false).tagPerson;
    String tagEvent =
        Provider.of<TagPostProvider>(context, listen: false).tagEvent;
    String tagPlace =
        Provider.of<TagPostProvider>(context, listen: false).tagPlace;
    List<Map<String, dynamic>> parapraphList =
        Provider.of<SearchArticleProvider>(context, listen: false)
            .paragraphList;
    if (mediaUrl != null ||
        titleController.text.isNotEmpty ||
        topic != null ||
        parapraphList.isNotEmpty ||
        tagPerson != null ||
        tagPlace != null ||
        tagEvent != null) {
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
    mediaUrl = null;
    Provider.of<TagPostProvider>(context, listen: false).changeTagTopic(null);
    Provider.of<TagPostProvider>(context, listen: false).changeTagPerson(null);
    Provider.of<TagPostProvider>(context, listen: false).changeTagEvent(null);
    Provider.of<TagPostProvider>(context, listen: false).changeTagPlace(null);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  alertDialogCancelFunction() {
    Navigator.of(context).pop();
  }

  Widget addParagraphe() {
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
                  S.of(context).createAnalysisAddpart,
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
                  S.of(context).createAnalysisAddpart,
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
          onHover: (onHover) {}),
      onTap: () async {
        if (paragraphdescriptionController.text.isNotEmpty) {
          Provider.of<SearchArticleProvider>(context, listen: false).addPart({
            "title": paragraphtitleController.text,
            "details": paragraphdescriptionController.text
          });
          paragraphtitleController.clear();
          paragraphdescriptionController.clear();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String topic = Provider.of<TagPostProvider>(context).topic;
    String tagPerson = Provider.of<TagPostProvider>(context).tagPerson;
    String tagEvent = Provider.of<TagPostProvider>(context).tagEvent;
    String tagPlace = Provider.of<TagPostProvider>(context).tagPlace;
    List<Map<String, dynamic>> parapraphList =
        Provider.of<SearchArticleProvider>(context).paragraphList;
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
                        widget.create == "analysis"
                            ? S.of(context).createAnalysisTitle
                            : S.of(context).createPostInvestigationTitle,
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
          SizedBox(
            height: h * .03,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: h * .1,
                    width: w * .7,
                    child: opitionsWidget(),
                  ),
                  Container(
                    width: w * .7,
                    height: h * .65,
                    child: Row(
                      children: [
                        Container(
                          height: h * .65,
                          width: w * .34,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: h * .12,
                                  width: w * .32,
                                  child: Form(
                                    key: textFormKey,
                                    child: TextFormFieldWidget(
                                      validate: true,
                                      errorText:
                                          "* ${S.of(context).requiredFiled}",
                                      controller: titleController,
                                      hintText: S
                                          .of(context)
                                          .addPostArticleGeneralTitle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                uploadWidget(),
                                topic != null
                                    ? createPostAllFunctions.topicWidget(
                                        h, topic)
                                    : Container(
                                        height: 0.0,
                                        width: 0.0,
                                      ),
                                Container(
                                  width: w * .34,
                                  //padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      createPostAllFunctions.tagPerson(
                                          w, tagPerson),
                                      createPostAllFunctions.tagEvent(
                                          w, tagEvent),
                                      createPostAllFunctions.tagPlace(
                                          w, tagPlace)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: h * .01,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Container(
                                  height: h * .07,
                                  width: w * .4,
                                  child: TextFormFieldWidget(
                                    validate: false,
                                    controller: paragraphtitleController,
                                    hintText:
                                        S.of(context).createAnalysisPartTitle,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  height: h * .45,
                                  width: w * .4,
                                  child: TextFormFieldWidget(
                                    validate: true,
                                    errorText:
                                        "* ${S.of(context).requiredFiled}",
                                    controller: paragraphdescriptionController,
                                    hintText:
                                        S.of(context).createAnalysisPartDetails,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [addParagraphe()],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  for (int i = 0; i < parapraphList.length; i++)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GlobalStepWidget(
                        list: parapraphList,
                        width: .65,
                        callback: refresh,
                        i: i,
                        currentDetails: parapraphList[i]["details"],
                        currentTitle: parapraphList[i]["title"],
                      ),
                    ),
                  SizedBox(
                    height: h * .01,
                  ),
                ],
              ),
            ),
          ),

          /* Expanded(
            child: Container(
              width: w * .65,
              padding: EdgeInsets.only(left: 10.0, right: 5.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Container(
                      width: w * .65,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: h * .5,
                                width: w * .3,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    opitionsWidget(),
                                    uploadWidget(),
                                  ],
                                ),
                              ),
                              topic != null
                                  ? createPostAllFunctions.topicWidget(h, topic)
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    ),
                              Container(
                                width: w * .3,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    createPostAllFunctions.tagFeeling(
                                        h, w, smile, feel),
                                    createPostAllFunctions.tagPerson(
                                        w, tagPerson),
                                    createPostAllFunctions.tagEvent(
                                        w, tagEvent),
                                    createPostAllFunctions.tagPlace(w, tagPlace)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: h * .01,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20.0,
                          ),

                          Expanded(
                            child: Container(
                              child: Column(
                                children: [

                                  Container(
                                    height: h * .07,
                                    width: w * .4,
                                    child: TextFormFieldWidget(
                                      validate: true,
                                      errorText:
                                          "* ${S.of(context).requiredFiled}",
                                      controller: paragraphtitleController,
                                      hintText:
                                          S.of(context).createAnalysisPartTitle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    height: h * .45,
                                    width: w * .4,
                                    child: TextFormFieldWidget(
                                      validate: true,
                                      errorText:
                                          "* ${S.of(context).requiredFiled}",
                                      controller:
                                          paragraphdescriptionController,
                                      hintText: S
                                          .of(context)
                                          .createAnalysisPartDetails,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [addParagraphe()],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 30.0,
                    ),
                    for (int i = 0;
                        i < CreateAnalysisAndReview.parapraphList.length;
                        i++)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlobalStepWidget(
                          list: CreateAnalysisAndReview.parapraphList,
                          width: .5,
                          callback: refresh,
                          i: i,
                          currentDetails: CreateAnalysisAndReview
                              .parapraphList[i]["details"],
                          currentTitle: CreateAnalysisAndReview.parapraphList[i]
                              ["title"],
                        ),
                      ),
                    SizedBox(
                      height: h * .03,
                    ),
                  ],
                ),
              ),
            ),
          ),*/
        ],
      );
    });
  }
}
