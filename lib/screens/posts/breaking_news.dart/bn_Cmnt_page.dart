import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/posts/breaking_news.dart/bn_Cmnt_widget.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:intl/intl.dart' as intl;

class BreakingNewsCommentPage extends StatefulWidget {
  const BreakingNewsCommentPage({
    Key key,
  }) : super(key: key);
  @override
  _BreakingNewsCommentPageState createState() =>
      _BreakingNewsCommentPageState();
}

class _BreakingNewsCommentPageState extends State<BreakingNewsCommentPage> {
  TextEditingController commentController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  ScrollController scrollController = ScrollController();

  bool showComment = false;
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
      counter = list.toSet().length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId =
        Provider.of<CenterBoxProvider>(context).docId.split("==").first;
    String id = Provider.of<CenterBoxProvider>(context).docId.split("==").last;
    return Directionality(
      textDirection: intl.Bidi.detectRtlDirectionality(
        S.of(context).pictureDetailsAddComment,
      )
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.circular(15.0),
        ),
        width: w * .22,
        height: h * .91,
        child: Column(
          children: [
            Container(
              height: h * .08,
              width: w * .22,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  Container(
                    height: h * .06,
                    width: w * .175,
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
                        DocumentSnapshot pub = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .get();
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
                        DocumentSnapshot pub = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .get();
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
            CommentPageList(
              userId: userId,
              id: id,
            )
          ],
        ),
      ),
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
  final String userId;
  final String id;
  const CommentPageList({Key key, this.userId, this.id}) : super(key: key);

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
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: users
            .doc(widget.userId)
            .collection("Pub")
            .doc(widget.id)
            .collection("Comments")
            .orderBy("timeAgo", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(width: 0.0, height: 0.0);
          }
          if (snapshot.data.docs.isEmpty) {
            return Center(
              child: Container(
                width: w * .24,
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
                //cmnt = snapshot.data.docs.length;
                // i = index;
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
                      child: BreakingNewsCommentWidget(
                        commentContent: snapshot.data.docs[index]["comment"],
                        timeAgo: timeCal.timeAgo(dateTime),
                        userId: commentUser,
                        docId: widget.id,
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
    );
  }
}
