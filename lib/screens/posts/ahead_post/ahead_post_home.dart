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
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';

class AheadPostHome extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> data;
  const AheadPostHome({Key key, this.userId, this.data}) : super(key: key);

  @override
  _AheadPostHomeState createState() => _AheadPostHomeState();
}

class _AheadPostHomeState extends State<AheadPostHome> {
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
              final String postKind = data["postKind"];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[400]),
                  ),
                ),
                padding: const EdgeInsets.all(2.0),
                width: w * .4,
                child: Row(
                  children: [
                    Container(
                      height: h * .05,
                      width: h * .05,
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
                        height: h * .06,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: w * .35,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1.0),
                                        child: Text(
                                          postKind == "inPic"
                                              ? S.of(context).pictureBy
                                              : postKind == "broadcasting"
                                                  ? S.of(context).videoBy
                                                  : S
                                                      .of(context)
                                                      .postViewWrittenBy,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12.0,
                                            fontFamily: "SPProtext",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          postKind == "lastest_news"
                                              ? S
                                                  .of(context)
                                                  .createPostLastestNewsTitle
                                              : postKind == "commentary"
                                                  ? S
                                                      .of(context)
                                                      .createPostCommentary
                                                  : postKind == "essay"
                                                      ? S
                                                          .of(context)
                                                          .createPostEssay
                                                      : widget.data[
                                                                  "postKind"] ==
                                                              "poll"
                                                          ? S
                                                              .of(context)
                                                              .pollTitle
                                                          : widget.data[
                                                                      "postKind"] ==
                                                                  "research article"
                                                              ? S
                                                                  .of(context)
                                                                  .addPostArticle
                                                              : widget.data[
                                                                          "postKind"] ==
                                                                      "howTo"
                                                                  ? S
                                                                      .of(
                                                                          context)
                                                                      .createHowToTitle
                                                                  : widget.data[
                                                                              "postKind"] ==
                                                                          "personality"
                                                                      ? S
                                                                          .of(
                                                                              context)
                                                                          .createProfiletitle
                                                                      : postKind ==
                                                                              "analysis"
                                                                          ? S
                                                                              .of(context)
                                                                              .createAnalysisTitle
                                                                          : postKind == "investigation"
                                                                              ? S.of(context).createPostInvestigationTitle
                                                                              : postKind == "story"
                                                                                  ? S.of(context).createStoryTitle
                                                                                  : postKind == "inPic"
                                                                                      ? S.of(context).createPostInpicTitle
                                                                                      : postKind == "broadcasting"
                                                                                          ? S.of(context).createPostBroadcastTitle
                                                                                          : "",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 10.0,
                                            fontFamily: "SPProtext",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: w * .34,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: h * .03,
                                        child: Row(children: [
                                          InkWell(
                                              onTap: () {
                                                Provider.of<HideLeftBarProvider>(
                                                        context,
                                                        listen: false)
                                                    .closeleftBar();
                                                Provider.of<CenterBoxProvider>(
                                                        context,
                                                        listen: false)
                                                    .changeCurrentIndex(7);
                                                Provider.of<ProfileProvider>(
                                                        context,
                                                        listen: false)
                                                    .changeProfileId(userId);
                                              },
                                              child: HoverWidget(
                                                  child: Text(
                                                    document["full_name"],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "SPProtext"),
                                                  ),
                                                  hoverChild: Text(
                                                    document["full_name"],
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "SPProtext"),
                                                  ),
                                                  onHover: (onHover) {})),
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
                                          Text(
                                            "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(data["timeAgo"].toDate()).toString()} - ${intl.DateFormat.Hm().format(data["timeAgo"].toDate()).toString()} ",
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext"),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
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
            return userLoading(h, w, .45);
          }),
    );
  }
}
