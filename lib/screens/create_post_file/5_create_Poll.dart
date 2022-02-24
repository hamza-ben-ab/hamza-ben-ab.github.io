import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:uy/services/provider/topic_provider.dart';
import 'package:uy/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uy/widget/topic_list.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({Key key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  firebase_storage.Reference firebaseStorageRef;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String time;
  String postTime;
  String firstName;
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;

  TextEditingController titleController = TextEditingController();
  TextEditingController choiceOneController = TextEditingController();
  TextEditingController choiceTwoController = TextEditingController();
  TextEditingController choiceThreeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> allSubscribers = [];
  List<String> allSubscribersForNotifi = [];
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  final textFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getAllSubscribers();
    getTheFirstName();
    fToast = FToast();
    fToast.init(context);
  }

  doneFunction() {
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
          "choice1": choiceOneController.text.trim(),
          "choice2": choiceTwoController.text.trim(),
          "choice3": choiceThreeController.text.trim(),
          "postKind": "poll",
          "closePoll": false,
          "timeAgo": DateTime.now(),
          "topic": topic,
          "person": tagPerson,
          "event": tagEvent,
          "place": tagPlace,
        }, SetOptions(merge: true)).then((value) {
          allSubscribers.forEach((element) {
            users
                .doc(element)
                .collection("Home")
                .doc("${currentUser.uid}==${time != null ? time : postTime}")
                .set({
              "postKind": "poll",
              "timeAgo": DateTime.now(),
              "topic": topic,
            });
          });
        });
        /*.then(
          (value) => FirebaseFirestore.instance
              .collection("AllPub")
              .doc("${currentUser.uid}==${time != null ? time : postTime}")
              .set(
            {
              "title": titleController.text.trim(),
              "description": descriptionController.text.trim(),
              "choice1": choiceOneController.text.trim(),
              "choice2": choiceTwoController.text.trim(),
              "choice3": choiceThreeController.text.trim(),
              "postKind": "poll",
              "timeAgo": DateTime.now(),
              "topic": topic,
              "person": tagPerson,
              "event": tagEvent,
              "place": tagPlace,
            },
            SetOptions(merge: true),
          ),
        );*/

        Navigator.of(context).pop();
      } else {
        if (topic == null) {
          return toast.showToast(
            S.of(context).snackBarTopic,
            fToast,
            Colors.red[400],
          );
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

  Widget opitionsWidget() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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
        SizedBox(
          height: h * .02,
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
        SizedBox(
          height: h * .02,
        ),
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
        SizedBox(
          height: h * .02,
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
            onHover: (onHover) {}),
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
    String topic = Provider.of<TagPostProvider>(context, listen: false).topic;
    String tagPerson =
        Provider.of<TagPostProvider>(context, listen: false).tagPerson;
    String tagEvent =
        Provider.of<TagPostProvider>(context, listen: false).tagEvent;
    String tagPlace =
        Provider.of<TagPostProvider>(context, listen: false).tagPlace;

    if (topic != null ||
        titleController.text.isNotEmpty ||
        tagEvent != null ||
        tagPerson != null ||
        tagPlace != null ||
        descriptionController.text.isNotEmpty) {
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
    Provider.of<TagPostProvider>(context, listen: false).changeTagTopic(null);
    Provider.of<TagPostProvider>(context, listen: false).changeTagPerson(null);
    Provider.of<TagPostProvider>(context, listen: false).changeTagEvent(null);
    Provider.of<TagPostProvider>(context, listen: false).changeTagPlace(null);

    Navigator.of(context).pop();
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
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            height: h * .1,
            child: Row(
              children: [
                cancelButton(),
                Expanded(
                  child: Center(
                    child: Text(
                      S.of(context).pollTitle,
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
                height: h * .45,
                child: Form(
                  key: textFormKey,
                  child: Row(
                    children: [
                      Container(
                        height: h * .45,
                        width: w * .34,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: h * .08,
                                width: w * .32,
                                child: TextFormFieldWidget(
                                  validate: true,
                                  errorText: "* ${S.of(context).requiredFiled}",
                                  controller: titleController,
                                  hintText: S.of(context).askQuestionTitleHint,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: h * .25,
                                width: w * .32,
                                child: TextFormFieldWidget(
                                  validate: false,
                                  controller: descriptionController,
                                  hintText: S.of(context).descriptionPoll,
                                ),
                              ),
                              SizedBox(height: h * .02),
                              topic != null
                                  ? createPostAllFunctions.topicWidget(h, topic)
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    ),
                              Container(
                                width: w * .34,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: w * .2,
                              height: h * .075,
                              child: TextFormFieldWidget(
                                validate: true,
                                errorText: "* ${S.of(context).requiredFiled}",
                                controller: choiceOneController,
                                hintText: S.of(context).choiceOne,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              width: w * .2,
                              height: h * .075,
                              child: TextFormFieldWidget(
                                validate: true,
                                errorText: "* ${S.of(context).requiredFiled}",
                                controller: choiceTwoController,
                                hintText: S.of(context).choiceTwo,
                              ),
                            ),
                            SizedBox(
                              height: h * .02,
                            ),
                            Container(
                              width: w * .2,
                              height: h * .075,
                              child: TextFormFieldWidget(
                                validate: false,
                                controller: choiceThreeController,
                                hintText: S.of(context).choiceThree,
                              ),
                            ),
                            SizedBox(
                              height: h * .02,
                            ),
                          ],
                        ),
                      )
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
