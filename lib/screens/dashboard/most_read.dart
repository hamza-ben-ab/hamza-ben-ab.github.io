import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/loading_widget/pub_loading.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/widget/show_video.dart';

class TheFiveMostRead extends StatefulWidget {
  final String videoUrl;
  final String extension;
  final bool hover;
  final QueryDocumentSnapshot doc;
  const TheFiveMostRead(
      {Key key, this.videoUrl, this.extension, this.hover, this.doc})
      : super(key: key);

  @override
  _TheFiveMostReadState createState() => _TheFiveMostReadState();
}

class _TheFiveMostReadState extends State<TheFiveMostRead> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  FunctionsServices functionsServices = FunctionsServices();
  Timestamp timeAgo;

  @override
  void initState() {
    timeAgo = widget.doc["timeAgo"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).fiveMostRead)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: FutureBuilder<DocumentSnapshot>(
          future: users
              .doc(currentUser.uid)
              .collection("Pub")
              .doc(widget.doc.id)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> pubData = snapshot.data.data();
              String postKind = pubData["postKind"];
              return Container(
                margin: EdgeInsets.all(2.0),
                height: h * .32,
                width: w * .24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[400],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      child: FutureBuilder<DocumentSnapshot>(
                          future: users.doc(currentUser.uid).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> document =
                                  snapshot.data.data();
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                  width: w * .45,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: h * .05,
                                        width: h * .05,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              intl.Bidi.detectRtlDirectionality(
                                                      S
                                                          .of(context)
                                                          .postViewWrittenBy)
                                                  ? BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15.0),
                                                      topRight:
                                                          Radius.circular(15.0),
                                                      bottomLeft:
                                                          Radius.circular(15.0),
                                                    )
                                                  : BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15.0),
                                                      topRight:
                                                          Radius.circular(15.0),
                                                      bottomRight:
                                                          Radius.circular(15.0),
                                                    ),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.network(
                                                      document["image"])
                                                  .image),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    width: w * .28,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      5.0),
                                                          child: Text(
                                                            postKind ==
                                                                    "lastest_news"
                                                                ? S
                                                                    .of(context)
                                                                    .createPostLastestNewsTitle
                                                                : postKind ==
                                                                        "breaking_news"
                                                                    ? S
                                                                        .of(
                                                                            context)
                                                                        .createPostBreakingNewsTitle
                                                                    : postKind ==
                                                                            "commentary"
                                                                        ? S
                                                                            .of(
                                                                                context)
                                                                            .createPostCommentary
                                                                        : postKind ==
                                                                                "essay"
                                                                            ? S.of(context).createPostEssay
                                                                            : postKind == "poll"
                                                                                ? S.of(context).pollTitle
                                                                                : postKind == "research article"
                                                                                    ? S.of(context).addPostArticle
                                                                                    : postKind == "howTo"
                                                                                        ? S.of(context).createHowToTitle
                                                                                        : postKind == "personality"
                                                                                            ? S.of(context).createProfiletitle
                                                                                            : postKind == "analysis"
                                                                                                ? S.of(context).createAnalysisTitle
                                                                                                : postKind == "investigation"
                                                                                                    ? S.of(context).createPostInvestigationTitle
                                                                                                    : postKind == "story"
                                                                                                        ? S.of(context).createStoryTitle
                                                                                                        : postKind == "event"
                                                                                                            ? S.of(context).createPostEventTitle
                                                                                                            : postKind == "inPic"
                                                                                                                ? S.of(context).createPostInpicTitle
                                                                                                                : postKind == "broadcasting"
                                                                                                                    ? S.of(context).createPostBroadcastTitle
                                                                                                                    : "",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[600],
                                                                fontSize: 12.0,
                                                                fontFamily:
                                                                    "SPProtext"),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            postKind == "inPic"
                                                                ? S
                                                                    .of(context)
                                                                    .createPostInpicTitle
                                                                : postKind ==
                                                                        "broadcasting"
                                                                    ? S
                                                                        .of(context)
                                                                        .createPostBroadcastTitle
                                                                    : "",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 10.0,
                                                                fontFamily:
                                                                    "SPProtext"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: w * .28,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          height: h * .02,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                document[
                                                                    "full_name"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "SPProtext"),
                                                              ),
                                                              SizedBox(
                                                                width: 10.0,
                                                              ),
                                                              Text(
                                                                "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(timeAgo.toDate()).toString()} - ${intl.DateFormat.Hm().format(timeAgo.toDate()).toString()} ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontFamily:
                                                                      "SPProtext",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                ),
                              );
                            }
                            return Container(
                              height: 0.0,
                              width: 0.0,
                            );
                          }),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        width: w * .4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                pubData["mediaUrl"] != null
                                    ? Container(
                                        width: w * .12,
                                        height: h * .17,
                                        child: Center(
                                          child: Container(
                                            child: imagesFormat.contains(
                                                    pubData["extension"])
                                                ? Stack(children: [
                                                    Container(
                                                      width: w * .12,
                                                      height: h * .17,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: Image.network(
                                                                    pubData[
                                                                        "mediaUrl"])
                                                                .image),
                                                      ),
                                                    ),
                                                  ])
                                                : videoFormat.contains(
                                                        pubData["extension"])
                                                    ? Stack(children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          width: w * .12,
                                                          height: h * .17,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            child: ShowVideo(
                                                              videoUrl: pubData[
                                                                  "mediaUrl"],
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Icon(
                                                            LineAwesomeIcons
                                                                .play_circle,
                                                            size: 30.0,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ])
                                                    : Container(
                                                        height: h * .15,
                                                        width: 0.0,
                                                      ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: w * .12,
                                        height: h * .17,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: Colors.grey[200]),
                                        child: Center(
                                          child: Container(
                                            width: w * .08,
                                            height: h * .15,
                                            child: Image.asset(
                                                "./assets/images/photo.png"),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: h * .02,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "./assets/icons/082-eyeglasses.svg",
                                        color: Colors.black,
                                        height: 15.0,
                                        width: 15.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        functionsServices
                                            .dividethousand(pubData["readers"]),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontFamily: "SPProtext",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    postKind == "personality"
                                        ? Expanded(
                                            child: Directionality(
                                              textDirection: intl.Bidi
                                                      .detectRtlDirectionality(S
                                                          .of(context)
                                                          .createProfiletitle)
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment: intl.Bidi
                                                              .detectRtlDirectionality(
                                                        pubData["full_name"],
                                                      )
                                                          ? Alignment
                                                              .centerRight
                                                          : Alignment
                                                              .centerLeft,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        margin: intl.Bidi
                                                                .detectRtlDirectionality(
                                                          pubData["full_name"],
                                                        )
                                                            ? EdgeInsets.only(
                                                                right: 5.0)
                                                            : EdgeInsets.only(
                                                                left: 5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: intl.Bidi
                                                                  .detectRtlDirectionality(
                                                                      pubData[
                                                                          "full_name"])
                                                              ? Border(
                                                                  right:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1.0,
                                                                  ),
                                                                )
                                                              : Border(
                                                                  left:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                        ),
                                                        child: Directionality(
                                                          textDirection: intl
                                                                      .Bidi
                                                                  .detectRtlDirectionality(
                                                                      pubData[
                                                                          "full_name"])
                                                              ? TextDirection
                                                                  .rtl
                                                              : TextDirection
                                                                  .ltr,
                                                          child: Text(
                                                            pubData[
                                                                "full_name"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14.0,
                                                                fontFamily:
                                                                    "Lora"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: w * .25,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${S.of(context).createProfileAgeHintText} : ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "SPProtext",
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: pubData[
                                                                    "age"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "SPProtext",
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: w * .25,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${S.of(context).createProfileNationality} : ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "SPProtext",
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: pubData[
                                                                    "Nationality"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "SPProtext",
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: w * .25,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${S.of(context).createProfileOccupation} : ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "SPProtext",
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: pubData[
                                                                    "Occupation"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "SPProtext",
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: w * .25,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${S.of(context).createProfileRelation} : ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "SPProtext",
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: pubData[
                                                                    "status"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "SPProtext",
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: w * .25,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${S.of(context).createProfileHomeTwonHintText} : ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "SPProtext",
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: pubData[
                                                                    "homeTown"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "SPProtext",
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: w * .25,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${S.of(context).createProfilecurrentCityHintText} : ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "SPProtext",
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: pubData[
                                                                    "currentCity"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "SPProtext",
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : postKind != "commentary" &&
                                                postKind != "essay" &&
                                                postKind != "inPic" &&
                                                postKind != "broadcasting" &&
                                                postKind != "event"
                                            ? Align(
                                                alignment: intl.Bidi
                                                        .detectRtlDirectionality(
                                                            pubData["title"])
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  margin: intl.Bidi
                                                          .detectRtlDirectionality(
                                                              pubData["title"])
                                                      ? EdgeInsets.only(
                                                          right: 5.0)
                                                      : EdgeInsets.only(
                                                          left: 5.0),
                                                  decoration: BoxDecoration(
                                                    border: intl.Bidi
                                                            .detectRtlDirectionality(
                                                                pubData[
                                                                    "title"])
                                                        ? Border(
                                                            right: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          )
                                                        : Border(
                                                            left: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                  ),
                                                  child: Directionality(
                                                    textDirection: intl.Bidi
                                                            .detectRtlDirectionality(
                                                                pubData[
                                                                    "title"])
                                                        ? TextDirection.rtl
                                                        : TextDirection.ltr,
                                                    child: Text(
                                                      pubData["title"],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0,
                                                          fontFamily: "Lora"),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: h * .21,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5.0),
                                                  width: w * .45,
                                                  child: Directionality(
                                                    textDirection: intl.Bidi
                                                            .detectRtlDirectionality(
                                                                pubData[
                                                                    "description"])
                                                        ? TextDirection.rtl
                                                        : TextDirection.ltr,
                                                    child: Text(
                                                      pubData["description"],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10.0,
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return pubLoading(h, w);
          }),
    );
  }
}
