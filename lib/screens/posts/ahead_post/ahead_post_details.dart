import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/user_loading.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/profile_provider.dart';

class AheadPostDetails extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> data;
  const AheadPostDetails({Key key, this.userId, this.data}) : super(key: key);

  @override
  _AheadPostDetailsState createState() => _AheadPostDetailsState();
}

class _AheadPostDetailsState extends State<AheadPostDetails> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FunctionsServices functionsServices = FunctionsServices();
  String userId;
  Map<String, dynamic> data;

  @override
  void initState() {
    data = widget.data;
    userId = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).postViewWrittenBy)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> document = snapshot.data.data();
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                width: w * .6,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      height: h * .065,
                      width: h * .065,
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
                            image: Image.network(document["image"]).image),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        height: h * .07,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: w * .53,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1.0),
                                        child: Text(
                                          S.of(context).postViewWrittenBy,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SPProtext"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          data["postKind"] == "breaking_news"
                                              ? S
                                                  .of(context)
                                                  .createPostBreakingNewsTitle
                                              : data["postKind"] ==
                                                      "lastest_news"
                                                  ? S
                                                      .of(context)
                                                      .createPostLastestNewsTitle
                                                  : data["postKind"] ==
                                                          "commentary"
                                                      ? S
                                                          .of(context)
                                                          .createPostCommentary
                                                      : data["postKind"] ==
                                                              "essay"
                                                          ? S
                                                              .of(context)
                                                              .createPostEssay
                                                          : data["postKind"] ==
                                                                  "poll"
                                                              ? S
                                                                  .of(context)
                                                                  .pollTitle
                                                              : data["postKind"] ==
                                                                      "research article"
                                                                  ? S
                                                                      .of(
                                                                          context)
                                                                      .addPostArticle
                                                                  : data["postKind"] ==
                                                                          "howTo"
                                                                      ? S
                                                                          .of(
                                                                              context)
                                                                          .createHowToTitle
                                                                      : data["postKind"] ==
                                                                              "analysis"
                                                                          ? S
                                                                              .of(context)
                                                                              .createAnalysisTitle
                                                                          : data["postKind"] == "personality"
                                                                              ? S.of(context).createProfiletitle
                                                                              : data["postKind"] == "investigation"
                                                                                  ? S.of(context).createPostInvestigationTitle
                                                                                  : data["postKind"] == "story"
                                                                                      ? S.of(context).createStoryTitle
                                                                                      : data["postKind"] == "event"
                                                                                          ? S.of(context).createPostEventTitle
                                                                                          : data["postKind"] == "inPic"
                                                                                              ? S.of(context).createPostInpicTitle
                                                                                              : data["postKind"] == "broadcasting"
                                                                                                  ? S.of(context).createPostBroadcastTitle
                                                                                                  : "",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12.0,
                                              fontFamily: "SPProtext"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: h * .03,
                                  width: w * .53,
                                  child: Row(children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();

                                        Provider.of<CenterBoxProvider>(context,
                                                listen: false)
                                            .changeCurrentIndex(7);
                                        Provider.of<ProfileProvider>(context,
                                                listen: false)
                                            .changeProfileId(userId);
                                      },
                                      child: HoverWidget(
                                        child: Text(
                                          document["full_name"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SPProtext"),
                                        ),
                                        hoverChild: Text(
                                          document["full_name"],
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SPProtext"),
                                        ),
                                        onHover: (onHover) {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Container(
                                      height: h * .017,
                                      width: h * .017,
                                      child: Image.asset(
                                          "./assets/images/check (2).png"),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Container(
                                      width: w * .3,
                                      child: Text(
                                        "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(data["timeAgo"].toDate()).toString()} - ${intl.DateFormat.Hm().format(data["timeAgo"].toDate()).toString()} ",
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SPProtext",
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return userLoading(h, w, .6);
          }),
    );
  }
}
