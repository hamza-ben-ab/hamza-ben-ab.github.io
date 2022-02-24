import 'package:flutter/material.dart';
import 'package:uy/generated/l10n.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/posts/post_widgets/invite_someOne.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/screens/posts/post_widgets/report_widget.dart';
import 'package:intl/intl.dart' as intl;

class LikeAndDislikeButtonBar extends StatefulWidget {
  final String userId;
  final String id;

  const LikeAndDislikeButtonBar({Key key, this.userId, this.id})
      : super(key: key);

  @override
  _LikeAndDislikeButtonBarState createState() =>
      _LikeAndDislikeButtonBarState();
}

class _LikeAndDislikeButtonBarState extends State<LikeAndDislikeButtonBar> {
  PostFunctions postFunctions = PostFunctions();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  bool isFalse = false;

  bool isTrue = false;
  int trueCount = 0;
  int falseCount = 0;
  int totalCount = 0;

  String userId;
  String id;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    id = widget.id;
    likeExist(userId, id);
  }

  Widget likeButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .055,
      width: w * .08,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "./assets/icons/195-like.svg",
            color: Colors.white,
            height: 20.0,
            width: 20.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            S.of(context).iLikeButton,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext",
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border:
              Border.all(color: !isTrue ? Colors.transparent : Colors.green),
          borderRadius: BorderRadius.circular(15.0),
          color: hover
              ? Color(0xFF055895)
              : isTrue
                  ? Colors.green
                  : Color(0xFF055870)),
    );
  }

  Widget dislikeButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .055,
      width: w * .08,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "./assets/icons/194-dislike.svg",
            color: Colors.white,
            height: 20.0,
            width: 20.0,
          ),
          SizedBox(width: 8.0),
          Text(
            S.of(context).dislike,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext",
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: !isFalse ? Colors.transparent : Colors.red),
          color: hover
              ? Color(0xFF055895)
              : isFalse
                  ? Colors.red
                  : Color(0xFF055870)),
    );
  }

  Future<void> likeExist(String userId, String doc) async {
    DocumentSnapshot user = await users
        .doc(userId)
        .collection("Pub")
        .doc(doc)
        .collection("LikeOrDislike")
        .doc(currentUser.uid)
        .get();
    if (user.exists) {
      if (user["LikeOrDislike"] == "like") {
        setState(() {
          isTrue = true;
        });
      } else if (user["LikeOrDislike"] == "dislike") {
        setState(() {
          isFalse = true;
        });
      } else {
        setState(() {
          isTrue = false;
          isFalse = false;
        });
      }
    }
  }

  Widget inviteToRead(double h, double w, String title) {
    return InkWell(
      onTap: () {
        inviteToReadFunction(context, userId, id);
      },
      child: HoverWidget(
        child: inviteToReadWidget(false, h, w, title),
        hoverChild: inviteToReadWidget(true, h, w, title),
        onHover: (onHover) {},
      ),
    );
  }

  Widget inviteToReadWidget(bool hover, double h, double w, String title) {
    return Container(
      height: h * .055,
      width: w * .08,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "./assets/icons/175-share.svg",
            color: Colors.white,
            height: 20.0,
            width: 20.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 10.0,
              fontFamily: "SPProtext",
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Color(0xFF055895) : Color(0xFF055870)),
    );
  }

  Widget reportButton(
      double h, double w, String title, String userId, String doc) {
    return InkWell(
        child: HoverWidget(
            child: reportButtonWidget(h, w, title, false),
            hoverChild: reportButtonWidget(h, w, title, true),
            onHover: (onHover) {}),
        onTap: () async {
          reportNews(context, userId, doc);
        });
  }

  Widget reportButtonWidget(double h, double w, String title, bool hover) {
    return Container(
      width: w * .08,
      height: h * .055,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "./assets/icons/alert.svg",
            color: Colors.white,
            height: 20.0,
            width: 20.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext",
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Color(0xFF055895) : Color(0xFF055870)),
    );
  }

  inviteToReadFunction(BuildContext context, String userId, String doc) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: h * .7,
              width: w * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: InviteSomeOne(
                userId: userId,
                id: doc,
              ),
            ),
          );
        });
  }

  reportNews(BuildContext context, String userId, String doc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: ReportPostWidget(
              userd: userId,
              id: id,
            ),
          );
        });
  }

  Widget sendButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .05,
      width: w * .1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: hover ? button2ColorHover : button2Color),
      child: Center(
        child: Text(
          S.of(context).profileSuggestionSendButton,
          style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontFamily: "SPProtext",
              fontWeight: FontWeight.w500),
        ),
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: h * .07,
      width: w * .45,
      child: Column(
        children: [
          Divider(
            color: Colors.grey[600],
            height: 0.05,
            endIndent: 10.0,
            indent: 10.0,
          ),
          Expanded(
            child: Directionality(
              textDirection:
                  intl.Bidi.detectRtlDirectionality(S.of(context).trueKey)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: Container(
                color: Colors.white,
                width: w * .45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //trueButton
                    InkWell(
                      child: HoverWidget(
                          child: likeButtonWidget(false),
                          hoverChild: likeButtonWidget(true),
                          onHover: (onHover) {}),
                      onTap: () async {
                        DocumentSnapshot user =
                            await users.doc(currentUser.uid).get();
                        DocumentSnapshot pub = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .get();
                        QuerySnapshot count = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .collection("TrueOrFalse")
                            .get();
                        setState(() {
                          isTrue = !isTrue;
                          isFalse = false;
                        });

                        if (isTrue) {
                          users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("LikeOrDislike")
                              .doc(currentUser.uid)
                              .set({
                            "LikeOrDislike": "like",
                          });
                          if (userId != currentUser.uid) {
                            await users
                                .doc(userId)
                                .collection("Notifications")
                                .doc("$userId*trueAndfalse*$id")
                                .set({
                              "seen": false,
                              "timeAgo": DateTime.now(),
                              "postKind": "trueAndfalse",
                              "uid": currentUser.uid,
                              "count": count.docs.length - 1,
                              "pubKind": pub.data()["postKind"],
                              "userName": user.data()["full_name"],
                            });
                          }
                        } else {
                          users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("LikeOrDislike")
                              .doc(currentUser.uid)
                              .delete();
                          users
                              .doc(userId)
                              .collection("Notifications")
                              .doc("$userId*trueAndfalse*$id")
                              .delete();
                        }
                      },
                    ),
                    //falseButton
                    InkWell(
                      child: HoverWidget(
                          child: dislikeButtonWidget(false),
                          hoverChild: dislikeButtonWidget(true),
                          onHover: (onHover) {}),
                      onTap: () async {
                        DocumentSnapshot user =
                            await users.doc(currentUser.uid).get();
                        DocumentSnapshot pub = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .get();
                        QuerySnapshot count = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .collection("TrueOrFalse")
                            .get();
                        setState(() {
                          isFalse = !isFalse;
                          isTrue = false;
                        });

                        if (isFalse) {
                          users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("LikeOrDislike")
                              .doc(currentUser.uid)
                              .set({
                            "LikeOrDislike": "dislike",
                          });
                          if (userId != currentUser.uid) {
                            await users
                                .doc(userId)
                                .collection("Notifications")
                                .doc("$userId*trueAndfalse*$id")
                                .set({
                              "seen": false,
                              "timeAgo": DateTime.now(),
                              "postKind": "trueAndfalse",
                              "uid": currentUser.uid,
                              "count": count.docs.length - 1,
                              "pubKind": pub.data()["postKind"],
                              "userName": user.data()["full_name"],
                            });
                          }
                        } else {
                          users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("LikeOrDislike")
                              .doc(currentUser.uid)
                              .delete();
                          users
                              .doc(userId)
                              .collection("Notifications")
                              .doc("$userId*trueAndfalse*$id")
                              .delete();
                        }
                      },
                    ),
                    //reportButton
                    reportButton(
                      h,
                      w,
                      S.of(context).report,
                      userId,
                      id,
                    ),
                    //inviteToReadButton
                    Align(
                      alignment: Alignment.centerRight,
                      child: inviteToRead(
                        h,
                        w,
                        S.of(context).inviteButton,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
