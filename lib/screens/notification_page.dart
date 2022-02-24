import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/lo_notification.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:intl/intl.dart' as intl;

class NotificationPage extends StatefulWidget {
  final String userId;

  const NotificationPage({Key key, this.userId}) : super(key: key);
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Time timeCal = new Time();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  ScrollController notificationController = ScrollController();

  @override
  void initState() {
    seeAllNoti();
    super.initState();
  }

  Widget notificationItemAhead(String uid) {
    double h = MediaQuery.of(context).size.height;

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return Stack(
              children: [
                Container(
                  width: h * .08,
                  height: h * .08,
                  child: Center(
                    child: Container(
                      height: h * .06,
                      width: h * .06,
                      decoration: BoxDecoration(
                        borderRadius: intl.Bidi.detectRtlDirectionality(
                                S.of(context).notificationTitle)
                            ? BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              )
                            : BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(data["image"]).image),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Container(
            width: h * .08,
            height: h * .08,
          );
        });
  }

  Future<void> seeAllNoti() async {
    CollectionReference ref =
        users.doc(currentUser.uid).collection("Notifications");

    QuerySnapshot eventsQuery = await ref.where('seen', isEqualTo: false).get();

    eventsQuery.docs.forEach((msgDoc) {
      msgDoc.reference.update({'seen': true});
    });
  }

  Widget subscribeNoti(String userId, String userName, Timestamp timeAgo) {
    // double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<HideLeftBarProvider>(context, listen: false).closeleftBar();
        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeCurrentIndex(7);
        Provider.of<ProfileProvider>(context, listen: false)
            .changeProfileId(userId);
      },
      child: Row(
        children: [
          Container(
            width: w * .05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [notificationItemAhead(userId)],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$userName",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "SPProtext"),
                        ),
                        TextSpan(text: " "),
                        TextSpan(
                          text: S.of(context).notificationSubscribe,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontFamily: "SPProtext"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          timeCal.timeAgo(timeAgo.toDate()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[800],
                            fontFamily: "SPProtext",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget trueAndfalseNoti(String uid, String userId, String id, String userName,
      int count, Timestamp timeAgo, String postKind) {
    //double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<ReadPostProvider>(context, listen: false)
            .changePostId(userId, id);
        showDialog(
            context: context,
            builder: (context) {
              return ShowPostDetails(
                id: id,
                postKind: postKind,
              );
            });
      },
      child: Row(
        children: [
          Container(
            width: w * .05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [notificationItemAhead(uid)],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                      future: users.doc(userId).collection("Pub").doc(id).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data.data();
                          String postKind = data["postKind"];
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "$userName",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: count > 0
                                      ? "${S.of(context).and} $count ${S.of(context).other}"
                                      : userName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: "${S.of(context).likedYour}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: postKind == "lastest_news"
                                      ? "${S.of(context).createPostLastestNewsTitle} : "
                                      : postKind == "commentary"
                                          ? "${S.of(context).createPostCommentary} : "
                                          : postKind == "essay"
                                              ? "${S.of(context).createPostEssay} : "
                                              : postKind == "research article"
                                                  ? "${S.of(context).addPostArticle} : "
                                                  : postKind == "howTo"
                                                      ? "${S.of(context).createHowToTitle} : "
                                                      : postKind ==
                                                              "personality"
                                                          ? "${S.of(context).createProfiletitle} : "
                                                          : postKind ==
                                                                  "analysis"
                                                              ? "${S.of(context).createAnalysisTitle} : "
                                                              : postKind ==
                                                                      "investigation"
                                                                  ? "${S.of(context).createPostInvestigationTitle} : "
                                                                  : postKind ==
                                                                          "story"
                                                                      ? "${S.of(context).createStoryTitle} : "
                                                                      : postKind ==
                                                                              "broadcasting"
                                                                          ? "${S.of(context).createPostBroadcastTitle} : "
                                                                          : postKind == "inPic"
                                                                              ? "${S.of(context).createPostInpicTitle} : "
                                                                              : postKind == "breaking_news"
                                                                                  ? "${S.of(context).addPostBreakingNews} : "
                                                                                  : "",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                                TextSpan(
                                  text: postKind == "breaking_news" ||
                                          postKind == "lastest_news" ||
                                          postKind == "research article" ||
                                          postKind == "howTo" ||
                                          postKind == "analysis" ||
                                          postKind == "investigation" ||
                                          postKind == "story"
                                      ? data["title"]
                                      : postKind == "personality"
                                          ? data["full_name"]
                                          : data["description"]
                                                      .toString()
                                                      .length >
                                                  200
                                              ? data["description"]
                                                  .toString()
                                                  .substring(0, 200)
                                              : data["description"].toString(),
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          timeCal.timeAgo(timeAgo.toDate()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[800],
                            fontFamily: "SPProtext",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget reportNoti(String uid, String userId, String id, String userName,
      int count, Timestamp timeAgo, String postKind) {
    // double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<ReadPostProvider>(context, listen: false)
            .changePostId(userId, id);
        showDialog(
            context: context,
            builder: (context) {
              return ShowPostDetails(
                id: id,
                postKind: postKind,
              );
            });
      },
      child: Row(
        children: [
          Container(
            width: w * .05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [notificationItemAhead(uid)],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                      future: users.doc(userId).collection("Pub").doc(id).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data.data();
                          String postKind = data["postKind"];
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "$userName",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: count > 0
                                      ? "${S.of(context).and} $count ${S.of(context).other}"
                                      : userName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: "${S.of(context).reportYour}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: postKind == "lastest_news"
                                      ? "${S.of(context).createPostLastestNewsTitle} : "
                                      : postKind == "commentary"
                                          ? "${S.of(context).createPostCommentary} : "
                                          : postKind == "essay"
                                              ? "${S.of(context).createPostEssay} : "
                                              : postKind == "research article"
                                                  ? "${S.of(context).addPostArticle} : "
                                                  : postKind == "howTo"
                                                      ? "${S.of(context).createHowToTitle} : "
                                                      : postKind ==
                                                              "personality"
                                                          ? "${S.of(context).createProfiletitle} : "
                                                          : postKind ==
                                                                  "analysis"
                                                              ? "${S.of(context).createAnalysisTitle} : "
                                                              : postKind ==
                                                                      "investigation"
                                                                  ? "${S.of(context).createPostInvestigationTitle} : "
                                                                  : postKind ==
                                                                          "story"
                                                                      ? "${S.of(context).createStoryTitle} : "
                                                                      : postKind ==
                                                                              "broadcasting"
                                                                          ? "${S.of(context).createPostBroadcastTitle} : "
                                                                          : postKind == "inPic"
                                                                              ? "${S.of(context).createPostInpicTitle} : "
                                                                              : postKind == "breaking_news"
                                                                                  ? "${S.of(context).addPostBreakingNews} : "
                                                                                  : "",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                                TextSpan(
                                  text: postKind == "breaking_news" ||
                                          postKind == "lastest_news" ||
                                          postKind == "research article" ||
                                          postKind == "howTo" ||
                                          postKind == "analysis" ||
                                          postKind == "investigation" ||
                                          postKind == "story"
                                      ? data["title"]
                                      : postKind == "personality"
                                          ? data["full_name"]
                                          : data["description"]
                                                      .toString()
                                                      .length >
                                                  200
                                              ? data["description"]
                                                  .toString()
                                                  .substring(0, 200)
                                              : data["description"].toString(),
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          timeCal.timeAgo(timeAgo.toDate()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[800],
                            fontFamily: "SPProtext",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inviteToReadNoti(String uid, String userId, String id, String userName,
      Timestamp timeAgo, String postKind) {
    //double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<ReadPostProvider>(context, listen: false)
            .changePostId(userId, id);
        showDialog(
            context: context,
            builder: (context) {
              return ShowPostDetails(
                id: id,
                postKind: postKind,
              );
            });
      },
      child: Row(
        children: [
          Container(
            width: w * .05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [notificationItemAhead(uid)],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                      future: users.doc(userId).collection("Pub").doc(id).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data.data();
                          String postKind = data["postKind"];
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "$userName",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: postKind == "broadcasting"
                                      ? S.of(context).inviteYouToWatch
                                      : postKind == "inPic"
                                          ? " ${S.of(context).inviteYouToSee}"
                                          : " ${S.of(context).inviteYouToReadAn}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: postKind == "breaking_news"
                                      ? "${S.of(context).addPostBreakingNews} : "
                                      : postKind == "lastest_news"
                                          ? "${S.of(context).createPostLastestNewsTitle} : "
                                          : postKind == "commentary"
                                              ? "${S.of(context).createPostCommentary}."
                                              : postKind == "essay"
                                                  ? "${S.of(context).createPostEssay}."
                                                  : postKind ==
                                                          "research article"
                                                      ? "${S.of(context).addPostArticle} : "
                                                      : postKind == "howTo"
                                                          ? "${S.of(context).createHowToTitle} : "
                                                          : postKind ==
                                                                  "personality"
                                                              ? "${S.of(context).createProfiletitle} : "
                                                              : postKind ==
                                                                      "analysis"
                                                                  ? "${S.of(context).createAnalysisTitle} : "
                                                                  : postKind ==
                                                                          "investigation"
                                                                      ? "${S.of(context).createPostInvestigationTitle} : "
                                                                      : postKind ==
                                                                              "story"
                                                                          ? "${S.of(context).createStoryTitle} : "
                                                                          : postKind == "broadcasting"
                                                                              ? "${S.of(context).createPostBroadcastTitle}."
                                                                              : postKind == "inPic"
                                                                                  ? "${S.of(context).picture}."
                                                                                  : "",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                                TextSpan(
                                  text: postKind == "breaking_news" ||
                                          postKind == "lastest_news" ||
                                          postKind == "research article" ||
                                          postKind == "howTo" ||
                                          postKind == "analysis" ||
                                          postKind == "investigation" ||
                                          postKind == "story"
                                      ? data["title"]
                                      : postKind == "personality"
                                          ? data["full_name"]
                                          : data["description"]
                                                      .toString()
                                                      .length >
                                                  200
                                              ? data["description"]
                                                  .toString()
                                                  .substring(0, 200)
                                              : data["description"].toString(),
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          timeCal.timeAgo(timeAgo.toDate()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[800],
                            fontFamily: "SPProtext",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget answertNoti(String uid, String userId, String id, String userName,
      int count, Timestamp timeAgo) {
    // double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<ReadPostProvider>(context, listen: false)
            .changePostId(userId, id);
        showDialog(
            context: context,
            builder: (context) {
              return ShowPostDetails(
                id: id,
                postKind: "poll",
              );
            });
      },
      child: Row(
        children: [
          Container(
            width: w * .05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [notificationItemAhead(uid)],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                      future: users.doc(userId).collection("Pub").doc(id).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data.data();

                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "$userName",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: count > 0
                                      ? "${S.of(context).and} $count ${S.of(context).other}"
                                      : userName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: "${S.of(context).answerYour}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: data["title"],
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          timeCal.timeAgo(timeAgo.toDate()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[800],
                            fontFamily: "SPProtext",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget closePubNoti(
      String uid, String id, Timestamp timeAgo, String postKind) {
    // double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          width: w * .05,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [notificationItemAhead(uid)],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                    future: users
                        .doc(currentUser.uid)
                        .collection("Pub")
                        .doc(id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data.data();
                        String postKind = data["postKind"];
                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Unfortunately, we will delete your ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "SPProtext"),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: postKind == "lastest_news"
                                    ? "${S.of(context).createPostLastestNewsTitle} : "
                                    : postKind == "commentary"
                                        ? "${S.of(context).createPostCommentary} : "
                                        : postKind == "essay"
                                            ? "${S.of(context).createPostEssay} : "
                                            : postKind == "research article"
                                                ? "${S.of(context).addPostArticle} : "
                                                : postKind == "howTo"
                                                    ? "${S.of(context).createHowToTitle} : "
                                                    : postKind == "personality"
                                                        ? "${S.of(context).createProfiletitle} : "
                                                        : postKind == "analysis"
                                                            ? "${S.of(context).createAnalysisTitle} : "
                                                            : postKind ==
                                                                    "investigation"
                                                                ? "${S.of(context).createPostInvestigationTitle} : "
                                                                : postKind ==
                                                                        "story"
                                                                    ? "${S.of(context).createStoryTitle} : "
                                                                    : postKind ==
                                                                            "broadcasting"
                                                                        ? "${S.of(context).createPostBroadcastTitle} : "
                                                                        : postKind ==
                                                                                "inPic"
                                                                            ? "${S.of(context).createPostInpicTitle} : "
                                                                            : postKind == "breaking_news"
                                                                                ? "${S.of(context).addPostBreakingNews} : "
                                                                                : "",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  fontFamily: "SPProtext",
                                ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: postKind == "breaking_news" ||
                                        postKind == "lastest_news" ||
                                        postKind == "research article" ||
                                        postKind == "howTo" ||
                                        postKind == "analysis" ||
                                        postKind == "investigation" ||
                                        postKind == "story"
                                    ? data["title"]
                                    : postKind == "personality"
                                        ? data["full_name"]
                                        : data["description"]
                                                    .toString()
                                                    .length >
                                                200
                                            ? data["description"]
                                                .toString()
                                                .substring(0, 200)
                                            : data["description"].toString(),
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 13.0,
                                  fontFamily: "SPProtext",
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        height: 0.0,
                        width: 0.0,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        timeCal.timeAgo(timeAgo.toDate()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey[800],
                          fontFamily: "SPProtext",
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget commentNoti(
    String title,
    String postKind,
    String uid,
    String userName,
    int count,
    Timestamp timeAgo,
    String userId,
    String id,
  ) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Provider.of<ReadPostProvider>(context, listen: false)
            .changePostId(userId, id);
        showDialog(
            context: context,
            builder: (context) {
              return ShowPostDetails(
                id: id,
                postKind: postKind,
              );
            });
      },
      child: Row(
        children: [
          Container(
            width: w * .05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [notificationItemAhead(uid)],
            ),
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(userId).collection("Pub").doc(id).get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return Container(
                    padding:
                        EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "$userName",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "SPProtext"),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: count > 0
                                    ? "${S.of(context).and} $count ${S.of(context).other}"
                                    : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext"),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: "${S.of(context).commentedYour}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext"),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: postKind == "breaking_news"
                                    ? "${S.of(context).addPostBreakingNews} : "
                                    : postKind == "lastest_news"
                                        ? "${S.of(context).createPostLastestNewsTitle} : "
                                        : postKind == "commentary"
                                            ? "${S.of(context).createPostCommentary}."
                                            : postKind == "essay"
                                                ? "${S.of(context).createPostEssay}."
                                                : postKind == "research article"
                                                    ? "${S.of(context).addPostArticle} : "
                                                    : postKind == "howTo"
                                                        ? "${S.of(context).createHowToTitle} : "
                                                        : postKind ==
                                                                "personality"
                                                            ? "${S.of(context).createProfiletitle} : "
                                                            : postKind ==
                                                                    "analysis"
                                                                ? "${S.of(context).createAnalysisTitle} : "
                                                                : postKind ==
                                                                        "investigation"
                                                                    ? "${S.of(context).createPostInvestigationTitle} : "
                                                                    : postKind ==
                                                                            "story"
                                                                        ? "${S.of(context).createStoryTitle} : "
                                                                        : postKind ==
                                                                                "broadcasting"
                                                                            ? "${S.of(context).createPostBroadcastTitle} : "
                                                                            : postKind == "inPic"
                                                                                ? "${S.of(context).picture} : "
                                                                                : "",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  fontFamily: "SPProtext",
                                ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: postKind == "breaking_news" ||
                                        postKind == "lastest_news" ||
                                        postKind == "research article" ||
                                        postKind == "howTo" ||
                                        postKind == "analysis" ||
                                        postKind == "investigation" ||
                                        postKind == "story"
                                    ? data["title"]
                                    : postKind == "personality"
                                        ? data["full_name"]
                                        : data["description"]
                                                    .toString()
                                                    .length >
                                                200
                                            ? "${data["description"].toString().substring(0, 200)}..."
                                            : data["description"].toString(),
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 13.0,
                                  fontFamily: "SPProtext",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                timeCal.timeAgo(timeAgo.toDate()),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.grey[800],
                                  fontFamily: "SPProtext",
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return notificationLoading(h, w);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationItem(bool hover, QueryDocumentSnapshot doc) {
    String actionKind = doc.data()["postKind"];
    String userId = doc.id.split("*$actionKind*").first;
    String id = doc.id.split("*$actionKind*").last;
    String title = doc.data()["title"];
    String postKind = doc.data()["pubKind"];
    String userName = doc.data()["userName"];
    Timestamp timeAgo = doc.data()["timeAgo"];
    int count = doc.data()["count"];
    String uid = doc.data()["uid"];

    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).notificationTitle)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        width: w * .22,
        margin: EdgeInsets.only(
          top: 5.0,
          left: 5.0,
          right: 17.0,
          bottom: 5.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: actionKind == "subscribe"
            ? subscribeNoti(userId, userName, timeAgo)
            : actionKind == "trueAndfalse"
                ? trueAndfalseNoti(
                    uid,
                    userId,
                    id,
                    userName,
                    count,
                    timeAgo,
                    actionKind,
                  )
                : actionKind == "report"
                    ? reportNoti(
                        uid, userId, id, userName, count, timeAgo, postKind)
                    : actionKind == "inviteToRead"
                        ? inviteToReadNoti(
                            uid, userId, id, userName, timeAgo, actionKind)
                        : actionKind == "comment"
                            ? commentNoti(
                                title,
                                postKind,
                                uid,
                                userName,
                                count,
                                timeAgo,
                                userId,
                                id,
                              )
                            : actionKind == "answer"
                                ? answertNoti(
                                    uid, userId, id, userName, count, timeAgo)
                                : Container(),
      ).xShowPointerOnHover,
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w * .24,
      child: Column(
        children: [
          Directionality(
            textDirection: intl.Bidi.detectRtlDirectionality(
                    S.of(context).notificationTitle)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Container(
              height: h * .07,
              padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Text(
                    S.of(context).notificationTitle,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        fontFamily: "SPProtext"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 5.0),
              width: w * .24,
              child: StreamBuilder<QuerySnapshot>(
                  stream: users
                      .doc(currentUser.uid)
                      .collection("Notifications")
                      .orderBy("timeAgo", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: w * .24,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (_, context) {
                            return notificationLoading(h, w);
                          },
                        ),
                      );
                    }
                    if (snapshot.data.docs.isEmpty) {
                      return Center(
                        child: Container(
                          width: w * .24,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).notificationNoYetTitle,
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
                                S.of(context).notificationNoYetDes,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Scrollbar(
                      controller: notificationController,
                      isAlwaysShown: true,
                      radius: Radius.circular(20.0),
                      child: AnimationLimiter(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          controller: notificationController,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(seconds: 2),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: SlideAnimation(
                                  child: HoverWidget(
                                          child: notificationItem(
                                              false, snapshot.data.docs[index]),
                                          hoverChild: notificationItem(
                                              true, snapshot.data.docs[index]),
                                          onHover: (onHover) {})
                                      .xShowPointerOnHover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
