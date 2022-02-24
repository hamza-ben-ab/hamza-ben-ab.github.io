import 'package:flutter/material.dart';
import 'package:uy/generated/l10n.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/posts/post_widgets/invite_someOne.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/screens/posts/post_widgets/report_widget.dart';
import 'package:intl/intl.dart' as intl;

class TrueAndFalseButtonBar extends StatefulWidget {
  final String userId;
  final String id;

  const TrueAndFalseButtonBar({Key key, this.userId, this.id})
      : super(key: key);

  @override
  _TrueAndFalseButtonBarState createState() => _TrueAndFalseButtonBarState();
}

class _TrueAndFalseButtonBarState extends State<TrueAndFalseButtonBar> {
  PostFunctions postFunctions = PostFunctions();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');
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
    trueExist(userId, id);
  }

  Widget trueButtonWidget(bool hover) {
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
            "./assets/icons/036-check.svg",
            color: Colors.white,
            height: 22.0,
            width: 22.0,
            cacheColorFilter: true,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            S.of(context).trueKey,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
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

  Widget falseButtonWidget(bool hover) {
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
            "./assets/icons/068-cancel.svg",
            color: Colors.white,
            height: 22.0,
            width: 22.0,
          ),
          SizedBox(width: 10.0),
          Text(
            S.of(context).falseKey,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border.all(color: !isFalse ? Colors.transparent : Colors.red),
          borderRadius: BorderRadius.circular(15.0),
          color: hover
              ? Color(0xFF055895)
              : isFalse
                  ? Colors.red
                  : Color(0xFF055870)),
    );
  }

  Future<void> trueExist(String userId, String doc) async {
    DocumentSnapshot user = await users
        .doc(userId)
        .collection("Pub")
        .doc(doc)
        .collection("TrueOrFalse")
        .doc(currentUser.uid)
        .get();
    if (user.exists) {
      if (user["trueOrfalse"] == "true") {
        setState(() {
          isTrue = true;
        });
      } else if (user["trueOrfalse"] == "false") {
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
            height: 22.0,
            width: 22.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
                fontFamily: "SPProtext"),
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
            height: 22.0,
            width: 22.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
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
            child: ReportPostWidget(userd: userId, id: id),
          );
        });
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
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: h * .07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      width: w * .43,
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
                width: w * .43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //trueButton
                    InkWell(
                      child: HoverWidget(
                          child: trueButtonWidget(false),
                          hoverChild: trueButtonWidget(true),
                          onHover: (onHover) {}),
                      onTap: () async {
                        QuerySnapshot countLength = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .collection("TrueOrFalse")
                            .get();
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
                            .where("trueOrfalse", isEqualTo: "true")
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
                              .collection("TrueOrFalse")
                              .doc(currentUser.uid)
                              .set({
                            "trueOrfalse": "true",
                          }, SetOptions(merge: true));
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
                              "count": countLength.docs.length,
                              "pubKind": pub.data()["postKind"],
                              "userName": user.data()["full_name"],
                            }, SetOptions(merge: true));
                          }
                          users.doc(userId).collection("Pub").doc(id).set({
                            "count": count.docs.length,
                          }, SetOptions(merge: true));
                        } else {
                          users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("TrueOrFalse")
                              .doc(currentUser.uid)
                              .delete();
                          users
                              .doc(userId)
                              .collection("Notifications")
                              .doc("$userId*trueAndfalse*$id")
                              .delete();
                          users.doc(userId).collection("Pub").doc(id).set({
                            "true": count.docs.length,
                          }, SetOptions(merge: true));
                        }
                        print("  =========   $countLength");
                      },
                    ),
                    //falseButton
                    InkWell(
                      child: HoverWidget(
                          child: falseButtonWidget(false),
                          hoverChild: falseButtonWidget(true),
                          onHover: (onHover) {}),
                      onTap: () async {
                        QuerySnapshot countLength = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .collection("TrueOrFalse")
                            .get();
                        DocumentSnapshot user =
                            await users.doc(currentUser.uid).get();
                        DocumentSnapshot pub = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .get();
                        QuerySnapshot falseCount = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .collection("TrueOrFalse")
                            .where("trueOrfalse", isEqualTo: "false")
                            .get();
                        QuerySnapshot trueCount = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .collection("TrueOrFalse")
                            .where("trueOrfalse", isEqualTo: "true")
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
                              .collection("TrueOrFalse")
                              .doc(currentUser.uid)
                              .set({
                            "trueOrfalse": "false",
                          }, SetOptions(merge: true));
                          if (userId != currentUser.uid) {
                            await users
                                .doc(userId)
                                .collection("Notifications")
                                .doc("$userId*trueAndfalse*$id")
                                .set({
                              "seen": false,
                              "timeAgo": DateTime.now(),
                              "postKind": "trueAndfalse",
                              "count": countLength.docs.length,
                              "uid": currentUser.uid,
                              "pubKind": pub.data()["postKind"],
                              "userName": user.data()["full_name"],
                            }, SetOptions(merge: true));
                          }
                          users.doc(userId).collection("Pub").doc(id).set({
                            "false": falseCount.docs.length,
                          }, SetOptions(merge: true));
                          if (falseCount.docs.length >
                                  (trueCount.docs.length * 3) &&
                              (falseCount.docs.length + trueCount.docs.length) >
                                  100) {
                            users
                                .doc(widget.userId)
                                .collection("Pub")
                                .doc(widget.id)
                                .set({"close": true});
                            allPub
                                .doc("${widget.userId}==${widget.id}")
                                .delete();
                            await users
                                .doc(userId)
                                .collection("Notifications")
                                .doc("$userId*close*$id")
                                .set({
                              "seen": false,
                              "timeAgo": DateTime.now(),
                              "postKind": "close",
                              "uid": userId,
                              "pubKind": pub.data()["postKind"],
                            }, SetOptions(merge: true));
                          }
                        } else {
                          users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("TrueOrFalse")
                              .doc(currentUser.uid)
                              .delete();
                          users
                              .doc(userId)
                              .collection("Notifications")
                              .doc("$userId*trueAndfalse*$id")
                              .delete();
                          users.doc(userId).collection("Pub").doc(id).set({
                            "false": falseCount.docs.length,
                          }, SetOptions(merge: true));
                        }
                        print("  =========   $countLength");
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
                    inviteToRead(
                      h,
                      w,
                      S.of(context).inviteButton,
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
