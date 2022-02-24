import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';

class ReportItems extends StatefulWidget {
  final String title;
  final int index;

  const ReportItems({Key key, this.title, this.index}) : super(key: key);
  @override
  _ReportItemsState createState() => _ReportItemsState();
}

class _ReportItemsState extends State<ReportItems> {
  bool isSelected = false;
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected) {
          ReportPostWidget.report.add(widget.title);
        } else {
          ReportPostWidget.report.remove(widget.title);
        }
        print(ReportPostWidget.report);
      },
      child: HoverWidget(
        child: reportWidget(false),
        hoverChild: reportWidget(true),
        onHover: (onHover) {},
      ),
    );
  }

  Widget reportWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: h * .04,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.circular(15.0),
          color: isSelected
              ? Color(0xFF055870)
              : hover
                  ? Colors.grey[300]
                  : Colors.grey[100],
        ),
        child: Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: "SPProtext",
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class ReportPostWidget extends StatefulWidget {
  final String userd;
  final String id;
  static List<String> report = [];

  const ReportPostWidget({Key key, this.userd, this.id}) : super(key: key);

  @override
  _ReportPostWidgetState createState() => _ReportPostWidgetState();
}

class _ReportPostWidgetState extends State<ReportPostWidget> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  String userId;
  String id;

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
          S.of(context).sendButton,
          style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontFamily: "SPProtext",
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  void initState() {
    userId = widget.userd;
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .5,
      width: w * .4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          Container(
            height: h * .1,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: h * .1,
                  width: w * .25,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).report,
                      style: TextStyle(
                          color: Color(0xFF11202D),
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: cancelButton(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: h * .03,
          ),
          Container(
            width: w * .5,
            height: h * .03,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                S.of(context).reportSelectProb,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: "SPProtext"),
              ),
            ),
          ),
          SizedBox(
            height: h * .03,
          ),
          Container(
            width: w * .4,
            height: h * .25,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                runAlignment: WrapAlignment.center,
                runSpacing: 8.0,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: [
                  ReportItems(title: S.of(context).report1),
                  ReportItems(title: S.of(context).report2),
                  ReportItems(title: S.of(context).report3),
                  ReportItems(
                    title: S.of(context).report4,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: h * .05,
            width: w * .4,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    DocumentSnapshot user =
                        await users.doc(currentUser.uid).get();
                    DocumentSnapshot pub =
                        await users.doc(userId).collection("Pub").doc(id).get();

                    await users
                        .doc(userId)
                        .collection("Pub")
                        .doc(id)
                        .collection("Report")
                        .doc(currentUser.uid)
                        .set({
                      "report": ReportPostWidget.report,
                    }, SetOptions(merge: true));
                    QuerySnapshot count = await users
                        .doc(userId)
                        .collection("Pub")
                        .doc(id)
                        .collection("Report")
                        .get();
                    QuerySnapshot readersCount = await users
                        .doc(userId)
                        .collection("Pub")
                        .doc(id)
                        .collection(pub.data()["postkind"] == "inPic" ||
                                pub.data()["postkind"] == "broadcasting"
                            ? "Views"
                            : "Readers")
                        .get();
                    if (readersCount.docs.length / 3 < count.docs.length &&
                        readersCount.docs.length > 100) {
                      users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .set({"close": true});
                      allPub.doc("$userId==$id").delete();
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

                    if (userId != currentUser.uid) {
                      await users
                          .doc(userId)
                          .collection("Notifications")
                          .doc("$userId*report*$id")
                          .set({
                        "seen": false,
                        "timeAgo": DateTime.now(),
                        "postKind": "report",
                        "count": count.docs.length - 1,
                        "uid": currentUser.uid,
                        "pubKind": pub.data()["postKind"],
                        "userName": user.data()["full_name"],
                      }, SetOptions(merge: true));

                      users.doc(userId).collection("Pub").doc(id).set({
                        "report": count.docs.length,
                      }, SetOptions(merge: true));
                    }

                    Navigator.of(context).pop();
                  },
                  child: HoverWidget(
                    child: sendButton(false),
                    hoverChild: sendButton(true),
                    onHover: (onHover) {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
