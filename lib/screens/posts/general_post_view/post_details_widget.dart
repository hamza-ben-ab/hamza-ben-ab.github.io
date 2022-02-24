import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/bookmark/bookMark_button.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/loading_widget/post_details_loading.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/screens/posts/comment/comment_page.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_details.dart';
import 'package:uy/screens/posts/post_widgets/like_dislike_bar.dart';
import 'package:uy/screens/posts/post_widgets/like_dislike_buttonBar.dart';
import 'package:uy/screens/posts/post_widgets/true_false_bar.dart';
import 'package:uy/screens/posts/post_widgets/true_false_buttonBar.dart';
import 'package:uy/services/functions.dart';

class PostDetailsWidget extends StatefulWidget {
  final String userId;
  final String doc;
  final bool views;
  const PostDetailsWidget({
    Key key,
    this.userId,
    this.doc,
    this.views,
  }) : super(key: key);

  @override
  _PostDetailsWidgetState createState() => _PostDetailsWidgetState();
}

class _PostDetailsWidgetState extends State<PostDetailsWidget> {
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
          NewsPart(userId: widget.userId, doc: widget.doc, views: widget.views),
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

class NewsPart extends StatefulWidget {
  final String userId;
  final String doc;
  final bool views;
  const NewsPart({
    Key key,
    this.userId,
    this.doc,
    this.views,
  }) : super(key: key);

  @override
  _NewsPartState createState() => _NewsPartState();
}

class _NewsPartState extends State<NewsPart> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FunctionsServices functionsServices = FunctionsServices();
  String userId;
  String doc;
  ScrollController bnScrollController = ScrollController();
  ScrollController commentScrollController = ScrollController();

  Future read(String userId, String id) async {
    await users
        .doc(userId)
        .collection("Pub")
        .doc(id)
        .collection(widget.views ? "Views" : "Readers")
        .doc(currentUser.uid)
        .set({
      "uid": currentUser.uid,
    });
  }

