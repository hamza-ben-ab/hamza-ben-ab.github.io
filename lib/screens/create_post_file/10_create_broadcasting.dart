import 'dart:io';
import 'dart:async';
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
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:uy/services/provider/topic_provider.dart';
import 'package:uy/widget/toast.dart';
import 'package:uy/widget/topic_list.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateBroadcasting extends StatefulWidget {
  final String kind;
  final bool video;

  const CreateBroadcasting({Key key, this.kind, this.video}) : super(key: key);
  @override
  _CreateBroadcastingState createState() => _CreateBroadcastingState();
}

class _CreateBroadcastingState extends State<CreateBroadcasting> {
  firebase_storage.Reference firebaseStorageRef;
  String time;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  File video;
  bool loading = false;
  VideoPlayerController videoPlayerController;
  String postTime;
  double percentage;
  String extension;
  String mediaUrl;
  List<String> allSubscribers = [];
  TextEditingController description = TextEditingController();
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;

  @override
  void initState() {
    super.initState();
    getAllSubscribers();
    fToast = FToast();
    fToast.init(context);
  }

  Widget opitionsWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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

  Function doneFunction() {
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    String tagPerson =
        Provider.of<TagPostProvider>(context, listen: false).tagPerson;
    String tagEvent =
        Provider.of<TagPostProvider>(context, listen: false).tagEvent;
    String tagPlace =
        Provider.of<TagPostProvider>(context, listen: false).tagPlace;
    postTime = "${DateTime.now()}".split('.').first;

    if (topic != null) {
      users
          .doc(currentUser.uid)
          .collection("Pub")
          .doc("${time != null ? time : postTime}")
          .set({
        "postKind": widget.video ? "broadcasting" : "inPic",
        "topic": topic,
        "timeAgo": DateTime.now(),
        "description": description.text.trim(),
        "person": tagPerson,
        "event": tagEvent,
        "place": tagPlace,
        "mediaUrl": mediaUrl,
        "extension": extension,
        "views": 0,
        "report": 0
      }, SetOptions(merge: true)).then((value) {
        allSubscribers.forEach((element) {
          users
              .doc(element)
              .collection("Watch")
              .doc("${currentUser.uid}==${time != null ? time : postTime}")
              .set({
            "timeAgo": DateTime.now(),
            "postKind": widget.video ? "broadcasting" : "inPic",
            "mediaUrl": mediaUrl,
            "seen": false,
          });
        });
      }).then(
        (value) => FirebaseFirestore.instance
            .collection("AllPub")
            .doc("${currentUser.uid}==${time != null ? time : postTime}")
            .set(
          {
            "postKind": widget.video ? "broadcasting" : "inPic",
            "timeAgo": DateTime.now(),
            "mediaUrl": mediaUrl,
            "description": description.text.trim(),
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
          "postKind": widget.video ? "broadcasting" : "inPic",
          "timeAgo": DateTime.now(),
        },
        SetOptions(merge: true),
      );

      Navigator.of(context).pop();
    } else {
      if (topic == null) {
        return toast.showToast(
            S.of(context).snackBarTopic, fToast, Colors.red[400]);
      } else if (mediaUrl == null) {
        return toast.showToast(
            widget.video
                ? S.of(context).snackBarUplodVideo
                : S.of(context).snackBarUplodPicture,
            fToast,
            Colors.red[400]);
      } else if (description.text.isEmpty) {
        return toast.showToast(
            S.of(context).snackBarEmptyDes, fToast, Colors.red[400]);
      }
    }

    return null;
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
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: widget.video ? FileType.video : FileType.image);
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
      await users.doc(currentUser.uid).collection("Pub").doc(time).set({
        "mediaUrl": mediaUrl,
      }, SetOptions(merge: true));
      await users.doc(currentUser.uid).collection(" Post Videos").doc(time).set(
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
        tagPerson != null ||
        tagPlace != null ||
        tagEvent != null ||
        description.text.isNotEmpty ||
        topic != null) {
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
  void dispose() {
    if (videoPlayerController != null) videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String topic = Provider.of<TagPostProvider>(context).topic;
    String tagPerson = Provider.of<TagPostProvider>(context).tagPerson;
    String tagEvent = Provider.of<TagPostProvider>(context).tagEvent;
    String tagPlace = Provider.of<TagPostProvider>(context).tagPlace;
    String smile = Provider.of<TagPostProvider>(context).smile;
    String feel = Provider.of<TagPostProvider>(context).feel;
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
                        widget.video
                            ? S.of(context).createPostBroadcastTitle
                            : S.of(context).createPostInpicTitle,
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: "SPProtext"),
                      ),
                    ),
                  ),
                  Container(
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: w * .55,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: h * .45,
                                width: w * .2,
                                child: opitionsWidget(),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              height: h * .45,
                              child: uploadWidget(),
                            ),
                          ),
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
                      width: w * .55,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          createPostAllFunctions.tagFeeling(h, w, smile, feel),
                          createPostAllFunctions.tagPerson(w, tagPerson),
                          createPostAllFunctions.tagEvent(w, tagEvent),
                          createPostAllFunctions.tagPlace(w, tagPlace)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * .01,
                    ),
                    Center(
                      child: Container(
                        height: h * .25,
                        width: w * .55,
                        child: TextFormFieldWidget(
                          hintText: widget.video
                              ? S.of(context).broadcastingHintTextDes
                              : S.of(context).inPictureHintTextDes,
                          controller: description,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
