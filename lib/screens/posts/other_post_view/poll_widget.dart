import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/bookmark/bookMark_button.dart';
import 'package:uy/screens/constant.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/loading_widget/postHome_loading.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_home.dart';
import 'package:uy/screens/posts/post_widgets/invite_someOne.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/screens/search/hover.dart';

class PollWidget extends StatefulWidget {
  final String userId;
  final String id;
  const PollWidget({Key key, this.userId, this.id}) : super(key: key);

  @override
  _PollWidgetState createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String userId;
  String id;
  bool isBookmark = false;
  int firstChoiceCount = 0;
  int secondChoiceCount = 0;
  int thirdChoiceCount = 0;
  int totalCount = 0;
  int firstValue = 0;
  int secondValue = 0;
  PostFunctions postFunctions = PostFunctions();
  bool closePoll = false;

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
      margin: EdgeInsets.only(bottom: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "./assets/icons/175-share.svg",
            color: Colors.black,
            height: 20.0,
            width: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black, fontSize: 12.0, fontFamily: "SPProtext"),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[300] : Colors.grey[50]),
    );
  }

  @override
  void initState() {
    userId = widget.userId;
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userId).collection("Pub").doc(id).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data.data();

          return Container(
            decoration: BoxDecoration(color: Colors.white),
            //padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                AheadPostHome(
                  data: data,
                  userId: userId,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          left: 10.0,
                          right: 12.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: h * .035,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      height: h * .06,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Center(
                                        child: Text(
                                          "#${data["topic"]}",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 11.0,
                                              fontFamily: "SPProtext"),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            BookMarkButton(
                              read: true,
                              postKind: data["postKind"],
                              id: id,
                              userId: userId,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Container(
                        child: Column(
                          children: [
                            data["person"] != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          LineAwesomeIcons.user_tag,
                                          color: Colors.grey[700],
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          width: w * .25,
                                          child: Text(
                                            data["person"],
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 12.0,
                                                fontFamily: "SPProtext"),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                            data["event"] != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          LineAwesomeIcons.calendar_check,
                                          color: Colors.grey[700],
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          width: w * .25,
                                          child: Text(
                                            data["event"],
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 12.0,
                                                fontFamily: "SPProtext"),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                            data["place"] != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.grey[700],
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          width: w * .25,
                                          child: Text(
                                            data["place"],
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 12.0,
                                                fontFamily: "SPProtext"),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: w * .4,
                        child: ReadMoreText(
                          data["description"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontFamily: "SPProtext",
                          ),
                          textDirection: intl.Bidi.detectRtlDirectionality(
                                  data["description"])
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          trimLines: 4,
                          trimExpandedText: S.of(context).readLess,
                          lessStyle: TextStyle(
                            fontFamily: "SPProtext",
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: S.of(context).readMore,
                          moreStyle: TextStyle(
                            fontFamily: "SPProtext",
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        width: w * .35,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Directionality(
                          textDirection:
                              intl.Bidi.detectRtlDirectionality(data["title"])
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                          child: Row(
                            children: [
                              Container(
                                height: h * .07,
                                width: w * .06,
                                child: Center(
                                  child: Image.asset(
                                      "./assets/images/question1.png"),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  data["title"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontFamily: "Lora",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[400],
                        endIndent: w * .05,
                        indent: w * .05,
                      ),
                      PollCenterWidget(
                        date: data["timeAgo"],
                        userId: userId,
                        id: id,
                        choice1: data["choice1"],
                        choice2: data["choice2"],
                        choice3: data["choice3"],
                      ),
                      Divider(
                        color: Colors.grey[400],
                        endIndent: w * .05,
                        indent: w * .05,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  height: h * .06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [inviteToRead(h, w, S.of(context).inviteButton)],
                  ),
                ),
              ],
            ),
          );
        }

        return loadingHomePost(h, w);
      },
    );
  }
}

class PollCenterWidget extends StatefulWidget {
  final String userId;
  final String id;
  final String choice1;
  final String choice2;
  final String choice3;
  final Timestamp date;
  const PollCenterWidget(
      {Key key,
      this.userId,
      this.id,
      this.choice1,
      this.choice2,
      this.choice3,
      this.date})
      : super(key: key);

  @override
  _PollCenterWidgetState createState() => _PollCenterWidgetState();
}

class _PollCenterWidgetState extends State<PollCenterWidget> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String userId;
  String id;
  bool show = false;
  int currentIndex = 0;
  int totalCount = 0;
  int firstCount = 0;
  int secondCount = 0;
  int thirdCount = 0;
  PostFunctions postFunctions = PostFunctions();

  @override
  void initState() {
    userId = widget.userId;
    id = widget.id;
    getChoiceCount();
    super.initState();
  }

  Future<void> getChoiceCount() async {
    CollectionReference _collectionRef1 =
        users.doc(userId).collection("Pub").doc(id).collection("FirstAnswer");

    CollectionReference _collectionRef2 =
        users.doc(userId).collection("Pub").doc(id).collection("SecondAnswer");

    CollectionReference _collectionRef3 =
        users.doc(userId).collection("Pub").doc(id).collection("ThirdAnswer");

    QuerySnapshot querySnapshot1 = await _collectionRef1.get();
    QuerySnapshot querySnapshot2 = await _collectionRef2.get();
    QuerySnapshot querySnapshot3 = await _collectionRef3.get();

    setState(() {
      firstCount = querySnapshot1.docs.length;
      secondCount = querySnapshot2.docs.length;
      thirdCount = querySnapshot3.docs.length;
      totalCount = firstCount + secondCount + thirdCount;
    });
  }

  String getTheDifferenceBetweenDate(Timestamp postDate) {
    String result;

    if (DateTime.now().difference(postDate.toDate()).inMinutes < 60) {
      result =
          "${DateTime.now().difference(postDate.toDate()).inMinutes.toString()} ${S.of(context).Minutes}";
    } else if (DateTime.now().difference(postDate.toDate()).inMinutes > 60 &&
        DateTime.now().difference(postDate.toDate()).inHours < 24) {
      if (int.parse(DateTime.now()
                  .difference(postDate.toDate())
                  .inMinutes
                  .toString()) %
              60 !=
          0) {
        result =
            "${(int.parse(DateTime.now().difference(postDate.toDate()).inMinutes.toString()) / 60).toString().split(".").first} ${S.of(context).hours}, ${int.parse(DateTime.now().difference(postDate.toDate()).inMinutes.toString()) - (int.parse(DateTime.now().difference(postDate.toDate()).inHours.toString())) * 60} ${S.of(context).Minutes}";
      } else {
        result =
            "${DateTime.now().difference(postDate.toDate()).inHours.toString()}";
      }
    } else if (DateTime.now().difference(postDate.toDate()).inHours > 23) {
      if (int.parse(DateTime.now()
                  .difference(postDate.toDate())
                  .inHours
                  .toString()) %
              24 !=
          0) {
        result =
            "${(int.parse(DateTime.now().difference(postDate.toDate()).inHours.toString()) / 24).toString().split(".").first} ${S.of(context).days}, ${int.parse(DateTime.now().difference(postDate.toDate()).inHours.toString()) - (int.parse(DateTime.now().difference(postDate.toDate()).inDays.toString())) * 24} ${S.of(context).hours}";
      } else if (DateTime.now().difference(postDate.toDate()).inDays > 0) {
        result =
            "${DateTime.now().difference(postDate.toDate()).inDays.toString()} ${S.of(context).days}";
      } else {
        result = "Just now";
      }
    }

    return result;
  }

  Widget firstPercentProgressWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .04,
      width: w * .3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[200],
          border: Border.all(color: hover ? accentColor : Colors.transparent)),
      child: Center(
        child: Text(
          widget.choice1,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            fontFamily: "SPProtext",
          ),
        ),
      ),
    ).xShowPointerOnHover;
  }

  Widget secondPercentProgressWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .04,
      width: w * .3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[200],
          border: Border.all(color: hover ? accentColor : Colors.transparent)),
      child: Center(
        child: Text(
          widget.choice2,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            fontFamily: "SPProtext",
          ),
        ),
      ),
    ).xShowPointerOnHover;
  }

  Widget thirdPercentProgressWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .04,
      width: w * .3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[200],
          border: Border.all(color: hover ? accentColor : Colors.transparent)),
      child: Center(
        child: Text(
          widget.choice3,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            fontFamily: "SPProtext",
          ),
        ),
      ),
    ).xShowPointerOnHover;
  }

  Widget firstPercentProgress() {
    return InkWell(
      onTap: () async {
        DocumentSnapshot user = await users.doc(currentUser.uid).get();
        DocumentSnapshot pub =
            await users.doc(userId).collection("Pub").doc(id).get();

        setState(() {
          show = true;
          currentIndex = 0;
        });

        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("FirstAnswer")
            .doc(currentUser.uid)
            .set({"uid": currentUser.uid});

        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("SecondAnswer")
            .doc(currentUser.uid)
            .delete();
        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("ThirdAnswer")
            .doc(currentUser.uid)
            .delete();

        getChoiceCount();
        if (userId != currentUser.uid) {
          await users
              .doc(userId)
              .collection("Notifications")
              .doc("$userId*answer*$id")
              .set({
            "seen": false,
            "timeAgo": DateTime.now(),
            "postKind": "answer",
            "uid": currentUser.uid,
            "count": totalCount - 1,
            "pubKind": pub.data()["postKind"],
            "userName": user.data()["full_name"],
          }, SetOptions(merge: true));
        }
      },
      child: HoverWidget(
        child: firstPercentProgressWidget(false),
        hoverChild: firstPercentProgressWidget(true),
        onHover: (onHover) {},
      ),
    );
  }

  Widget secondPercentProgress() {
    return InkWell(
      onTap: () async {
        DocumentSnapshot user = await users.doc(currentUser.uid).get();
        DocumentSnapshot pub =
            await users.doc(userId).collection("Pub").doc(id).get();
        setState(() {
          show = true;
          currentIndex = 1;
        });
        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("SecondAnswer")
            .doc(currentUser.uid)
            .set({"uid": currentUser.uid});
        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("FirstAnswer")
            .doc(currentUser.uid)
            .delete();
        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("ThirdAnswer")
            .doc(currentUser.uid)
            .delete();

        getChoiceCount();
        if (userId != currentUser.uid) {
          await users
              .doc(userId)
              .collection("Notifications")
              .doc("$userId*answer*$id")
              .set({
            "seen": false,
            "timeAgo": DateTime.now(),
            "postKind": "answer",
            "uid": currentUser.uid,
            "count": totalCount - 1,
            "pubKind": pub.data()["postKind"],
            "userName": user.data()["full_name"],
          }, SetOptions(merge: true));
        }
      },
      child: HoverWidget(
        child: secondPercentProgressWidget(false),
        hoverChild: secondPercentProgressWidget(true),
        onHover: (onHover) {},
      ),
    );
  }

  Widget thirdPercentProgress() {
    return InkWell(
      onTap: () async {
        DocumentSnapshot user = await users.doc(currentUser.uid).get();
        DocumentSnapshot pub =
            await users.doc(userId).collection("Pub").doc(id).get();
        setState(() {
          show = true;
          currentIndex = 2;
        });

        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("ThirdAnswer")
            .doc(currentUser.uid)
            .set({"uid": currentUser.uid});
        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("SecondAnswer")
            .doc(currentUser.uid)
            .delete();
        await users
            .doc(userId)
            .collection("Pub")
            .doc(id)
            .collection("FirstAnswer")
            .doc(currentUser.uid)
            .delete();

        getChoiceCount();
        if (userId != currentUser.uid) {
          await users
              .doc(userId)
              .collection("Notifications")
              .doc("$userId*answer*$id")
              .set({
            "seen": false,
            "timeAgo": DateTime.now(),
            "postKind": "answer",
            "uid": currentUser.uid,
            "count": totalCount - 1,
            "pubKind": pub.data()["postKind"],
            "userName": user.data()["full_name"],
          }, SetOptions(merge: true));
        }
      },
      child: HoverWidget(
        child: thirdPercentProgressWidget(false),
        hoverChild: thirdPercentProgressWidget(true),
        onHover: (onHover) {},
      ),
    );
  }

  Widget firstLinearPercentIndicator() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * .4,
      child: Row(children: [
        Container(
          width: w * .3,
          margin: EdgeInsets.symmetric(vertical: 3.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearPercentIndicator(
                  percent: firstCount > 0 ? (firstCount / totalCount) : 0.0,
                  backgroundColor: Colors.transparent,
                  progressColor: Colors.grey[200],
                  width: w * .3,
                  lineHeight: h * .045,
                  animation: true,
                  animationDuration: 500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          widget.choice1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SPProtext",
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        currentIndex == 0
                            ? Icon(
                                LineAwesomeIcons.check_circle_1,
                                color: Colors.grey[700],
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: w * 0.5,
            child: Text(
              (thirdCount / totalCount).isNaN
                  ? "0.0"
                  : "${((firstCount / totalCount) * 100).round()} %",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext",
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget secondLinearPercentIndicator() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Row(children: [
      Container(
        width: w * .3,
        margin: EdgeInsets.symmetric(vertical: 3.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: LinearPercentIndicator(
                percent: secondCount > 0 ? (secondCount / totalCount) : 0.0,
                backgroundColor: Colors.transparent,
                progressColor: Colors.grey[200],
                width: w * .3,
                lineHeight: h * .045,
                animation: true,
                animationDuration: 500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          widget.choice2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SPProtext",
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        currentIndex == 1
                            ? Icon(
                                LineAwesomeIcons.check_circle_1,
                                color: Colors.grey[700],
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: w * 0.5,
          child: Text(
            (thirdCount / totalCount).isNaN
                ? "0.0"
                : "${((secondCount / totalCount) * 100).round()} %",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext",
            ),
          ),
        ),
      )
    ]);
  }

  Widget thirdLinearPercentIndicator() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          width: w * .3,
          margin: EdgeInsets.symmetric(vertical: 3.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearPercentIndicator(
                  percent: thirdCount > 0 ? (thirdCount / totalCount) : 0.0,
                  backgroundColor: Colors.transparent,
                  progressColor: Colors.grey[200],
                  width: w * .3,
                  lineHeight: h * .045,
                  animation: true,
                  animationDuration: 500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            widget.choice3,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SPProtext",
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          currentIndex == 2
                              ? Icon(
                                  LineAwesomeIcons.check_circle_1,
                                  color: Colors.grey[700],
                                )
                              : Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: w * 0.5,
            child: Text(
              (thirdCount / totalCount).isNaN
                  ? "0.0"
                  : "${((thirdCount / totalCount) * 100).round()} %",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext",
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * .35,
      child: !show
          ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  firstPercentProgress(),
                  SizedBox(
                    height: 5.0,
                  ),
                  secondPercentProgress(),
                  SizedBox(
                    height: 5.0,
                  ),
                  widget.choice3.toString().isNotEmpty
                      ? thirdPercentProgress()
                      : Container(
                          height: 0.0,
                          width: 0.0,
                        ),
                  Directionality(
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).choiceOne)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Container(
                      height: h * .04,
                      width: w * .4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "$totalCount ${S.of(context).vote} ",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12.0,
                              fontFamily: "SPProtext",
                            ),
                          ),
                          Text(
                            "· ${getTheDifferenceBetweenDate(widget.date)}",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12.0,
                              fontFamily: "SPProtext",
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  firstLinearPercentIndicator(),
                  SizedBox(
                    height: 5.0,
                  ),
                  secondLinearPercentIndicator(),
                  SizedBox(
                    height: 5.0,
                  ),
                  widget.choice3.toString().isNotEmpty
                      ? thirdLinearPercentIndicator()
                      : Container(
                          height: 0.0,
                          width: 0.0,
                        ),
                  Container(
                    height: h * .04,
                    width: w * .4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$totalCount ${S.of(context).vote} · ${getTheDifferenceBetweenDate(widget.date)} Left",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12.0,
                            fontFamily: "SPProtext",
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              show = false;
                            });
                            await users
                                .doc(userId)
                                .collection("Pub")
                                .doc(id)
                                .collection("FirstAnswer")
                                .doc(currentUser.uid)
                                .delete();

                            await users
                                .doc(userId)
                                .collection("Pub")
                                .doc(id)
                                .collection("SecondAnswer")
                                .doc(currentUser.uid)
                                .delete();
                            await users
                                .doc(userId)
                                .collection("Pub")
                                .doc(id)
                                .collection("ThirdAnswer")
                                .doc(currentUser.uid)
                                .delete();
                          },
                          child: Text(
                            S.of(context).undo,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SPProtext",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