  @override
  void initState() {
    userId = widget.userId;
    doc = widget.doc;
    read(userId, doc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(userId).collection("Pub").doc(doc).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            String postKind = data["postKind"];

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
                        controller: bnScrollController,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            postKind == "breaking_news" ||
                                    postKind == "lastest_news" ||
                                    postKind == "personality" ||
                                    postKind == "story" ||
                                    postKind == "investigation"
                                ? TrueAndFalseBar(
                                    userId: userId,
                                    id: doc,
                                  )
                                : postKind == "inPic" ||
                                        postKind == "broadcasting"
                                    ? LikeAndDisLikeBar(
                                        views: true,
                                        userId: userId,
                                        id: doc,
                                      )
                                    : LikeAndDisLikeBar(
                                        views: false,
                                        userId: userId,
                                        id: doc,
                                      ),
                            SizedBox(
                              height: h * .02,
                            ),
                            data["mediaUrl"] != null
                                ? Container(
                                    height: h * .5,
                                    width: w * .42,
                                    child: imagesFormat
                                            .contains(data["extension"])
                                        ? Container(
                                            height: h * .5,
                                            width: w * .65,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: Image.network(
                                                          data["mediaUrl"])
                                                      .image),
                                            ),
                                          )
                                        : videoFormat
                                                .contains(data["extension"])
                                            ? Container(
                                                height: h * .5,
                                                width: w * .65,
                                                child: ClipRRect(
                                                  child: VideoViewChat(
                                                    videoUrl: data["mediaUrl"],
                                                    isFile: false,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 0.0,
                                                width: 0.0,
                                              ),
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                            SizedBox(
                              height: h * .02,
                            ),
                            Directionality(
                              textDirection: intl.Bidi.detectRtlDirectionality(
                                      S.of(context).addPostArticle)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: w * .5,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: postKind == "research article"
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                  "#${data["topic"]}",
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 14.0,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                for (int i = 0;
                                                    i < data["writers"].length;
                                                    i++)
                                                  Text(
                                                    "# ${data["writers"][i]} ",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "SPProtext"),
                                                  ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "# ${data["keywords"]}",
                                                  style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 11.0,
                                                      fontFamily: "SPProtext"),
                                                ),
                                              ])
                                        : Text(
                                            "#${data["topic"]}",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 14.0,
                                              fontFamily: "SPProtext",
                                            ),
                                          ),
                                  ),
                                  currentUser.uid != userId
                                      ? BookMarkButton(
                                          userId: userId,
                                          id: doc,
                                          read: true,
                                          postKind: data["postKind"],
                                        )
                                      : Container(
                                          height: 0.0,
                                          width: 0.0,
                                        )
                                ],
                              ),
                            ),
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
                                          width: w * .5,
                                          child: Text(
                                            data["person"],
                                            style: TextStyle(
                                                color: Colors.grey[700],
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
                                          width: w * .5,
                                          child: Text(
                                            data["event"],
                                            style: TextStyle(
                                                color: Colors.grey[700],
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
                                          width: w * .5,
                                          child: Text(
                                            data["place"],
                                            style: TextStyle(
                                                color: Colors.grey[700],
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
                            SizedBox(
                              height: h * .01,
                            ),
                            postKind != "essay" &&
                                    postKind != "commentary" &&
                                    postKind != "personality" &&
                                    postKind != "inPic" &&
                                    postKind != "broadcasting"
                                ? Align(
                                    alignment:
                                        intl.Bidi.detectRtlDirectionality(
                                                data["title"])
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: Container(
                                      margin: intl.Bidi.detectRtlDirectionality(
                                              data["title"])
                                          ? EdgeInsets.only(right: 15.0)
                                          : EdgeInsets.only(left: 15.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      decoration: BoxDecoration(
                                        border:
                                            intl.Bidi.detectRtlDirectionality(
                                                    data["title"])
                                                ? Border(
                                                    right: BorderSide(
                                                      color: Colors.black,
                                                      width: 5.0,
                                                    ),
                                                  )
                                                : Border(
                                                    left: BorderSide(
                                                      color: Colors.black,
                                                      width: 5.0,
                                                    ),
                                                  ),
                                      ),
                                      child: Directionality(
                                        textDirection:
                                            intl.Bidi.detectRtlDirectionality(
                                                    data["title"])
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                        child: Text(
                                          data["title"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0,
                                              fontFamily: "Lora"),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                            SizedBox(
                              height: h * .02,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                right: 8.0,
                              ),
                              padding: EdgeInsets.only(left: 10.0, right: 15.0),
                              child: postKind == "commentary" ||
                                      postKind == "lastest_news" ||
                                      postKind == "breaking_news" ||
                                      postKind == "essay" ||
                                      postKind == "story" ||
                                      postKind == "inPic" ||
                                      postKind == "broadcasting"
                                  ? Directionality(
                                      textDirection:
                                          intl.Bidi.detectRtlDirectionality(
                                                  data["description"])
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      child: Text(
                                        data["description"].toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontFamily: "Avenir",
                                        ),
                                      ),
                                    )
                                  : postKind == "howTo"
                                      ? Directionality(
                                          textDirection:
                                              intl.Bidi.detectRtlDirectionality(
                                            data["steps"][0]["details"],
                                          )
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                          child: howToPart(data),
                                        )
                                      : postKind == "research article"
                                          ? Directionality(
                                              textDirection: intl.Bidi
                                                      .detectRtlDirectionality(
                                                data["paragraph"][0]["details"],
                                              )
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              child: searchArticlePart(data),
                                            )
                                          : Directionality(
                                              textDirection: intl.Bidi
                                                      .detectRtlDirectionality(
                                                data["paragraph"][0]["details"],
                                              )
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              child: analysisPart(data),
                                            ),
                            ),
                            SizedBox(
                              height: h * .05,
                            ),
                            postKind == "breaking_news" ||
                                    postKind == "lastest_news" ||
                                    postKind == "personality" ||
                                    postKind == "story" ||
                                    postKind == "investigation"
                                ? TrueAndFalseButtonBar(
                                    userId: userId,
                                    id: doc,
                                  )
                                : LikeAndDislikeButtonBar(
                                    userId: userId,
                                    id: doc,
                                  ),
                            SizedBox(
                              height: h * .02,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return postDetailsLoading(h, w);
        });
  }

  Widget analysisPart(Map<String, dynamic> data) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * .6,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < data["paragraph"].toList().length; i++)
            Container(
              width: w * .6,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey[400],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: w * .6,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          data["paragraph"][i]["title"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "SPProtext"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: w * .6,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 20.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        data["paragraph"][i]["details"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontFamily: "Avenir"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget searchArticlePart(Map<String, dynamic> data) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).addPostArticle)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        width: w * .6,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              data["keywords"] != null
                  ? keyWordWidget(data["keywords"])
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
              data["correspondence"] != null
                  ? coresspondenceWidget(data["correspondence"])
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              abstractWidget(data["abstract"]),
              introWidget(data["intro"]),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          for (int i = 0; i < data["paragraph"].toList().length; i++)
            Container(
              width: w * .6,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey[400],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: w * .6,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Text(
                          data["paragraph"][i]["title"],
                          textDirection: intl.Bidi.detectRtlDirectionality(
                            data["paragraph"][i]["title"],
                          )
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "SPProtext"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: w * .6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 20.0,
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              data["paragraph"][i]["details"],
                              textDirection: intl.Bidi.detectRtlDirectionality(
                                data["paragraph"][i]["details"],
                              )
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: "Avenir"),
                            ),
                          ),
                        ),
                        data["paragraph"][i]["mediaUrl"] != null
                            ? Container(
                                height: h * .4,
                                width: h * .4,
                                child: Image.network(
                                  data["paragraph"][i]["mediaUrl"],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 10.0,
          ),
          conclusionWidget(
            data["conclusion"],
          ),
          SizedBox(
            height: h * .04,
          ),
          Divider(
            color: Colors.grey[400],
            endIndent: w * .3,
          ),
          data["references"] != null
              ? referenceWidget(
                  data["references"],
                )
              : Container(
                  height: 00.0,
                  width: 0.0,
                )
        ]),
      ),
    );
  }

  Widget howToPart(Map<String, dynamic> data) {
    double w = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).createHowToTitle)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        width: w * .6,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            suppliesWidget(data["needs"]),
            for (int i = 0; i < data["steps"].toList().length; i++)
              Container(
                width: w * .6,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey[400],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: w * .6,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        data["steps"][i]["title"],
                        textDirection: intl.Bidi.detectRtlDirectionality(
                          data["steps"][i]["title"],
                        )
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SPProtext",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    data["steps"][i]["details"] != null
                        ? Container(
                            width: w * .6,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              child: Text(
                                data["steps"][i]["details"],
                                textDirection:
                                    intl.Bidi.detectRtlDirectionality(
                                            data["steps"][i]["details"])
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: "Avenir",
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget suppliesWidget(String text) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .4,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              S.of(context).createHowToSuplliesHintText,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          Text(
            text,
            textDirection: intl.Bidi.detectRtlDirectionality(text)
                ? TextDirection.rtl
                : TextDirection.ltr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: "Avenir",
            ),
          ),
        ],
      ),
    );
  }

  Widget abstractWidget(String text) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .25,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              S.of(context).abstrack,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: "Avenir",
            ),
          ),
        ],
      ),
    );
  }

  Widget introWidget(String text) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .31,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              S.of(context).addPostArticleIntro,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: "Avenir",
            ),
          ),
        ],
      ),
    );
  }

  Widget keyWordWidget(String text) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .28,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              S.of(context).addPostArticleKeywords,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.0,
              fontFamily: "Avenir",
            ),
          ),
        ],
      ),
    );
  }

  Widget coresspondenceWidget(String text) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .28,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              S.of(context).addPostArticleCoresspondence,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.0,
              fontFamily: "Avenir",
            ),
          ),
        ],
      ),
    );
  }

  Widget conclusionWidget(String text) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .6,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              S.of(context).addPostArticleConclusion,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: "Avenir",
            ),
          ),
        ],
      ),
    );
  }

  Widget referenceWidget(String text) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .6,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              S.of(context).reference,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "SPProtext",
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: "Avenir",
            ),
          ),
        ],
      ),
    );
  }
}
