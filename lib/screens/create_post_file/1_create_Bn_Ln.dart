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
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/services/provider/right_bar_provider.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:uy/services/provider/topic_provider.dart';
import 'package:uy/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uy/widget/topic_list.dart';

class CreateBreakingNews extends StatefulWidget {
  final String kind;
  const CreateBreakingNews({Key key, this.kind}) : super(key: key);

  @override
  _CreateBreakingNewsState createState() => _CreateBreakingNewsState();
}

class _CreateBreakingNewsState extends State<CreateBreakingNews> {
  firebase_storage.Reference firebaseStorageRef;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List<String> allSubscribers = [];
  List<String> allSubscribersForNotifi = [];
  TeltrueWidget toast = TeltrueWidget();
  final textFormKey = GlobalKey<FormState>();
  bool loading = false;
  String time;
  String fileName;
  String userName;
  String extension;
  String postTime;
  String mediaUrl;
  double percentage;
  Uint8List uploadedImage;
  FToast fToast;
  String firstName;

  @override
  void initState() {
    super.initState();
    getAllSubscribers();
    getTheFirstName();
    fToast = FToast();
    fToast.init(context);
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

  doneFunctionBreakingNews() {
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    String tagPerson =
        Provider.of<TagPostProvider>(context, listen: false).tagPerson;
    String tagEvent =
        Provider.of<TagPostProvider>(context, listen: false).tagEvent;
    String tagPlace =
        Provider.of<TagPostProvider>(context, listen: false).tagPlace;
    postTime = "${DateTime.now()}".split('.').first;

    if (textFormKey.currentState.validate()) {
      if (topic != null) {
        users
            .doc(currentUser.uid)
            .collection("Pub")
            .doc("${time != null ? time : postTime}")
            .set({
          "title": titleController.text.trim(),
          "description": descriptionController.text.trim(),
          "postKind": "breaking_news",
          "timeAgo": DateTime.now(),
          "topic": topic,
          "person": tagPerson,
          "event": tagEvent,
          "place": tagPlace,
          "mediaUrl": mediaUrl,
          "extension": extension,
          "close": false,
        }, SetOptions(merge: true)).then((value) {
          allSubscribers.forEach((element) {
            users
                .doc(element)
                .collection("Breaking News")
                .doc("${currentUser.uid}==${time != null ? time : postTime}")
                .set({
              "timeAgo": DateTime.now(),
              "seen": false,
              "close": false,
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
            "mediaUrl": mediaUrl,
            "postKind": "breaking_news",
            "timeAgo": DateTime.now(),
          },
          SetOptions(merge: true),
        );
        Provider.of<RightBarProvider>(context, listen: false).refresh();
        Navigator.of(context).pop();
      } else {
        if (topic == null) {
          return toast.showToast(
              S.of(context).snackBarTopic, fToast, Colors.red[400]);
        }
      }
    }
  }

  doneFunctionLastestNews() {
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    String tagPerson =
        Provider.of<TagPostProvider>(context, listen: false).tagPerson;
    String tagEvent =
        Provider.of<TagPostProvider>(context, listen: false).tagEvent;
    String tagPlace =
        Provider.of<TagPostProvider>(context, listen: false).tagPlace;
    postTime = "${DateTime.now()}".split('.').first;

    if (textFormKey.currentState.validate()) {
      if (topic != null) {
        users
            .doc(currentUser.uid)
            .collection("Pub")
            .doc("${time != null ? time : postTime}")
            .set({
          "title": titleController.text.trim(),
          "description": descriptionController.text.trim(),
          "postKind": "lastest_news",
          "timeAgo": DateTime.now(),
          "topic": topic,
          "person": tagPerson,
          "event": tagEvent,
          "place": tagPlace,
          "mediaUrl": mediaUrl,
          "extension": extension,
          "close": false,
        }, SetOptions(merge: true)).then((value) {
          allSubscribers.forEach((element) {
            users
                .doc(element)
                .collection("Home")
                .doc("${currentUser.uid}==${time != null ? time : postTime}")
                .set({
              "postKind": "lastest_news",
              "timeAgo": DateTime.now(),
              "topic": topic,
            });
          });
        }).then(
          (value) => FirebaseFirestore.instance
              .collection("AllPub")
              .doc("${currentUser.uid}==${time != null ? time : postTime}")
              .set(
            {
              "title": titleController.text.trim(),
              "description": descriptionController.text.trim(),
              "postKind": "lastest_news",
              "timeAgo": DateTime.now(),
              "topic": topic,
              "person": tagPerson,
              "event": tagEvent,
              "place": tagPlace,
              "mediaUrl": mediaUrl,
              "extension": extension,
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
            "postKind": "lastest_news",
            "timeAgo": DateTime.now(),
          },
          SetOptions(merge: true),
        );

        Navigator.of(context).pop();
      } else {
        if (topic == null) {
          return toast.showToast(
              S.of(context).snackBarTopic, fToast, Colors.red[400]);
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
    querySnapshot.docs
        .map((doc) => allSubscribersForNotifi.add(doc.id))
        .toList();
  }

  Future filePicker() async {
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imagesFormat.contains(extension)
                    ? Center(
                        child: Container(
                          height: h * .4,
                          width: w * .3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.network(mediaUrl).image),
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

  Widget opitionsWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HoverWidget(
          child: createPostAllFunctions.uploadButton(
              false, h, w, filePicker, S.of(context).uploadButton),
          hoverChild: createPostAllFunctions.uploadButton(
              true, h, w, filePicker, S.of(context).uploadButton),
          onHover: (onHover) {},
        ),

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
          child: createPostAllFunctions.tagPersonButton(false, h, w),
          hoverChild: createPostAllFunctions.tagPersonButton(true, h, w),
          onHover: (onHover) {},
        ),
        //tag event
        HoverWidget(
          child: createPostAllFunctions.tagEventButton(false, h, w),
          hoverChild: createPostAllFunctions.tagEventButton(
            true,
            h,
            w,
          ),
          onHover: (onHover) {},
        ),
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
          onHover: (onHover) {},
        ),
      ],
    );
  }

  cancelFunction() {
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    String tagPerson =
        Provider.of<TagPostProvider>(context, listen: false).tagPerson;
    String tagEvent =
        Provider.of<TagPostProvider>(context, listen: false).tagEvent;
    String tagPlace =
        Provider.of<TagPostProvider>(context, listen: false).tagPlace;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (mediaUrl != null ||
        titleController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        topic != null ||
        tagEvent != null ||
        tagPerson != null ||
        tagPlace != null) {
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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String topic = Provider.of<TagPostProvider>(context).topic;
    String tagPerson = Provider.of<TagPostProvider>(context).tagPerson;
    String tagEvent = Provider.of<TagPostProvider>(context).tagEvent;
    String tagPlace = Provider.of<TagPostProvider>(context).tagPlace;

    return Builder(builder: (context) {
      return Column(children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            height: h * .1,
            width: w * .7,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                cancelButton(),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        widget.kind == "breaking_news"
                            ? S.of(context).createPostBreakingNewsTitle
                            : S.of(context).createPostLastestNewsTitle,
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: "SPProtext"),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: w * .1,
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: createPostAllFunctions.doneButton(
                      h,
                      w,
                      S.of(context).doneButton,
                      widget.kind == "breaking_news"
                          ? doneFunctionBreakingNews
                          : doneFunctionLastestNews,
                    ),
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
                child: Form(
                  key: textFormKey,
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
                                child: TextFormFieldWidget(
                                  validate: true,
                                  errorText: "* ${S.of(context).requiredFiled}",
                                  controller: titleController,
                                  hintText: widget.kind == "breaking_news"
                                      ? S
                                          .of(context)
                                          .addPostBreakingNewsTitleHint
                                      : S
                                          .of(context)
                                          .createPostLastestNewsTitle,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              uploadWidget(),
                              topic != null
                                  ? createPostAllFunctions.topicWidget(h, topic)
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
                                    createPostAllFunctions.tagPlace(w, tagPlace)
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
                      Container(
                        height: h * .65,
                        width: w * .35,
                        child: TextFormFieldWidget(
                          validate: true,
                          errorText: "* ${S.of(context).requiredFiled}",
                          controller: descriptionController,
                          hintText:
                              "${S.of(context).addPostBreakingNewsDesHint} ${firstName ?? ""}",
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]);
    });
  }
}
