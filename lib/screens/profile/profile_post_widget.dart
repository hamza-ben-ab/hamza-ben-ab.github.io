import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/loading_widget/trending_loading.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/widget/show_video.dart';

class ProfilePostWidget extends StatefulWidget {
  final QueryDocumentSnapshot document;
  final String userId;
  final String id;

  const ProfilePostWidget({Key key, this.document, this.userId, this.id})
      : super(key: key);

  @override
  _ProfilePostWidgetState createState() => _ProfilePostWidgetState();
}

class _ProfilePostWidgetState extends State<ProfilePostWidget> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FunctionsServices functionsServices = FunctionsServices();
  User currentUser = FirebaseAuth.instance.currentUser;
  String postKind;
  String userId;
  String id;

  bool closeNews = false;

  isClose() async {
    DocumentSnapshot docField =
        await users.doc(widget.userId).collection("Pub").doc(widget.id).get();
    if (docField.data()["close"]) {
      setState(() {
        closeNews = true;
      });
    } else {
      setState(() {
        closeNews = false;
      });
    }
  }

  @override
  void initState() {
    postKind = widget.document["postKind"];
    userId = widget.userId;
    id = widget.id;
    isClose();
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
            String postKind = data["postKind"];
            return closeNews
                ? trendingitemWidgetClose(
                    data["mediaUrl"],
                    data["extension"],
                    data["timeAgo"],
                    data["title"],
                    data["description"],
                  )
                : InkWell(
                    onTap: () {
                      Provider.of<ReadPostProvider>(context, listen: false)
                          .changePostId(userId, widget.id);
                      showDialog(
                        context: (context),
                        builder: (context) {
                          return ShowPostDetails(
                            id: widget.id,
                            postKind: postKind,
                          );
                        },
                      );
                    },
                    child: HoverWidget(
                      child: trendingitemWidget(
                        false,
                        data["mediaUrl"],
                        data["extension"],
                        data["timeAgo"],
                        data["title"],
                        data["description"],
                      ),
                      hoverChild: trendingitemWidget(
                          true,
                          data["mediaUrl"],
                          data["extension"],
                          data["timeAgo"],
                          data["title"],
                          data["description"]),
                      onHover: (onHover) {},
                    ),
                  );
          }
          return trendingLoading(h, w);
        });
  }

  Widget trendingitemWidget(bool hover, String mediaUrl, String extension,
      Timestamp timeAgo, String title, String description) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w * .25,
      height: h * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        border: Border.all(
          color: hover ? Colors.blue : Colors.grey[400],
        ),
      ),
      child: Column(
        children: [
          Stack(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: mediaUrl != null
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: h * .2,
                          width: w * .2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: videoFormat.contains(extension)
                              ? ShowVideo(
                                  videoUrl: mediaUrl,
                                )
                              : Center(
                                  child: Image.network(mediaUrl),
                                ),
                        ),
                        videoFormat.contains(extension)
                            ? Center(
                                child: Icon(
                                  LineAwesomeIcons.play,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              )
                      ],
                    )
                  : Container(
                      height: h * .2,
                      width: w * .2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey[200]),
                      child: Center(
                        child: Container(
                          width: w * .08,
                          height: h * .15,
                          child: Image.asset("./assets/images/photo.png"),
                        ),
                      ),
                    ),
            ),
          ]),
          SizedBox(height: 3.0),
          Directionality(
            textDirection: intl.Bidi.detectRtlDirectionality(
                    S.of(context).profileFollowing)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: FutureBuilder<DocumentSnapshot>(
                future: users.doc(userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> document = snapshot.data.data();
                    return Container(
                      width: w * .2,
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Container(
                            height: h * .05,
                            width: h * .05,
                            decoration: BoxDecoration(
                              borderRadius: intl.Bidi.detectRtlDirectionality(
                                      S.of(context).profileFollowing)
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
                                  image:
                                      Image.network(document["image"]).image),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: h * .03,
                                    child: Row(children: [
                                      InkWell(
                                        onTap: () {},
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
                                    ]),
                                  ),
                                  Text(
                                    "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(timeAgo.toDate()).toString()} - ${intl.DateFormat.Hm().format(timeAgo.toDate()).toString()} ",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SPProtext"),
                                  ),
                                ],
                              ),
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
          ),
          SizedBox(height: 1.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: h * .04,
                        width: h * .04,
                        child: Center(
                          child: SvgPicture.asset(
                            postKind == "broadcasting" || postKind == "inPic"
                                ? "./assets/icons/083-eye.svg"
                                : postKind == "event"
                                    ? "./assets/icons/user.svg"
                                    : "./assets/icons/082-eyeglasses.svg",
                            height: 20.0,
                            width: 20.0,
                            color: accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection(postKind == "event"
                                  ? "interested"
                                  : postKind != "broadcasting" &&
                                          postKind != "inPic"
                                      ? "Readers"
                                      : "Views")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                height: 0.0,
                                width: 0.0,
                              );
                            }

                            return Text(
                              functionsServices
                                  .dividethousand(snapshot.data.docs.length),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[700],
                                fontFamily: "SPProtext",
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Text(
                  postKind == "lastest_news"
                      ? S.of(context).createPostLastestNewsTitle
                      : postKind == "poll"
                          ? S.of(context).pollTitle
                          : postKind == "commentary"
                              ? S.of(context).createPostCommentary
                              : postKind == "essay"
                                  ? S.of(context).createPostEssay
                                  : postKind == "research article"
                                      ? S.of(context).addPostArticle
                                      : postKind == "howTo"
                                          ? S.of(context).createHowToTitle
                                          : postKind == "personality"
                                              ? S.of(context).createProfiletitle
                                              : postKind == "analysis"
                                                  ? S
                                                      .of(context)
                                                      .createAnalysisTitle
                                                  : postKind == "investigation"
                                                      ? S
                                                          .of(context)
                                                          .createPostInvestigationTitle
                                                      : postKind == "story"
                                                          ? S
                                                              .of(context)
                                                              .createStoryTitle
                                                          : postKind ==
                                                                  "broadcasting"
                                                              ? S
                                                                  .of(context)
                                                                  .createPostBroadcastTitle
                                                              : postKind ==
                                                                      "inPic"
                                                                  ? S
                                                                      .of(
                                                                          context)
                                                                      .createPostInpicTitle
                                                                  : postKind ==
                                                                          "breaking_news"
                                                                      ? S
                                                                          .of(
                                                                              context)
                                                                          .addPostBreakingNews
                                                                      : postKind ==
                                                                              "event"
                                                                          ? S
                                                                              .of(context)
                                                                              .tagEvent
                                                                          : "",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext",
                  ),
                ),
              ],
            ),
          ),
          postKind != "personality" &&
                  postKind != "commentary" &&
                  postKind != "essay" &&
                  postKind != "inPic" &&
                  postKind != "broadcasting"
              ? Container(
                  width: w * .2,
                  child: Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: h * .07),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 5.0),
                          width: w * .2,
                          child: Text(
                            title,
                            overflow: TextOverflow.fade,
                            textDirection:
                                intl.Bidi.detectRtlDirectionality(title)
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontFamily: "Lora"),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: h * .07),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                    width: w * .2,
                    child: Text(
                      description,
                      overflow: TextOverflow.fade,
                      textDirection:
                          intl.Bidi.detectRtlDirectionality(description)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,
                          fontFamily: "Avenir"),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget trendingitemWidgetClose(String mediaUrl, String extension,
      Timestamp timeAgo, String title, String description) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w * .25,
      height: h * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.red,
        ),
      ),
      child: Column(
        children: [
          Stack(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: mediaUrl != null
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: h * .2,
                          width: w * .2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: videoFormat.contains(extension)
                              ? ShowVideo(
                                  videoUrl: mediaUrl,
                                )
                              : Center(
                                  child: Image.network(mediaUrl),
                                ),
                        ),
                        videoFormat.contains(extension)
                            ? Center(
                                child: Icon(
                                  LineAwesomeIcons.play,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        Container(
                          height: h * .2,
                          width: w * .2,
                          color: Colors.grey[200].withOpacity(0.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "./assets/icons/cross.svg",
                                color: Colors.red,
                                height: 70.0,
                                width: 70.0,
                              ),
                              Expanded(
                                child: Text(
                                  S.of(context).deletePostDescription,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(
                      height: h * .2,
                      width: w * .2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey[200]),
                      child: Center(
                        child: Container(
                          width: w * .08,
                          height: h * .15,
                          child: Image.asset("./assets/images/photo.png"),
                        ),
                      ),
                    ),
            ),
          ]),
          SizedBox(height: 3.0),
          Directionality(
            textDirection: intl.Bidi.detectRtlDirectionality(
                    S.of(context).profileFollowing)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: FutureBuilder<DocumentSnapshot>(
                future: users.doc(userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> document = snapshot.data.data();
                    return Container(
                      width: w * .2,
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Container(
                            height: h * .05,
                            width: h * .05,
                            decoration: BoxDecoration(
                              borderRadius: intl.Bidi.detectRtlDirectionality(
                                      S.of(context).profileFollowing)
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
                                  image:
                                      Image.network(document["image"]).image),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: h * .03,
                                    child: Row(children: [
                                      InkWell(
                                        onTap: () {},
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
                                    ]),
                                  ),
                                  Text(
                                    "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(timeAgo.toDate()).toString()} - ${intl.DateFormat.Hm().format(timeAgo.toDate()).toString()} ",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SPProtext"),
                                  ),
                                ],
                              ),
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
          ),
          SizedBox(height: 1.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: h * .04,
                        width: h * .04,
                        child: Center(
                          child: SvgPicture.asset(
                            postKind == "broadcasting" || postKind == "inPic"
                                ? "./assets/icons/083-eye.svg"
                                : postKind == "event"
                                    ? "./assets/icons/user.svg"
                                    : "./assets/icons/082-eyeglasses.svg",
                            height: 20.0,
                            width: 20.0,
                            color: accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection(postKind == "event"
                                  ? "interested"
                                  : postKind != "broadcasting" &&
                                          postKind != "inPic"
                                      ? "Readers"
                                      : "Views")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                height: 0.0,
                                width: 0.0,
                              );
                            }

                            return Text(
                              functionsServices
                                  .dividethousand(snapshot.data.docs.length),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[700],
                                fontFamily: "SPProtext",
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Text(
                  postKind == "lastest_news"
                      ? S.of(context).createPostLastestNewsTitle
                      : postKind == "poll"
                          ? S.of(context).pollTitle
                          : postKind == "commentary"
                              ? S.of(context).createPostCommentary
                              : postKind == "essay"
                                  ? S.of(context).createPostEssay
                                  : postKind == "research article"
                                      ? S.of(context).addPostArticle
                                      : postKind == "howTo"
                                          ? S.of(context).createHowToTitle
                                          : postKind == "personality"
                                              ? S.of(context).createProfiletitle
                                              : postKind == "analysis"
                                                  ? S
                                                      .of(context)
                                                      .createAnalysisTitle
                                                  : postKind == "investigation"
                                                      ? S
                                                          .of(context)
                                                          .createPostInvestigationTitle
                                                      : postKind == "story"
                                                          ? S
                                                              .of(context)
                                                              .createStoryTitle
                                                          : postKind ==
                                                                  "broadcasting"
                                                              ? S
                                                                  .of(context)
                                                                  .createPostBroadcastTitle
                                                              : postKind ==
                                                                      "inPic"
                                                                  ? S
                                                                      .of(
                                                                          context)
                                                                      .createPostInpicTitle
                                                                  : postKind ==
                                                                          "breaking_news"
                                                                      ? S
                                                                          .of(
                                                                              context)
                                                                          .addPostBreakingNews
                                                                      : postKind ==
                                                                              "event"
                                                                          ? S
                                                                              .of(context)
                                                                              .tagEvent
                                                                          : "",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext",
                  ),
                ),
              ],
            ),
          ),
          postKind != "personality" &&
                  postKind != "commentary" &&
                  postKind != "essay" &&
                  postKind != "inPic" &&
                  postKind != "broadcasting"
              ? Container(
                  width: w * .2,
                  child: Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: h * .07),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 5.0),
                          width: w * .2,
                          child: Text(
                            title,
                            overflow: TextOverflow.fade,
                            textDirection:
                                intl.Bidi.detectRtlDirectionality(title)
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontFamily: "Lora"),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: h * .07),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                    width: w * .2,
                    child: Text(
                      description,
                      overflow: TextOverflow.fade,
                      textDirection:
                          intl.Bidi.detectRtlDirectionality(description)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,
                          fontFamily: "Avenir"),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
