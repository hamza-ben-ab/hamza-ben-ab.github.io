import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/breaking_card_loading.dart';
import 'package:uy/screens/loading_widget/user_loading.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/provider/right_bar_provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/widget/live_animation.dart';

class BreakingNewsList extends StatefulWidget {
  const BreakingNewsList({Key key}) : super(key: key);

  @override
  _BreakingNewsListState createState() => _BreakingNewsListState();
}

class _BreakingNewsListState extends State<BreakingNewsList> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  ScrollController breakingNewsController = ScrollController();
  AlertWidgets alertWidgets = AlertWidgets();
  int newPostCount = 0;
  bool seen = false;
  FunctionsServices functionsServices = FunctionsServices();
  bool closeNews = false;

  /*isClose() async {
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
  }*/

  Widget breakingNewsWidget(
    bool hover,
    int cardIndex,
    String userId,
    String id,
  ) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        Provider.of<HideLeftBarProvider>(context, listen: false).closeleftBar();
        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeCurrentIndex(6);
        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeDocId("$userId==$id");

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

        await users
            .doc(currentUser.uid)
            .collection("Breaking News")
            .doc("$userId==$id")
            .update({"seen": true});

        Provider.of<RightBarProvider>(context, listen: false)
            .changeCardIndex(cardIndex);
      },
      child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(userId).collection("Pub").doc(id).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data.data();

              return Container(
                margin: EdgeInsets.only(
                  top: 5.0,
                  left: 5.0,
                  right: 17.0,
                  bottom: 5.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[400],
                  ),
                  color: hover ? Colors.grey[100] : Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                width: w * .22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    bottom: BorderSide(color: Colors.grey[400]),
                                  ),
                                ),
                                padding: const EdgeInsets.all(5.0),
                                width: w * .22,
                                child: Row(
                                  children: [
                                    Container(
                                      height: h * .065,
                                      width: h * .065,
                                      decoration: BoxDecoration(
                                        borderRadius: intl.Bidi
                                                .detectRtlDirectionality(S
                                                    .of(context)
                                                    .postViewWrittenBy)
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                                bottomLeft:
                                                    Radius.circular(15.0),
                                              )
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                                bottomRight:
                                                    Radius.circular(15.0),
                                              ),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                Image.network(document["image"])
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
                                                  MainAxisAlignment.center,
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
                                                              .changeCurrentIndex(
                                                                  7);
                                                          Provider.of<ProfileProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .changeProfileId(
                                                                  userId);
                                                        },
                                                        child: HoverWidget(
                                                            child: Text(
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
                                                            hoverChild: Text(
                                                              document[
                                                                  "full_name"],
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
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
                                                  ]),
                                                ),
                                                Text(
                                                  "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(data["timeAgo"].toDate()).toString()} - ${intl.DateFormat.Hm().format(data["timeAgo"].toDate()).toString()} ",
                                                  style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "SPProtext"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    /* !seen
                                        ? Align(
                                            alignment: intl.Bidi
                                                    .detectRtlDirectionality(
                                              S.of(context).addPostBreakingNews,
                                            )
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0,
                                              ),
                                              child: Container(
                                                height: h * .015,
                                                width: h * .015,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.purple),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 0.0,
                                            width: 0.0,
                                          )*/
                                  ],
                                ),
                              );
                            }
                            return userBreakingNewsLoading(
                              h,
                              w,
                            );
                          }),
                    ),
                    Container(
                      width: w * .22,
                      padding: EdgeInsets.all(10.0),
                      child: Align(
                        alignment:
                            intl.Bidi.detectRtlDirectionality(data["title"])
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          width: w * .2,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 5.0,
                          ),
                          child: Directionality(
                            textDirection:
                                intl.Bidi.detectRtlDirectionality(data["title"])
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            child: Text(
                              data["title"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: "Lora",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return loadingBreakingNews(h, w);
          }),
    );
  }

  Widget breakingNewsCloseWidget(
      int cardIndex, String userId, String id, Map<String, dynamic> data) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // int currentCardIndex = context.watch<RightBarProvider>().cardIndex;

    return Stack(children: [
      Container(
        margin: EdgeInsets.only(
          top: 5.0,
          left: 5.0,
          right: 17.0,
          bottom: 5.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        width: w * .22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      Map<String, dynamic> document = snapshot.data.data();
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[400]),
                          ),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        width: w * .22,
                        child: Row(
                          children: [
                            Container(
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
                                    image:
                                        Image.network(document["image"]).image),
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
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: h * .03,
                                          child: Row(children: [
                                            Text(
                                              document["full_name"],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext",
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
                                          "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(data["timeAgo"].toDate()).toString()} - ${intl.DateFormat.Hm().format(data["timeAgo"].toDate()).toString()} ",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SPProtext"),
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
                    return userBreakingNewsLoading(
                      h,
                      w,
                    );
                  }),
            ),
            Container(
              width: w * .22,
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: intl.Bidi.detectRtlDirectionality(data["title"])
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: w * .2,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  child: Directionality(
                    textDirection:
                        intl.Bidi.detectRtlDirectionality(data["title"])
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    child: Text(
                      data["title"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: "Lora",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: h * .045,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).trueKey,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SPProtext"),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("TrueOrFalse")
                              .where("trueOrfalse", isEqualTo: "true")
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
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontFamily: "SPProtext",
                              ),
                            );
                          }),
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).falseKey,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SPProtext"),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(userId)
                              .collection("Pub")
                              .doc(id)
                              .collection("TrueOrFalse")
                              .where("trueOrfalse", isEqualTo: "false")
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
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                                fontFamily: "SPProtext",
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Positioned(
        top: h * .08,
        left: w * .03,
        child: SvgPicture.asset(
          "./assets/icons/cross.svg",
          color: Colors.red,
          height: 50.0,
          width: 50.0,
        ),
      )
    ]);
  }

  void checkBnExist() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .collection("Breaking News");

    QuerySnapshot querySnapshot = await _collectionRef.get();

    querySnapshot.docs.forEach((element) {
      if (element.data()["timeAgo"].toDate().millisecondsSinceEpoch +
              (24 * 60 * 60 * 1000) <=
          DateTime.now().millisecondsSinceEpoch) {
        users
            .doc(currentUser.uid)
            .collection("Breaking News")
            .doc(element.id)
            .delete();
      }
    });
  }

  @override
  void initState() {
    checkBnExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * .24,
      child: Column(
        children: [
          Container(
            height: h * .05,
            padding: EdgeInsets.only(top: 10.0, left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LiveAnimation(
                  text: true,
                  textWidth: .2,
                  width: .22,
                  icon: true,
                  begin: Colors.white,
                  end: Colors.red[800],
                  title: S.of(context).createPostBreakingNewsTitle,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: w * .24,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(currentUser.uid)
                          .collection("Breaking News")
                          .orderBy("timeAgo", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: w * .24,
                            child: ListView.builder(
                              itemCount: 4,
                              itemBuilder: (_, context) {
                                return loadingBreakingNews(h, w);
                              },
                            ),
                          );
                        }

                        if (snapshot.data.docs.isEmpty) {
                          return alertWidgets.emptyBreakingNews(
                              h,
                              w,
                              S.of(context).nobreakingNewsyet,
                              S.of(context).noBreakingNewsDes);
                        }

                        return Scrollbar(
                          controller: breakingNewsController,
                          isAlwaysShown: true,
                          radius: Radius.circular(20.0),
                          child: AnimationLimiter(
                            child: ListView.builder(
                              controller: breakingNewsController,
                              itemCount: snapshot.data.docs.length,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final String id = snapshot.data.docs[index].id
                                    .toString()
                                    .split("==")
                                    .last;
                                final String user = snapshot.data.docs[index].id
                                    .toString()
                                    .split("==")
                                    .first;

                                //final bool seen =snapshot.data.docs[index]["seen"];

                                //final Timestamp time =snapshot.data.docs[index]["timeAgo"];

                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(seconds: 2),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: SlideAnimation(
                                      child: HoverWidget(
                                              child: breakingNewsWidget(
                                                  false, index, user, id),
                                              hoverChild: breakingNewsWidget(
                                                  true, index, user, id),
                                              onHover: (onHover) {})
                                          .xShowPointerOnHover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
