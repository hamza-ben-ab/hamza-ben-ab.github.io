import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/loading_widget/pub_search_loading.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_home.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/screens/search/search_widget.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/services/provider/search_details_provider.dart';
import 'package:uy/widget/show_video.dart';
import 'package:uy/screens/search/hover.dart';

class SearchPublicFigureKey extends StatefulWidget {
  final String title;
  final String whereField;
  final String searchItem;

  const SearchPublicFigureKey(
      {Key key, this.title, this.whereField, this.searchItem})
      : super(key: key);

  @override
  _SearchPublicFigureKeyState createState() => _SearchPublicFigureKeyState();
}

class _SearchPublicFigureKeyState extends State<SearchPublicFigureKey> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference journalists =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');
  List<QueryDocumentSnapshot> results;
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);
  FunctionsServices functionsServices = FunctionsServices();
  SearchWidgets searchWidgets = SearchWidgets();

  bool filter = false;
  int currentIndex = 0;

  InkWell searchFilterItems(int index, String title) {
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        height: h * .04,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14.0,
                  color:
                      currentIndex == index ? Colors.white : Colors.grey[500],
                  fontFamily: "SPProtext"),
            ),
            SizedBox(
              width: 5.0,
            ),
            Icon(
              LineAwesomeIcons.angle_down,
              color: currentIndex == index ? Colors.white : Colors.grey[500],
              size: 15.0,
            )
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: currentIndex == index
                    ? Colors.green[500]
                    : Colors.grey[500]),
            borderRadius: BorderRadius.circular(20.0),
            color: currentIndex == index ? Colors.green[800] : Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String searchTyping =
        Provider.of<SearchDetailsProvider>(context).searchTyping;
    return Center(
      child: StreamBuilder<QuerySnapshot>(
          stream: allPub.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  margin: EdgeInsets.only(top: h * .01),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white),
                          child: pubSearchLoading(h, w),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            results = snapshot.data.docs;

            results.retainWhere(
              (DocumentSnapshot doc) => doc
                  .data()[widget.whereField]
                  .toString()
                  .toLowerCase()
                  .contains(
                    searchTyping.toLowerCase(),
                  ),
            );

            return Container(
              width: w * .45,
              child: Column(
                children: [
                  results.isEmpty
                      ? Container(
                          height: 0.0,
                          width: 0.0,
                        )
                      : Directionality(
                          textDirection: intl.Bidi.detectRtlDirectionality(
                                  S.of(context).result)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${widget.title}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SPProtext"),
                                ),
                                Text(
                                  "${functionsServices.dividethousand(results.length)} ${S.of(context).result}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: "SPProtext"),
                                )
                              ],
                            ),
                          ),
                        ),
                  Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: true,
                    radius: Radius.circular(20.0),
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: results.length > 3 ? 3 : results.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot user = results[index];
                        return Center(
                          child: SearchPubItem(
                            whereField: widget.whereField,
                            userId: user.id.toString().split("==").first,
                            id: user.id.toString().split("==").last,
                            searchType: searchTyping,
                          ),
                        );
                      },
                    ),
                  ),
                  results.length > 3
                      ? InkWell(
                          onTap: () {
                            Provider.of<SearchDetailsProvider>(context,
                                    listen: false)
                                .changeIndex(widget.whereField == "person"
                                    ? 3
                                    : widget.whereField == "event"
                                        ? 4
                                        : 5);
                          },
                          child: HoverWidget(
                            child: searchWidgets.seeMoreWidget(
                                false, h, w, S.of(context).seeAllpub),
                            hoverChild: searchWidgets.seeMoreWidget(
                                true, h, w, S.of(context).seeAllpub),
                            onHover: (onHover) {},
                          ),
                        )
                      : Container(
                          height: 0.0,
                          width: 0.0,
                        ),
                ],
              ),
            );
          }),
    );
  }
}

class SearchPubItem extends StatefulWidget {
  final String userId;
  final String id;
  final String searchType;
  final String whereField;
  const SearchPubItem(
      {Key key, this.userId, this.id, this.searchType, this.whereField})
      : super(key: key);

