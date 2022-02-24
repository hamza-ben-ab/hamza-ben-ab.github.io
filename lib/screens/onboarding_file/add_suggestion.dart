import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:intl/intl.dart' as intl;

class AddAndFollow extends StatefulWidget {
  @override
  _AddAndFollowState createState() => _AddAndFollowState();
}

class _AddAndFollowState extends State<AddAndFollow> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;

  List journalistByCountry = [];
  List tvAndRadioByCountry = [];
  List newspaperAndMagazineByCountry = [];
  var results;

  void getUserDocs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Users");

    QuerySnapshot querySnapshot = await _collectionRef.get();

    setState(() {
      results = querySnapshot.docs.where((document) =>
          document
              .data()["currentLocation"]
              .toString()
              .split(", ")
              .last
              .toLowerCase() ==
          prefs
              .getString("locationValue")
              .toString()
              .split(", ")
              .last
              .toLowerCase());
      results = querySnapshot.docs
          .where((document) => document.data()["kind"] == "Journalist");

      results.map((doc) => journalistByCountry.add(doc)).toList();
    });
  }

  @override
  void initState() {
    getUserDocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: h,
          width: w,
          color: Colors.white,
          child: Column(
            children: [
              TeltrueAppBar(
                nextRoute: "/WelcomePage",
                // backRoute: "/AddProfileImage",
                nextRouteTitle: S.of(context).nextButton,
              ),
              Expanded(
                child: Directionality(
                  textDirection: intl.Bidi.detectRtlDirectionality(
                          S.of(context).descriptionSuggestion)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Container(
                      width: w,
                      child: Center(
                        child: Container(
                          height: h,
                          width: w * .99,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: h * .2,
                                  width: largeScreen ? w * .57 : w * .8,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      S.of(context).descriptionSuggestion,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: "SPProtext",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: h * 0.06,
                                  width: largeScreen ? w * .57 : w * .8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                          future:
                                              users.doc(currentUser.uid).get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Map<String, dynamic> document =
                                                  snapshot.data.data();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Text(
                                                  "${S.of(context).subtitleSuggestion1}  ${document["currentLocation"].toString().split(", ").last}",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              height: 0.0,
                                              width: 0.0,
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                journalistByCountry.length > 0
                                    ? Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: h * 0.4,
                                        width: largeScreen ? w * .57 : w * .8,
                                        child: ListView.builder(
                                          itemCount: journalistByCountry.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            if (journalistByCountry[index].id !=
                                                currentUser.uid) {
                                              return journalistByCountry[
                                                          index] !=
                                                      currentUser.uid
                                                  ? FollowCard(
                                                      doc: journalistByCountry[
                                                          index],
                                                    )
                                                  : Container(
                                                      height: 0.0,
                                                      width: 0.0,
                                                    );
                                            }
                                            return Container(
                                              height: 0.0,
                                              width: 0.0,
                                            );
                                          },
                                        ),
                                      )
                                    : Container(
                                        height: h * 0.4,
                                        width: largeScreen ? w * .57 : w * .8,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            S.of(context).noJournalistYet,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[600],
                                              fontFamily: "SPProtext",
                                            ),
                                          ),
                                        ),
                                      ),
                                Container(
                                  height: h * 0.06,
                                  width: largeScreen ? w * .57 : w * .8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                          future:
                                              users.doc(currentUser.uid).get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Map<String, dynamic> document =
                                                  snapshot.data.data();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Text(
                                                  "${S.of(context).subtitleSuggestion2}  ${document["currentLocation"].toString().split(", ").last}",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              height: 0.0,
                                              width: 0.0,
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                tvAndRadioByCountry.length > 0
                                    ? Container(
                                        decoration: centerBoxDecoration,
                                        padding: EdgeInsets.all(4.0),
                                        height: h * 0.4,
                                        width: largeScreen ? w * .57 : w * .8,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return FollowCard();
                                          },
                                        ),
                                      )
                                    : Container(
                                        decoration: centerBoxDecoration,
                                        height: h * 0.4,
                                        width: largeScreen ? w * .57 : w * .8,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            S.of(context).noTvRadioYet,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[600],
                                              fontFamily: "SPProtext",
                                            ),
                                          ),
                                        ),
                                      ),
                                Container(
                                  height: h * 0.06,
                                  width: largeScreen ? w * .57 : w * .8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                          future:
                                              users.doc(currentUser.uid).get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Map<String, dynamic> document =
                                                  snapshot.data.data();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Text(
                                                  "${S.of(context).subtitleSuggestion3}  ${document["currentLocation"].toString().split(", ").last}",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              height: 0.0,
                                              width: 0.0,
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                newspaperAndMagazineByCountry.length > 0
                                    ? Container(
                                        decoration: centerBoxDecoration,
                                        padding: EdgeInsets.all(4.0),
                                        height: h * 0.4,
                                        width: largeScreen ? w * .57 : w * .8,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return FollowCard();
                                          },
                                        ),
                                      )
                                    : Container(
                                        decoration: centerBoxDecoration,
                                        height: h * 0.4,
                                        width: largeScreen ? w * .57 : w * .8,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            S.of(context).noNewspaperMagazine,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[600],
                                              fontFamily: "SPProtext",
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: h * .05,
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowCard extends StatefulWidget {
  final QueryDocumentSnapshot doc;

  const FollowCard({Key key, this.doc}) : super(key: key);
  @override
  _FollowCardState createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {
  bool isSelected = false;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  String id;

  Widget followButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      child: AnimatedContainer(
        height: !isSelected ? h * 0.05 : h * 0.05,
        width: !isSelected && largeScreen
            ? w * 0.1
            : !isSelected && !largeScreen
                ? w * .3
                : h * 0.08,
        duration: Duration(seconds: 1),
        curve: Curves.decelerate,
        child: !isSelected
            ? Center(
                child: Text(
                  S.of(context).profileFollow,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                      fontFamily: "SPProtext"),
                ),
              )
            : Tooltip(
                message: S.of(context).profileUnfolowButton,
                child: Center(
                  child: Icon(
                    LineAwesomeIcons.user_check,
                    color: Colors.white,
                  ),
                ),
              ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: isSelected
                ? buttonColor
                : hover
                    ? Colors.grey[300]
                    : Colors.grey[200]),
      ),
      onTap: () async {
        DocumentSnapshot user = await users.doc(currentUser.uid).get();
        QuerySnapshot querySnapshot = await users
            .doc(widget.doc.id)
            .collection("Pub")
            .where("postKind", whereNotIn: ["inPic", "broadcasting"]).get();
        QuerySnapshot querySnapshotWatch = await users
            .doc(widget.doc.id)
            .collection("Pub")
            .where("postKind", whereIn: ["inPic", "broadcasting"]).get();
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected) {
          users
              .doc(currentUser.uid)
              .collection("Subscriptions")
              .doc(widget.doc.id)
              .set({
            "name":
                "${widget.doc.data()["firstName"]} ${widget.doc.data()["lastName"]}",
            "image": widget.doc.data()["image"],
            "location": widget.doc.data()["currentLocation"],
          });
          users
              .doc(widget.doc.id)
              .collection("Subscribers")
              .doc(currentUser.uid)
              .set({
            "name":
                "${widget.doc.data()["firstName"]} ${widget.doc.data()["lastName"]}",
            "image": widget.doc.data()["image"],
            "location": widget.doc.data()["currentLocation"],
          });
          users
              .doc(widget.doc.id)
              .collection("Notifications")
              .doc(currentUser.uid)
              .set({
            "seen": false,
            "postKind": "subscribe",
            "userName":
                "${widget.doc.data()["firstName"]} ${widget.doc.data()["lastName"]}",
            "timeAgo": DateTime.now(),
          });
          for (int i = 0; i < querySnapshot.docs.length; i++) {
            users
                .doc(currentUser.uid)
                .collection("Home")
                .doc("${widget.doc.id}==${querySnapshot.docs[i].id}")
                .set({
              "postKind": querySnapshot.docs[i].data()["postKind"],
              "timeAgo": querySnapshot.docs[i].data()["timeAgo"],
              "topic": querySnapshot.docs[i].data()["topic"],
            });
          }
          for (int i = 0; i < querySnapshotWatch.docs.length; i++) {
            users
                .doc(currentUser.uid)
                .collection("Watch")
                .doc("${widget.doc.id}==${querySnapshotWatch.docs[i].id}")
                .set({
              "postKind": querySnapshotWatch.docs[i].data()["postKind"],
              "timeAgo": querySnapshotWatch.docs[i].data()["timeAgo"],
              "topic": querySnapshotWatch.docs[i].data()["topic"],
              "mediaUrl": querySnapshotWatch.docs[i].data()["mediaUrl"],
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    id = widget.doc.id.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
              margin: EdgeInsets.all(5.0),
              height: h * .1,
              width: largeScreen ? w * .12 : w * .4,
              decoration: centerBoxDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Container(
                    height: h * .15,
                    width: h * .15,
                    decoration: BoxDecoration(
                      borderRadius: intl.Bidi.detectRtlDirectionality(
                              S.of(context).postViewWrittenBy)
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
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        width: largeScreen ? w * .12 : w * .4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${data["firstName"]} ${data["lastName"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "SPProtext",
                              ),
                            ),
                            Text(
                              data["workspace"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontFamily: "SPProtext",
                              ),
                            ),
                            Text(
                              data["currentLocation"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  HoverWidget(
                      child: followButtonWidget(false),
                      hoverChild: followButtonWidget(true),
                      onHover: (onHover) {}),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            );
          }
          return suggestionCardLoading();
        });
  }

  Widget suggestionCardLoading() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      margin: EdgeInsets.all(5.0),
      height: h * .1,
      width: largeScreen ? w * .12 : w * .4,
      decoration: centerBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: h * 0.05,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              height: h * .15,
              width: h * .15,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: Container(
              height: h * .015,
              width: largeScreen ? w * .07 : w * .27,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: Container(
              height: h * .012,
              width: largeScreen ? w * .09 : w * .3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              height: h * 0.04,
              width: largeScreen ? w * .1 : w * .3,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
