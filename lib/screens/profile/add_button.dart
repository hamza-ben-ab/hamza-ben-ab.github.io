import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/services/provider/profile_provider.dart';

class AddButton extends StatefulWidget {
  final String userId;

  const AddButton({Key key, this.userId}) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  bool isFollow = false;

  Future<void> checkSubscribe() async {
    DocumentSnapshot user = await users
        .doc(currentUser.uid)
        .collection("Subscriptions")
        .doc(widget.userId)
        .get();
    setState(() {
      if (user.exists) {
        isFollow = true;
      } else {
        isFollow = false;
      }
    });
  }

  @override
  void initState() {
    checkSubscribe();
    super.initState();
  }

  void unFollow(String profileName, String profileImage, String uid) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                width: w * .35,
                height: h * .25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: h * .03,
                    ),
                    Container(
                      height: h * .08,
                      width: h * .08,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: Image.network(profileImage).image,
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      height: h * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: S.of(context).profileUnfollowRequest,
                              style: TextStyle(fontSize: 14.0),
                              children: [
                                TextSpan(
                                  text: "  " + profileName + " ?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: h * .07,
                      width: w * .35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              height: h * 0.05,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Center(
                                child: Text(
                                  S.of(context).profileUnfolowButton,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.red[300],
                              ),
                            ),
                            onTap: () async {
                              setState(() {
                                isFollow = false;
                              });

                              await users
                                  .doc(currentUser.uid)
                                  .collection("Subscriptions")
                                  .doc(uid)
                                  .delete();
                              await users
                                  .doc(uid)
                                  .collection("Subscribers")
                                  .doc(currentUser.uid)
                                  .delete();

                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            child: Container(
                              height: h * 0.05,
                              width: w * 0.12,
                              child: Center(
                                child: Text(
                                  S.of(context).cancelButton,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontFamily: "SPProtext"),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.cyan[600],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

  Widget subscribeIconWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      height: !isFollow ? h * 0.05 : h * 0.05,
      width: !isFollow ? w * 0.1 : h * 0.08,
      duration: Duration(seconds: 2),
      curve: Curves.decelerate,
      child: !isFollow
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
      decoration: isFollow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.cyan[600])
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: hover ? Colors.grey[400] : Colors.grey[300]),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<ProfileProvider>(context).userId;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data.data();
          return InkWell(
              child: HoverWidget(
                  child: subscribeIconWidget(false),
                  hoverChild: subscribeIconWidget(true),
                  onHover: (onHover) {}),
              onTap: () async {
                DocumentSnapshot user = await users.doc(currentUser.uid).get();
                DocumentSnapshot doc = await users.doc(widget.userId).get();
                QuerySnapshot querySnapshot = await users
                    .doc(widget.userId)
                    .collection("Pub")
                    .where("postKind", whereNotIn: [
                  "inPic",
                  "broadcasting",
                  "breaking_news"
                ]).get();
                QuerySnapshot queryBreakingNews = await users
                    .doc(widget.userId)
                    .collection("Pub")
                    .where("postKind", isEqualTo: "breaking_news")
                    .get();
                QuerySnapshot querySnapshotWatch = await users
                    .doc(widget.userId)
                    .collection("Pub")
                    .where("postKind",
                        whereIn: ["inPic", "broadcasting"]).get();

                if (isFollow == false) {
                  setState(() {
                    isFollow = true;
                  });
                  users
                      .doc(currentUser.uid)
                      .collection("Subscriptions")
                      .doc(widget.userId)
                      .set({
                    "name": doc.data()["full_name"],
                    "image": doc.data()["image"],
                    "location": doc.data()["location"],
                  });
                  users
                      .doc(widget.userId)
                      .collection("Subscribers")
                      .doc(currentUser.uid)
                      .set({
                    "name": user.data()["full_name"],
                    "image": user.data()["image"],
                    "location": user.data()["location"],
                  });
                  users
                      .doc(widget.userId)
                      .collection("Notifications")
                      .doc(currentUser.uid)
                      .set({
                    "seen": false,
                    "postKind": "subscribe",
                    "userName": user.data()["full_name"],
                    "timeAgo": DateTime.now(),
                  });
                  for (int i = 0; i < querySnapshot.docs.length; i++) {
                    users
                        .doc(currentUser.uid)
                        .collection("Home")
                        .doc("${widget.userId}==${querySnapshot.docs[i].id}")
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
                        .doc(
                            "${widget.userId}==${querySnapshotWatch.docs[i].id}")
                        .set({
                      "postKind": querySnapshotWatch.docs[i].data()["postKind"],
                      "timeAgo": querySnapshotWatch.docs[i].data()["timeAgo"],
                      "topic": querySnapshotWatch.docs[i].data()["topic"],
                      "mediaUrl": querySnapshotWatch.docs[i].data()["mediaUrl"],
                    });
                  }
                  DateTime timeNow = DateTime.now();
                  for (int i = 0; i < queryBreakingNews.docs.length; i++) {
                    if (timeNow
                            .difference(
                                queryBreakingNews.docs[i].data()["timeAgo"])
                            .inHours <
                        24) {
                      users
                          .doc(currentUser.uid)
                          .collection("Breaking News")
                          .doc(
                              "${widget.userId}==${queryBreakingNews.docs[i].id}")
                          .set({
                        "timeAgo": queryBreakingNews.docs[i].data()["timeAgo"],
                        "close": false,
                        "seen": false
                      });
                    }
                  }
                } else {
                  unFollow(data["full_name"], data["image"], widget.userId);
                }
              });
        }

        return Container(
          height: 0.0,
          width: 0.0,
        );
      },
    );
  }
}
