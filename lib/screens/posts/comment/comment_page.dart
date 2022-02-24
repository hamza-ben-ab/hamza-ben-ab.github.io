import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/comment_loading.dart';
import 'package:uy/screens/posts/comment/comment_widget.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:intl/intl.dart' as intl;

class PostCommentPage extends StatefulWidget {
  const PostCommentPage({
    Key key,
  }) : super(key: key);
  @override
  _PostCommentPageState createState() => _PostCommentPageState();
}

class _PostCommentPageState extends State<PostCommentPage> {
  TextEditingController commentController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  ScrollController scrollController = ScrollController();
  int counter = 0;
  List<String> list = [];

  scroll() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  }

  Future getTheCommentsCount(String userId, String id) async {
    QuerySnapshot count = await users
        .doc(userId)
        .collection("Pub")
        .doc(id)
        .collection("Comments")
        .get();
    count.docs.forEach((user) {
      list.add(user.id.toString().split("==").first);
    });

    setState(() {
      counter = list.toSet().toList().length;
    });
  }

  Widget addCommentButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: hover ? Colors.grey[300] : Colors.grey[200],
      ),
      height: h * .08,
      width: h * .06,
      child: Center(
        child: Icon(Icons.send, color: Colors.blue),
      ),
    );
  }

  Future addCommentFunction(
    String userId,
    String id,
  ) async {
    DocumentSnapshot user = await users.doc(currentUser.uid).get();
    DocumentSnapshot pub =
        await users.doc(userId).collection("Pub").doc(id).get();
    getTheCommentsCount(userId, id);
    String postTime = "${DateTime.now()}".split('.').first;

    if (commentController.text.isNotEmpty) {
      await users
          .doc(userId)
          .collection("Pub")
          .doc(id)
          .collection("Comments")
          .doc("${currentUser.uid}==$postTime")
          .set({
        "timeAgo": DateTime.now(),
        "comment": commentController.text.trim(),
      });

      if (userId != currentUser.uid) {
        await users
            .doc(userId)
            .collection("Notifications")
            .doc("$userId*comment*$id")
            .set({
          "seen": false,
          "timeAgo": DateTime.now(),
          "title": commentController.text.trim(),
          "count": counter,
          "postKind": "comment",
          "pubKind": pub.data()["postKind"],
          "userName": user.data()["full_name"],
          "userId": userId,
          "id": id,
          "uid": currentUser.uid
        });
      }
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ReadPostProvider>(context).userId;
    String id = Provider.of<ReadPostProvider>(context).doc;
    return Column(
      children: [
        Container(
          height: h * .08,
          width: w * .25,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            children: [
              Container(
                height: h * .07,
                width: w * .21,
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontFamily: "SPProtext"),
                  textAlign: TextAlign.center,
                  controller: commentController,
                  onEditingComplete: () async {
                    DocumentSnapshot user =
                        await users.doc(currentUser.uid).get();
                    DocumentSnapshot pub =
                        await users.doc(userId).collection("Pub").doc(id).get();
                    getTheCommentsCount(userId, id);
                    String postTime = "${DateTime.now()}".split('.').first;

                    if (commentController.text.isNotEmpty) {
                      await users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("Comments")
                          .doc("${currentUser.uid}==$postTime")
                          .set({
                        "timeAgo": DateTime.now(),
                        "comment": commentController.text.trim(),
                      });
                      if (userId != currentUser.uid) {
                        await users
                            .doc(userId)
                            .collection("Notifications")
                            .doc("$userId*comment*$id")
                            .set({
                          "seen": false,
                          "timeAgo": DateTime.now(),
                          "title": commentController.text.trim(),
                          "count": counter - 1,
                          "postKind": "comment",
                          "pubKind": pub.data()["postKind"],
                          "userName": user.data()["full_name"],
                          "userId": userId,
                          "id": id,
                          "uid": currentUser.uid
                        });
                      }
                      commentController.clear();
                      setState(() {});
                    }
                  },
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: S.of(context).pictureDetailsAddComment,
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontFamily: "SPProtext",
                      letterSpacing: 1.2,
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[600], width: 0.2),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[600], width: 0.2),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[600], width: 0.2),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[600],
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    hintTextDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).pictureDetailsAddComment)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              InkWell(
                  child: HoverWidget(
                      child: commentButoonWidget(false),
                      hoverChild: commentButoonWidget(true),
                      onHover: (onHover) {}),
                  onTap: () async {
                    DocumentSnapshot user =
                        await users.doc(currentUser.uid).get();
                    DocumentSnapshot pub =
                        await users.doc(userId).collection("Pub").doc(id).get();
                    getTheCommentsCount(userId, id);
                    String postTime = "${DateTime.now()}".split('.').first;

                    if (commentController.text.isNotEmpty) {
                      await users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("Comments")
                          .doc("${currentUser.uid}==$postTime")
                          .set({
                        "timeAgo": DateTime.now(),
                        "comment": commentController.text.trim(),
                      });
                      if (userId != currentUser.uid) {
                        await users
                            .doc(userId)
                            .collection("Notifications")
                            .doc("$userId*comment*$id")
                            .set({
                          "seen": false,
                          "timeAgo": DateTime.now(),
                          "title": commentController.text.trim(),
                          "count": counter - 1,
                          "postKind": "comment",
                          "pubKind": pub.data()["postKind"],
                          "userName": user.data()["full_name"],
                          "userId": userId,
                          "id": id,
                          "uid": currentUser.uid
                        });
                      }
                      commentController.clear();
                      setState(() {});
                    }
                  }),
            ],
          ),
        ),
        CommentPageList()
      ],
    );
  }

  Widget commentButoonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[900] : Colors.grey[800]),
      height: h * .05,
      width: h * .05,
      child: Center(
        child: Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}

class CommentPageList extends StatefulWidget {
  const CommentPageList({Key key}) : super(key: key);

  @override
  _CommentPageListState createState() => _CommentPageListState();
}

class _CommentPageListState extends State<CommentPageList> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Time timeCal = new Time();
  ScrollController commentListController = ScrollController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ReadPostProvider>(context).userId;
    String id = Provider.of<ReadPostProvider>(context).doc;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: users
              .doc(userId)
              .collection("Pub")
              .doc(id)
              .collection("Comments")
              .orderBy("timeAgo", descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return loadingCommentPost(h, w);
                },
              );
            }
            if (snapshot.data.docs.isEmpty) {
              return Center(
                child: Container(
                  width: w * .25,
                  height: h * .4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "./assets/icons/chat_1.svg",
                        color: Colors.black,
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Text(
                        S.of(context).noCommentYetTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SPProtext"),
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Text(
                        S.of(context).noCommentsYetDes,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                            fontFamily: "SPProtext"),
                      ),
                    ],
                  ),
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: commentListController,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime dateTime =
                      snapshot.data.docs[index]["timeAgo"].toDate();
                  String commentUser =
                      snapshot.data.docs[index].id.toString().split("==").first;
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(seconds: 2),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: SlideAnimation(
                        child: PostCommentWidget(
                          commentContent: snapshot.data.docs[index]["comment"],
                          timeAgo: timeCal.timeAgo(dateTime),
                          userId: commentUser,
                          docId: id,
                          collection: "Pub",
                          commentId: snapshot.data.docs[index].id,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