  @override
  _SearchPubItemState createState() => _SearchPubItemState();
}

class _SearchPubItemState extends State<SearchPubItem> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String postKind;
  FunctionsServices functionsServices = FunctionsServices();
  PostFunctions postAllFunctions = PostFunctions();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.userId).collection("Pub").doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> pubData = snapshot.data.data();
            final String postKind = pubData["postKind"];

            return Container(
              height: h * .35,
              width: w * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey[400],
                ),
              ),
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                children: [
                  AheadPostHome(
                    userId: widget.userId,
                    data: pubData,
                  ),
                  Directionality(
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).famousPersonIdentified)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        width: w * .4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            pubData["mediaUrl"] != null
                                ? Container(
                                    width: w * .13,
                                    height: h * .2,
                                    child: Center(
                                      child: Container(
                                        child: imagesFormat
                                                .contains(pubData["extension"])
                                            ? Stack(children: [
                                                Container(
                                                  height: h * .2,
                                                  width: w * .15,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
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
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      height: h * .2,
                                                      width: w * .15,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
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
                                    width: w * .13,
                                    height: h * .2,
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
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: [
                                    postKind != "personality" &&
                                            postKind != "commentary" &&
                                            postKind != "essay" &&
                                            postKind != "inPic" &&
                                            postKind != "broadcasting"
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
                                                  ? EdgeInsets.only(right: 5.0)
                                                  : EdgeInsets.only(left: 5.0),
                                              decoration: BoxDecoration(
                                                border: intl.Bidi
                                                        .detectRtlDirectionality(
                                                            pubData["title"])
                                                    ? Border(
                                                        right: BorderSide(
                                                          color: Colors.black,
                                                          width: 1.0,
                                                        ),
                                                      )
                                                    : Border(
                                                        left: BorderSide(
                                                          color: Colors.black,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                              ),
                                              child: Directionality(
                                                textDirection: intl.Bidi
                                                        .detectRtlDirectionality(
                                                            pubData["title"])
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                child: Text(
                                                  pubData["title"],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.0,
                                                    fontFamily: "Lora",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: h * .15,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5.0,
                                                  bottom: 5.0),
                                              width: w * .25,
                                              child: Text(
                                                pubData["description"],
                                                overflow: TextOverflow.fade,
                                                textDirection: intl.Bidi
                                                        .detectRtlDirectionality(
                                                            pubData[
                                                                "description"])
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10.0,
                                                    fontFamily: "Avenir"),
                                              ),
                                            ),
                                          ),
                                    widget.whereField == "person" &&
                                            pubData["person"] != null
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  LineAwesomeIcons.user_tag,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Container(
                                                  width: w * .21,
                                                  child:
                                                      DynamicTextHighlighting(
                                                    text: pubData["person"],
                                                    highlights: [
                                                      widget.searchType
                                                    ],
                                                    caseSensitive: false,
                                                    color: Colors.green[300],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontFamily:
                                                            "SPProtext"),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : widget.whereField == "event" &&
                                                pubData["event"] != null
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      LineAwesomeIcons
                                                          .calendar_check,
                                                      color: Colors.grey[700],
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Container(
                                                      width: w * .21,
                                                      child:
                                                          DynamicTextHighlighting(
                                                        text: pubData["event"],
                                                        highlights: [
                                                          widget.searchType
                                                        ],
                                                        caseSensitive: false,
                                                        color:
                                                            Colors.green[300],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.0,
                                                            fontFamily:
                                                                "SPProtext"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : widget.whereField == "place" &&
                                                    pubData["place"] != null
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.0,
                                                            horizontal: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Container(
                                                          width: w * .21,
                                                          child:
                                                              DynamicTextHighlighting(
                                                            text: pubData[
                                                                "place"],
                                                            highlights: [
                                                              widget.searchType
                                                            ],
                                                            caseSensitive:
                                                                false,
                                                            color: Colors
                                                                .green[300],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.0,
                                                                fontFamily:
                                                                    "SPProtext"),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    height: 0.0,
                                                    width: 0.0,
                                                  ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        postKind == "broadcasting" ||
                                postKind == "inPic" ||
                                postKind == "commentary" ||
                                postKind == "essay" ||
                                postKind == "howTo" ||
                                postKind == "analysis"
                            ? Container(
                                height: h * .04,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: h * .05,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "./assets/icons/195-like.svg",
                                            color: Colors.grey[800],
                                            height: 20.0,
                                            width: 20.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: users
                                                  .doc(widget.userId)
                                                  .collection("Pub")
                                                  .doc(widget.id)
                                                  .collection("Like")
                                                  .where("likeOrDislike",
                                                      isEqualTo: "true")
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
                                                      .dividethousand(snapshot
                                                          .data.docs.length),
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[500],
                                                    fontFamily: "SPProtext",
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      height: h * .05,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "./assets/icons/194-dislike.svg",
                                            color: Colors.grey[800],
                                            height: 20.0,
                                            width: 20.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: users
                                                  .doc(widget.userId)
                                                  .collection("Pub")
                                                  .doc(widget.id)
                                                  .collection("Like")
                                                  .where("likeOrDislike",
                                                      isEqualTo: "false")
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
                                                      .dividethousand(snapshot
                                                          .data.docs.length),
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[500],
                                                    fontFamily: "SPProtext",
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      height: h * .05,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "./assets/icons/chat_1.svg",
                                            color: Colors.grey[800],
                                            height: 20.0,
                                            width: 20.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: users
                                                  .doc(widget.userId)
                                                  .collection("Pub")
                                                  .doc(widget.id)
                                                  .collection("Comments")
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
                                                      .dividethousand(snapshot
                                                          .data.docs.length),
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[500],
                                                    fontFamily: "SPProtext",
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: h * .05,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "./assets/icons/082-eyeglasses.svg",
                                            color: Colors.grey[800],
                                            height: 20.0,
                                            width: 20.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: users
                                                  .doc(widget.userId)
                                                  .collection("Pub")
                                                  .doc(widget.id)
                                                  .collection("Readers")
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
                                                      .dividethousand(snapshot
                                                          .data.docs.length),
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[500],
                                                    fontFamily: "SPProtext",
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: h * .05,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "./assets/icons/alert.svg",
                                            color: Colors.grey[800],
                                            height: 20.0,
                                            width: 20.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: users
                                                  .doc(widget.userId)
                                                  .collection("Pub")
                                                  .doc(widget.id)
                                                  .collection("Report")
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
                                                      .dividethousand(snapshot
                                                          .data.docs.length),
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[500],
                                                    fontFamily: "SPProtext",
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : postKind == "breaking_news" ||
                                    postKind == "lastest_news" ||
                                    postKind == "personality" ||
                                    postKind == "story" ||
                                    postKind == "investigation"
                                ? Container(
                                    height: h * .04,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: h * .05,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "./assets/icons/036-check.svg",
                                                color: Colors.green,
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: users
                                                      .doc(widget.userId)
                                                      .collection("Pub")
                                                      .doc(widget.id)
                                                      .collection("TrueOrFalse")
                                                      .where("trueOrfalse",
                                                          isEqualTo: "true")
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
                                                          .dividethousand(
                                                              snapshot.data.docs
                                                                  .length),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[500],
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          height: h * .05,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "./assets/icons/068-cancel.svg",
                                                color: Colors.green,
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: users
                                                      .doc(widget.userId)
                                                      .collection("Pub")
                                                      .doc(widget.id)
                                                      .collection("TrueOrFalse")
                                                      .where("trueOrfalse",
                                                          isEqualTo: "false")
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
                                                          .dividethousand(
                                                              snapshot.data.docs
                                                                  .length),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[500],
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          height: h * .05,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "./assets/icons/chat_1.svg",
                                                color: Colors.grey[800],
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: users
                                                      .doc(widget.userId)
                                                      .collection("Pub")
                                                      .doc(widget.id)
                                                      .collection("Comments")
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
                                                          .dividethousand(
                                                              snapshot.data.docs
                                                                  .length),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[500],
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: h * .05,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "./assets/icons/082-eyeglasses.svg",
                                                color: Colors.grey[800],
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: users
                                                      .doc(widget.userId)
                                                      .collection("Pub")
                                                      .doc(widget.id)
                                                      .collection("Readers")
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
                                                          .dividethousand(
                                                              snapshot.data.docs
                                                                  .length),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[500],
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: h * .05,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "./assets/icons/alert.svg",
                                                color: Colors.grey[800],
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: users
                                                      .doc(widget.userId)
                                                      .collection("Pub")
                                                      .doc(widget.id)
                                                      .collection("Report")
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
                                                          .dividethousand(
                                                              snapshot.data.docs
                                                                  .length),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[500],
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                        InkWell(
                          onTap: () {
                            Provider.of<ReadPostProvider>(context,
                                    listen: false)
                                .changePostId(widget.userId, widget.id);
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
                          child: postAllFunctions
                              .readButtonWidget(
                                h,
                                w,
                                S.of(context).read,
                              )
                              .xShowPointerOnHover,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return pubSearchLoading(h, w);
        });
  }
}

class SearchPublicFigureKeyExtent extends StatefulWidget {
  final String title;
  final String whereField;
  final bool extent;
  final String searchItem;

  const SearchPublicFigureKeyExtent(
      {Key key, this.title, this.whereField, this.extent, this.searchItem})
      : super(key: key);

  @override
  _SearchPublicFigureKeyExtentState createState() =>
      _SearchPublicFigureKeyExtentState();
}

class _SearchPublicFigureKeyExtentState
    extends State<SearchPublicFigureKeyExtent> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference journalists =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');
  List<QueryDocumentSnapshot> results;
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);
  FunctionsServices functionsServices = FunctionsServices();
  SearchWidgets searchWidgets = SearchWidgets();
  AlertWidgets alertWidgets = AlertWidgets();

  bool filter = false;
  int currentIndex = 0;

  InkWell searchFilterItems(int index, String title) {
    double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        height: h * .04,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14.0,
                  color:
                      currentIndex == index ? Colors.white : Colors.grey[500],
                  fontFamily: "SPProtext"),
            ),
            SizedBox(
              width: 5.0,
            ),
            Icon(
              LineAwesomeIcons.angle_down,
              color: currentIndex == index ? Colors.white : Colors.grey[500],
              size: 15.0,
            )
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: currentIndex == index
                    ? Colors.green[500]
                    : Colors.grey[500]),
            borderRadius: BorderRadius.circular(20.0),
            color: currentIndex == index ? Colors.green[800] : Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String searchTyping =
        Provider.of<SearchDetailsProvider>(context).searchTyping;
    return Center(
      child: Container(
        width: w * .63,
        margin: EdgeInsets.only(left: 10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: allPub.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.only(top: h * .05),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white),
                          child: pubSearchLoading(h, w),
                        ),
                      );
                    },
                  ),
                );
              }
              results = snapshot.data.docs;

              results.retainWhere(
                (DocumentSnapshot doc) => doc
                    .data()[widget.whereField]
                    .toString()
                    .toLowerCase()
                    .contains(
                      searchTyping.toLowerCase(),
                    ),
              );

              if (snapshot.hasError) {
                return alertWidgets.errorWidget(
                    h, w, S.of(context).noContentAvailable);
              }

              if (results.isEmpty) {
                return alertWidgets.emptyWidget(
                    h, w, S.of(context).noPubmatching);
              }

              return Container(
                width: w * .63,
                child: Column(
                  children: [
                    Directionality(
                      textDirection: intl.Bidi.detectRtlDirectionality(
                              S.of(context).famousPersonIdentified)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "${functionsServices.dividethousand(results.length)} ${S.of(context).result}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: "SPProtext",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        isAlwaysShown: true,
                        radius: Radius.circular(20.0),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: results.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            QueryDocumentSnapshot user = results[index];
                            return Center(
                              child: SearchPubItem(
                                whereField: widget.whereField,
                                userId: user.id.toString().split("==").first,
                                id: user.id.toString().split("==").last,
                                searchType: searchTyping,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
