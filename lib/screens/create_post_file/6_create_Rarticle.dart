import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uy/screens/search/hover.dart';
import 'package:uy/widget/topic_list.dart';

class CreateResearchArticle extends StatefulWidget {
  const CreateResearchArticle({Key key}) : super(key: key);

  @override
  _CreateResearchArticleState createState() => _CreateResearchArticleState();
}

class _CreateResearchArticleState extends State<CreateResearchArticle> {
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  firebase_storage.Reference firebaseStorageRef;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  TextEditingController titleController = TextEditingController();
  TextEditingController abstractController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();
  TextEditingController correspondenceController = TextEditingController();
  TextEditingController referencesController = TextEditingController();
  TextEditingController introductionController = TextEditingController();
  TextEditingController writersController = TextEditingController();
  TextEditingController titlePartController = TextEditingController();
  TextEditingController desPartController = TextEditingController();
  TextEditingController conclusionController = TextEditingController();
  String time;
  String fileName;
  String userName;
  String postTime;
  String mediaUrl;
  String extension;
  String stringValue;
  String firstName;
  double percentage;
  bool loading = false;
  List<String> allSubscribers = [];
  final textFormKey = GlobalKey<FormState>();
  final paragraphFormKey = GlobalKey<FormState>();
  List<String> readersList = [];

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
          readersList.remove(label);
        });
      },
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(10.0),
    );
  }

  doneFunction() {
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    List<Map<String, dynamic>> paragraphList =
        Provider.of<SearchArticleProvider>(context, listen: false)
            .paragraphList;

    postTime = "${DateTime.now()}".split('.').first;

    if (textFormKey.currentState.validate()) {
      if (topic != null && paragraphList.isNotEmpty) {
        users
            .doc(currentUser.uid)
            .collection("Pub")
            .doc("${time != null ? time : postTime}")
            .set({
          "postKind": "research article",
          "timeAgo": DateTime.now(),
          "topic": topic,
          "references": referencesController.text.trim(),
          "conclusion": conclusionController.text.trim(),
          "title": titleController.text.trim(),
          "writers": readersList,
          "intro": introductionController.text.trim(),
          "abstract": abstractController.text.trim(),
          "paragraph": paragraphList,
          "keywords": keywordsController.text.trim(),
          "correspondence": correspondenceController.text.trim(),
          "readers": 0,
          "report": 0
        }, SetOptions(merge: true)).then((value) {
          allSubscribers.forEach((element) {
            users
                .doc(element)
                .collection("Home")
                .doc("${currentUser.uid}==${time != null ? time : postTime}")
                .set({
              "postKind": "research article",
              "timeAgo": DateTime.now(),
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
              "postKind": "research article",
              "title": titleController.text.trim(),
              "timeAgo": DateTime.now(),
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
            "postKind": "research article",
            "timeAgo": DateTime.now(),
          },
          SetOptions(merge: true),
        );

        Navigator.of(context).pop();
      } else {
        if (topic == null) {
          return toast.showToast(
              S.of(context).snackBarTopic, fToast, Colors.red[400]);
        } else if (paragraphList.isEmpty) {
          return toast.showToast(
              S.of(context).snackBarAddParagph, fToast, Colors.red[400]);
        }
      }

      mediaUrl = null;
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

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringValue = Locale(prefs.getString('langkey')).toString();
    });
  }

  alertDialogCancelFunction() {
    Navigator.of(context).pop();
  }

  cancelFunction() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (titleController.text.isNotEmpty ||
        readersList.isNotEmpty ||
        keywordsController.text.isNotEmpty ||
        correspondenceController.text.isNotEmpty ||
        abstractController.text.isNotEmpty ||
        introductionController.text.isNotEmpty) {
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
    } else {
      Navigator.of(context).pop();
    }
  }

  discardFunction() {
    users.doc(currentUser.uid).collection("Pub").doc(time).delete();
    Provider.of<TagPostProvider>(context, listen: false).changeTagTopic(null);
    Provider.of<SearchArticleProvider>(context, listen: false).emptyList();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    getAllSubscribers();
    getTheFirstName();
    postTime = "${DateTime.now()}".split('.').first;
    fToast = FToast();
    fToast.init(context);
  }

  Widget addPartArticle() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      width: w * .55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey[400]),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Form(
            key: paragraphFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: h * .06,
                  width: w * .3,
                  child: TextFormFieldWidget(
                    validate: false,
                    controller: titlePartController,
                    hintText: S.of(context).createAnalysisPartTitle,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: h * .45,
                  width: w * .3,
                  child: TextFormFieldWidget(
                    validate: true,
                    errorText: "* ${S.of(context).requiredFiled}",
                    controller: desPartController,
                    hintText: S.of(context).createAnalysisPartDetails,
                  ),
                )
              ],
            ),
          ),
          uploadWidget()
        ],
      ),
    );
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
          color: Colors.grey[50],
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

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String topic = Provider.of<TagPostProvider>(context).topic;
    List<Map<String, dynamic>> paragraphList =
        Provider.of<SearchArticleProvider>(context).paragraphList;
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
                      S.of(context).addPostArticle,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
                Container(
                  width: w * .1,
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
          child: Container(
            child: SingleChildScrollView(
              child: Form(
                key: textFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: h * .35,
                      width: w * .58,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Container(
                            height: h * .35,
                            width: w * .3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //General title
                                Container(
                                  height: h * .1,
                                  width: w * .29,
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
                                SizedBox(
                                  height: 10.0,
                                ),
                                // Add writters Button
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: h * .06,
                                        width: w * .2,
                                        child: TextFormFieldWidget(
                                          validate: false,
                                          controller: writersController,
                                          hintText: S
                                              .of(context)
                                              .addPostArticleWrittersHintText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          readersList.add(
                                              writersController.text.trim());

                                          setState(() {});
                                          writersController.clear();
                                        },
                                        child: HoverWidget(
                                            child: createPostAllFunctions
                                                .addbuttonWidget(false, h),
                                            hoverChild: createPostAllFunctions
                                                .addbuttonWidget(true, h),
                                            onHover: (onHover) {}),
                                      ).xShowPointerOnHover,
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                //topic
                                InkWell(
                                  onTap: () {
                                    Provider.of<TopicProvider>(context,
                                            listen: false)
                                        .backTo(0);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            elevation: 0.0,
                                            child: ShowTopicList(),
                                          );
                                        });
                                  },
                                  child: HoverWidget(
                                    child: createPostAllFunctions.topicButton(
                                        false, h, w, S.of(context).topicButton),
                                    hoverChild:
                                        createPostAllFunctions.topicButton(true,
                                            h, w, S.of(context).topicButton),
                                    onHover: (onHover) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: h * .35,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //KeyWord
                                Container(
                                  height: h * .15,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: false,
                                    controller: keywordsController,
                                    hintText:
                                        S.of(context).addPostArticleKeywords,
                                  ),
                                ),
                                //coresspondence
                                Container(
                                  height: h * .15,
                                  width: w * .25,
                                  child: TextFormFieldWidget(
                                    validate: false,
                                    controller: correspondenceController,
                                    hintText: S
                                        .of(context)
                                        .addPostArticleCoresspondence,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            for (int i = 0; i < readersList.length; i++)
                              buildChip(readersList[i], Colors.blueGrey[300])
                          ]),
                    ),
                    SizedBox(height: h * .02),
                    topic != null
                        ? createPostAllFunctions.topicWidget(h, topic)
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),
                    SizedBox(height: h * .02),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          //Abstract
                          Container(
                            width: w * .27,
                            height: h * .22,
                            child: TextFormFieldWidget(
                              validate: true,
                              errorText: "* ${S.of(context).requiredFiled}",
                              controller: abstractController,
                              hintText: S.of(context).addPostArticleAbstract,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          //introduction
                          Container(
                            width: w * .27,
                            height: h * .22,
                            child: TextFormFieldWidget(
                              validate: true,
                              errorText: "* ${S.of(context).requiredFiled}",
                              controller: introductionController,
                              hintText: S.of(context).addPostArticleIntro,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * .05),
                    addPartArticle(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [addParagraph()],
                      ),
                    ),
                    SizedBox(height: h * .02),
                    Container(
                      height: h * .2,
                      width: w * .55,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: h * .2,
                            width: w * .27,
                            child: TextFormFieldWidget(
                              validate: false,
                              controller: referencesController,
                              hintText: S.of(context).articleReference,
                            ),
                          ),
                          Container(
                            height: h * .2,
                            width: w * .24,
                            child: TextFormFieldWidget(
                              validate: true,
                              errorText: "* ${S.of(context).requiredFiled}",
                              controller: conclusionController,
                              hintText: S.of(context).addPostArticleConclusion,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * .01),
                    for (int i = 0; i < paragraphList.length; i++)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlobalStepWidget(
                          list: paragraphList,
                          width: .55,
                          callback: refresh,
                          i: i,
                          currentDetails: paragraphList[i]["details"],
                          currentTitle: paragraphList[i]["title"],
                          mediaUrl: mediaUrl,
                        ),
                      ),
                    SizedBox(
                      height: h * .03,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]);
    });
  }

  Widget addParagraph() {
    double h = MediaQuery.of(context).size.height;
    return InkWell(
        child: HoverWidget(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: h * .05,
              decoration: BoxDecoration(
                color: button2Color,
                borderRadius: BorderRadius.circular(15.0),
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
                borderRadius: BorderRadius.circular(15.0),
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
        onTap: () {
          if (paragraphFormKey.currentState.validate()) {
            if (desPartController.text.isNotEmpty) {
              Provider.of<SearchArticleProvider>(context, listen: false)
                  .addPart({
                "title": titlePartController.text.trim(),
                "details": desPartController.text.trim(),
                "mediaUrl": mediaUrl
              });

              titlePartController.clear();
              desPartController.clear();
              mediaUrl = null;
              setState(() {});
            }
          }
        });
  }
}
