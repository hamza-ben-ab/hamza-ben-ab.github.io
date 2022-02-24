import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/bookmark/bookMark_button.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/loading_widget/lo_breaking_new.dart';
import 'package:uy/screens/loading_widget/user_loading.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/screens/posts/breaking_news.dart/bn_Cmnt_page.dart';
import 'package:uy/screens/posts/post_widgets/true_false_bar.dart';
import 'package:uy/screens/posts/post_widgets/true_false_buttonBar.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/time_ago.dart';

class BreakingNewsDetails extends StatefulWidget {
  const BreakingNewsDetails({
    Key key,
  }) : super(key: key);

  @override
  _BreakingNewsDetailsState createState() => _BreakingNewsDetailsState();
}

class _BreakingNewsDetailsState extends State<BreakingNewsDetails> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;

    return Container(
      height: h * .93,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NewsPart(),
          BreakingNewsCommentPage(),
        ],
      ),
    );
  }
}

class NewsPart extends StatefulWidget {
  const NewsPart({
    Key key,
  }) : super(key: key);

  @override
  _NewsPartState createState() => _NewsPartState();
}

class _NewsPartState extends State<NewsPart> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FunctionsServices functionsServices = FunctionsServices();
  bool isBookmark = false;

  Time timeCal = new Time();
  bool trueSelect = false;
  bool checkIsFalse = false;

  int trueCount = 0;
  int falseCount = 0;
  int totalCount = 0;
  ScrollController scrollController;
  ScrollController bnScrollController = ScrollController();
  ScrollController commentScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = context.watch<CenterBoxProvider>().docId.split("==").first;
    String doc = context.watch<CenterBoxProvider>().docId.split("==").last;
    return Container(
      width: w * .4,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(userId).collection("Pub").doc(doc).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                height: h * .91,
                width: w * .4,
                child: Center(
                  child: Text(
                    S.of(context).breakingNewsisAvailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SPProtext"),
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();

              return Directionality(
                textDirection:
                    intl.Bidi.detectRtlDirectionality(S.of(context).trueKey)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: Container(
                  width: w * .4,
                  height: h * .91,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: intl.Bidi.detectRtlDirectionality(
                                S.of(context).postViewWrittenBy)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: FutureBuilder<DocumentSnapshot>(
                            future: users.doc(userId).get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> document =
                                    snapshot.data.data();
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[400]),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  width: w * .4,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: h * .065,
                                        width: h * .065,
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
                                          height: h * .07,
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    width: w * .35,
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
                                                                      1.0),
                                                          child: Text(
                                                            S
                                                                .of(context)
                                                                .postViewWrittenBy,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[600],
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "SPProtext"),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Text(
                                                            S
                                                                .of(context)
                                                                .createPostBreakingNewsTitle,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 12.0,
                                                                fontFamily:
                                                                    "SPProtext"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: w * .34,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          height: h * .03,
                                                          child: Row(children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  Provider.of<HideLeftBarProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .closeleftBar();
                                                                  Provider.of<CenterBoxProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .changeCurrentIndex(
                                                                          7);
                                                                  Provider.of<ProfileProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .changeProfileId(
                                                                          userId);
                                                                },
                                                                child:
                                                                    HoverWidget(
                                                                        child:
                                                                            Text(
                                                                          document[
                                                                              "full_name"],
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "SPProtext"),
                                                                        ),
                                                                        hoverChild:
                                                                            Text(
                                                                          document[
                                                                              "full_name"],
                                                                          style: TextStyle(
                                                                              decoration: TextDecoration.underline,
                                                                              color: Colors.black,
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "SPProtext"),
                                                                        ),
                                                                        onHover:
                                                                            (onHover) {})),
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
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "SPProtext"),
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
                              return userLoading(h, w, .4);
                            }),
                      ),
                      Expanded(
                        child: Container(
                          width: w * .4,
                          child: SingleChildScrollView(
                            controller: bnScrollController,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: h * .02,
                                ),
                                TrueAndFalseBar(
                                  userId: userId,
                                  id: doc,
                                ),
                                data["mediaUrl"] != null
                                    ? Container(
                                        height: h * .6,
                                        width: w * .4,
                                        child: imagesFormat
                                                .contains(data["extension"])
                                            ? Container(
                                                height: h * .6,
                                                width: w * .4,
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
                                                    height: h * .6,
                                                    width: w * .4,
                                                    child: ClipRRect(
                                                      child: VideoViewChat(
                                                        videoUrl:
                                                            data["mediaUrl"],
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 10.0, right: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: h * .035,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                height: h * .06,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                child: Center(
                                                  child: Text(
                                                    "#${data["topic"]}",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontSize: 11.0,
                                                        fontFamily:
                                                            "SPProtext"),
                                                  ),
                                                ),
                                              ),
                                            ]),
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
                                              width: w * .35,
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
                                              width: w * .35,
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
                                              width: w * .35,
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
                                Container(
                                  margin: intl.Bidi.detectRtlDirectionality(
                                          data["title"])
                                      ? EdgeInsets.only(right: 15.0)
                                      : EdgeInsets.only(left: 15.0),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    border: intl.Bidi.detectRtlDirectionality(
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
                                SizedBox(
                                  height: h * .02,
                                ),
                                Container(
                                  margin: intl.Bidi.detectRtlDirectionality(
                                          data["description"])
                                      ? EdgeInsets.only(right: 10.0)
                                      : EdgeInsets.only(left: 10.0),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Directionality(
                                    textDirection:
                                        intl.Bidi.detectRtlDirectionality(
                                                data["description"])
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                    child: Text(
                                      data["description"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontFamily: "Avenir"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: h * .05,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TrueAndFalseButtonBar(
                        userId: userId,
                        id: doc,
                      ),
                    ],
                  ),
                ),
              );
            }

            return breakingNewsLoadingWidget(h, w);
          }),
    );
  }
}
