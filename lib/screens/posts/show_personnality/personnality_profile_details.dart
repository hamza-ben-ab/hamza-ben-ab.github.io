import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/loading_widget/post_details_loading.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_details.dart';
import 'package:uy/screens/posts/comment/comment_page.dart';
import 'package:uy/screens/posts/post_widgets/true_false_bar.dart';
import 'package:uy/screens/posts/post_widgets/true_false_buttonBar.dart';
import 'package:uy/services/functions.dart';
import 'package:intl/intl.dart' as intl;

class PersonnalityProfileDetails extends StatefulWidget {
  final String userId;
  final String id;

  const PersonnalityProfileDetails({Key key, this.userId, this.id})
      : super(key: key);

  @override
  _PersonnalityProfileDetailsState createState() =>
      _PersonnalityProfileDetailsState();
}

class _PersonnalityProfileDetailsState
    extends State<PersonnalityProfileDetails> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FunctionsServices functionsServices = FunctionsServices();
  String userId;
  String id;
  ScrollController bnScrollController = ScrollController();
  ScrollController commentScrollController = ScrollController();

  Future read(String userId, String id) async {
    await users
        .doc(userId)
        .collection("Pub")
        .doc(id)
        .collection("Readers")
        .doc(currentUser.uid)
        .set({
      "uid": currentUser.uid,
    });
    QuerySnapshot doc = await users
        .doc(userId)
        .collection("Pub")
        .doc(id)
        .collection("Readers")
        .get();
    await users
        .doc(userId)
        .collection("Pub")
        .doc(id)
        .update({"readers": doc.docs.length});
  }

  @override
  void initState() {
    userId = widget.userId;
    id = widget.id;
    read(userId, id);
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
              width: w * .6,
              height: h * .85,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  AheadPostDetails(
                    userId: userId,
                    data: data,
                  ),
                  Expanded(
                      child: Container(
                    width: w * .6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TrueAndFalseBar(
                            userId: userId,
                            id: id,
                          ),
                          SizedBox(
                            height: h * .02,
                          ),
                          Container(
                            width: w * .6,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  width: w * .2,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: w * .2,
                                      height: h * .4,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(
                                            data["mediaUrl"],
                                          ).image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: w * .3,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[400]),
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.grey[50]),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: w * .3,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${S.of(context).fullNameTitleSignUpWithEmail} : ",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: data["full_name"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        width: w * .3,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${S.of(context).createProfileAgeHintText} : ",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: data["age"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        width: w * .3,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${S.of(context).createProfileNationality} : ",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: data["Nationality"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        width: w * .3,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${S.of(context).createProfileOccupation} : ",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: data["Occupation"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                      data["education"] != null
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 3.0),
                                              width: w * .3,
                                              child: RichText(
                                                text: TextSpan(
                                                    text:
                                                        "${S.of(context).createProfileEducation} : ",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: accentColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "SPProtext",
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: data["education"],
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "SPProtext",
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            )
                                          : Container(
                                              height: 0.0,
                                              width: 0.0,
                                            ),
                                      data["status"] != null
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 3.0),
                                              width: w * .3,
                                              child: RichText(
                                                text: TextSpan(
                                                    text:
                                                        "${S.of(context).createProfileRelation} : ",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: accentColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "SPProtext",
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: data["status"],
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "SPProtext",
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            )
                                          : Container(
                                              height: 0.0,
                                              width: 0.0,
                                            ),
                                      data["children"] != null
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 3.0),
                                              width: w * .3,
                                              child: RichText(
                                                text: TextSpan(
                                                    text:
                                                        "${S.of(context).createProfileChildren} : ",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: accentColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "SPProtext",
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: data["children"],
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "SPProtext",
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            )
                                          : Container(
                                              height: 0.0,
                                              width: 0.0,
                                            ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        width: w * .3,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${S.of(context).createProfileHomeTwonHintText} : ",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: data["homeTown"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        width: w * .3,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${S.of(context).createProfilecurrentCityHintText} : ",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: data["currentCity"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: w * .55,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).career,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: "SPProtext",
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  width: w * .55,
                                  child: Text(
                                    data["description"],
                                    overflow: TextOverflow.fade,
                                    textDirection:
                                        intl.Bidi.detectRtlDirectionality(
                                                data["description"])
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontFamily: "Avenir"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TrueAndFalseButtonBar(
                            userId: userId,
                            id: widget.id,
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            );
          }
          return postDetailsLoading(h, w);
        });
  }
}

class GlobalPersonnalityProfil extends StatefulWidget {
  final String userId;
  final String id;
  const GlobalPersonnalityProfil({Key key, this.userId, this.id})
      : super(key: key);

  @override
  _GlobalPersonnalityProfilState createState() =>
      _GlobalPersonnalityProfilState();
}

class _GlobalPersonnalityProfilState extends State<GlobalPersonnalityProfil> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: h * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PersonnalityProfileDetails(
            userId: widget.userId,
            id: widget.id,
          ),
          Container(
            height: h * .85,
            width: w * .25,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: PostCommentPage(),
          ),
        ],
      ),
    );
  }
}
