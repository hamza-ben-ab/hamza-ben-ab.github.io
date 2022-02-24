import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/dashboard/deleted_post.dart';
import 'package:uy/screens/dashboard/most_read.dart';
import 'package:uy/screens/dashboard/most_view.dart';
import 'package:countup/countup.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:intl/intl.dart' as intl;

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  int readersCount = 0;
  int viewsCount = 0;
  int trueCount = 0;
  int falseCount = 0;
  int likeCount = 0;
  int dislikeCount = 0;
  int reportCount = 0;
  AlertWidgets alertWidgets = AlertWidgets();

  Future getReadCount() async {
    QuerySnapshot pubQuerySnapshot =
        await users.doc(currentUser.uid).collection("Pub").get();
    pubQuerySnapshot.docs.forEach((document) async {
      CollectionReference readerCollectionRef = users
          .doc(currentUser.uid)
          .collection("Pub")
          .doc(document.id)
          .collection("Readers");

      QuerySnapshot readerQuerySnapshot = await readerCollectionRef.get();

      setState(() {
        readersCount += readerQuerySnapshot.docs.length;
      });
    });
  }

  Future getWatchCount() async {
    QuerySnapshot pubQuerySnapshot =
        await users.doc(currentUser.uid).collection("Pub").get();
    pubQuerySnapshot.docs.forEach((document) async {
      CollectionReference readerCollectionRef = users
          .doc(currentUser.uid)
          .collection("Pub")
          .doc(document.id)
          .collection("Views");

      QuerySnapshot readerQuerySnapshot = await readerCollectionRef.get();

      setState(() {
        viewsCount += readerQuerySnapshot.docs.length;
      });
    });
  }

  Future getTrueAndFalseCount() async {
    QuerySnapshot pubQuerySnapshot =
        await users.doc(currentUser.uid).collection("Pub").get();
    pubQuerySnapshot.docs.forEach((document) async {
      CollectionReference readerCollectionRef = users
          .doc(currentUser.uid)
          .collection("Pub")
          .doc(document.id)
          .collection("TrueOrFalse");

      QuerySnapshot readerQuerySnapshot = await readerCollectionRef.get();

      readerQuerySnapshot.docs.forEach((element) {
        if (element.data()["trueOrfalse"] == "true") {
          setState(() {
            ++trueCount;
          });
        } else {
          setState(() {
            ++falseCount;
          });
        }
      });
    });
  }

  Future getLikeAndDislikeCount() async {
    QuerySnapshot pubQuerySnapshot =
        await users.doc(currentUser.uid).collection("Pub").get();
    pubQuerySnapshot.docs.forEach((document) async {
      CollectionReference readerCollectionRef = users
          .doc(currentUser.uid)
          .collection("Pub")
          .doc(document.id)
          .collection("LikeOrDislike");

      QuerySnapshot readerQuerySnapshot = await readerCollectionRef.get();

      readerQuerySnapshot.docs.forEach((element) {
        if (element.data()["LikeOrDislike"] == "like") {
          setState(() {
            ++likeCount;
          });
        } else {
          setState(() {
            ++dislikeCount;
          });
        }
      });
    });
  }

  Future getReportCount() async {
    QuerySnapshot pubQuerySnapshot =
        await users.doc(currentUser.uid).collection("Pub").get();
    pubQuerySnapshot.docs.forEach((document) async {
      CollectionReference readerCollectionRef = users
          .doc(currentUser.uid)
          .collection("Pub")
          .doc(document.id)
          .collection("Report");

      QuerySnapshot readerQuerySnapshot = await readerCollectionRef.get();

      setState(() {
        reportCount += readerQuerySnapshot.docs.length;
      });
    });
  }

  @override
  void initState() {
    getReadCount();
    getWatchCount();
    getTrueAndFalseCount();
    getLikeAndDislikeCount();
    getReportCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 3,
      width: w * .75,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * .03,
            ),
            Container(
              width: w * .75,
              height: h * 3,
              child: StaggeredGridView.count(
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                padding: EdgeInsets.only(right: 15.0, left: 10.0),
                crossAxisCount: 4,
                scrollDirection: Axis.vertical,
                children: [
                  //first
                  Container(
                    child: StaggeredGridView.count(
                      crossAxisCount: 4,
                      scrollDirection: Axis.vertical,
                      children: [
                        dashboardItems(
                          S.of(context).read,
                          "082-eyeglasses",
                          readersCount.toDouble(),
                        ),
                        dashboardItems(
                          S.of(context).views,
                          "083-eye",
                          viewsCount.toDouble(),
                        ),
                        dashboardItems(
                          S.of(context).trueKey,
                          "036-check",
                          trueCount.toDouble(),
                        ),
                        dashboardItems(
                          S.of(context).falseKey,
                          "068-cancel",
                          falseCount.toDouble(),
                        ),
                        dashboardItems(
                          S.of(context).like,
                          "195-like",
                          likeCount.toDouble(),
                        ),
                        dashboardItems(
                          S.of(context).dislike,
                          "194-dislike",
                          dislikeCount.toDouble(),
                        ),
                        dashboardItems(
                          S.of(context).report,
                          "alert",
                          reportCount.toDouble(),
                        ),
                      ],
                      staggeredTiles: [
                        StaggeredTile.count(1, 1),
                        StaggeredTile.count(1, 1),
                        StaggeredTile.count(1, 1),
                        StaggeredTile.count(1, 1),
                        StaggeredTile.count(1, 1),
                        StaggeredTile.count(1, 1),
                        StaggeredTile.count(1, 1),
                      ],
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                  ),
                  //second
                  Directionality(
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).fiveMostRead)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                left: 20.0,
                                right: 20.0),
                            child: Text(
                              S.of(context).fiveMostRead,
                              textDirection: intl.Bidi.detectRtlDirectionality(
                                      S.of(context).fiveMostRead)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: users
                                      .doc(currentUser.uid)
                                      .collection("Pub")
                                      .orderBy("readers", descending: true)
                                      .limit(5)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: 0.0,
                                        width: 0.0,
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return alertWidgets.errorWidget(h, w,
                                          S.of(context).noContentAvailable);
                                    }

                                    if (snapshot.data.docs.isEmpty) {
                                      return alertWidgets.emptyWidget(h, w,
                                          S.of(context).noOtherPublication);
                                    }
                                    return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        return TheFiveMostRead(
                                          doc: snapshot.data.docs[index],
                                        );
                                      },
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //third
                  Directionality(
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).fiveMostRead)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0,
                                left: 20.0),
                            child: Text(
                              S.of(context).fiveMostViews,
                              textDirection: intl.Bidi.detectRtlDirectionality(
                                      S.of(context).fiveMostRead)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: users
                                      .doc(currentUser.uid)
                                      .collection("Pub")
                                      .orderBy("views", descending: true)
                                      .limit(5)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: 0.0,
                                        width: 0.0,
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return alertWidgets.errorWidget(h, w,
                                          S.of(context).noContentAvailable);
                                    }

                                    if (snapshot.data.docs.isEmpty) {
                                      return alertWidgets.emptyWidget(h, w,
                                          S.of(context).noOtherPublication);
                                    }

                                    return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        return TheFiveMostView(
                                          doc: snapshot.data.docs[index],
                                        );
                                      },
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //four
                  Directionality(
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).fiveMostRead)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0,
                                left: 20.0),
                            child: Text(
                              S.of(context).deletedPost,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: users
                                      .doc(currentUser.uid)
                                      .collection("Pub")
                                      .where("close", isEqualTo: true)
                                      .limit(3)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: 0.00,
                                        width: 0.0,
                                      );
                                    }
                                    if (snapshot.data.docs.isEmpty) {
                                      return alertWidgets.emptyWidget(
                                        h,
                                        w,
                                        S.of(context).noPostDeletedYet,
                                      );
                                    }

                                    return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        return DeletedPost(
                                          doc: snapshot.data.docs[index],
                                        );
                                      },
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.count(2, 1.1),
                  StaggeredTile.count(2, 5.2),
                  StaggeredTile.count(2, 5.2),
                  StaggeredTile.count(2, 5.0),
                ],
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardItems(String title, String icon, double count) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: h * .1,
        width: w * .15,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            border: Border.all(color: Colors.grey[400])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: h * .05,
              width: h * .05,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.cyan[600]),
              child: Center(
                child: SvgPicture.asset(
                  "./assets/icons/$icon.svg",
                  color: Colors.white,
                  height: h * .05,
                  width: h * .05,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Countup(
                begin: 0,
                end: count,
                duration: Duration(seconds: 1),
                separator: ',',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext"),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
