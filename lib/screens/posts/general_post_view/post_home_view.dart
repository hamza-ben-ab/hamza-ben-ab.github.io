import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/bookmark/bookMark_button.dart';
import 'package:uy/screens/loading_widget/postHome_loading.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_home.dart';
import 'package:uy/screens/posts/post_widgets/like_dislike_bar.dart';
import 'package:uy/screens/posts/post_widgets/true_false_bar.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/posts/post_widgets/invite_someOne.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';

class PostHomeView extends StatefulWidget {
  final String userId;
  final String id;

  const PostHomeView({Key key, this.userId, this.id}) : super(key: key);
  @override
  _PostHomeViewState createState() => _PostHomeViewState();
}

class _PostHomeViewState extends State<PostHomeView> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String userId;
  String id;
  FunctionsServices functionsServices = FunctionsServices();
  PostFunctions postAllFunctions = PostFunctions();

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

  void inviteToRead(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                height: h * .5,
                width: w * .4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: InviteSomeOne(
                  userId: userId,
                  id: id,
                )),
          );
        });
  }

  @override
  void initState() {
    userId = widget.userId;
    id = widget.id;
    //isClose();
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
          future: users.doc(userId).collection("Pub").doc(id).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data.data();
              final String postKind = data["postKind"];
              return Container(
                width: w * .4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: closeNews ? Colors.red : Colors.white,
                  ),
                ),
                child: Column(
                  children: [
                    AheadPostHome(
                      data: data,
                      userId: userId,
                    ),
                    (postKind == "commentary" ||
                            postKind == "essay" ||
                            postKind == "howTo" ||
                            postKind == "analysis" ||
                            postKind == "inPic" ||
                            postKind == "broadcasting")
                        ? LikeAndDisLikeBar(
                            userId: userId,
                            id: id,
                            views: postKind == "inPic" ||
                                    postKind == "broadcasting"
                                ? true
                                : false,
                          )
                        : postKind == "breaking_news" ||
                                postKind == "lastest_news" ||
                                postKind == "personality" ||
                                postKind == "story" ||
                                postKind == "investigation"
                            ? TrueAndFalseBar(userId: userId, id: id)
                            : Container(),
                    //mediaBox
                    data["mediaUrl"] != null
                        ? Stack(
                            children: [
                              Container(
                                height: h * .4,
                                width: w * .4,
                                child: imagesFormat.contains(data["extension"])
                                    ? Container(
                                        height: h * .4,
                                        width: w * .4,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.network(
                                                      data["mediaUrl"])
                                                  .image),
                                        ),
                                      )
                                    : videoFormat.contains(data["extension"])
                                        ? Container(
                                            height: h * .4,
                                            width: w * .4,
                                            child: ClipRRect(
                                              child: VideoViewChat(
                                                videoUrl: data["mediaUrl"],
                                                isFile: false,
                                                auto: false,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 0.0,
                                            width: 0.0,
                                          ),
                              ),
                              closeNews
                                  ? Container(
                                      height: h * .4,
                                      width: w * .4,
                                      color: Colors.grey[200].withOpacity(0.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "./assets/icons/cross.svg",
                                            color: Colors.red,
                                            height: 70.0,
                                            width: 70.0,
                                          ),
                                          SizedBox(
                                            width: w * .05,
                                          ),
                                          Text(
                                            "This publication is maybe fake.\n So, it will be deleted from Telltrue",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontFamily: "SPProtext",
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    )
                            ],
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),
                    //bookMark

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 10.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (postKind != "personality" && postKind != "event")
                              ? Container(
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
                                                BorderRadius.circular(12.0),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Center(
                                            child: Text(
                                              "#${data["topic"]}",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 11.0,
                                                  fontFamily: "SPProtext"),
                                            ),
                                          ),
                                        ),
                                      ]),
                                )
                              : Container(
                                  height: 0.0,
                                  width: 0.0,
                                ),
                          closeNews
                              ? Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                              : userId != currentUser.uid
                                  ? BookMarkButton(
                                      postKind: data["postKind"],
                                      read: postKind != "inPic" ||
                                              postKind != "broadcasting"
                                          ? false
                                          : true,
                                      userId: userId,
                                      id: id,
                                    )
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: h * .01,
                    ),
                    data["feel"] != null && data["smile"] != null
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: h * .035,
                                  width: h * .035,
                                  child: Center(
                                    child: CircleAvatar(
                                        radius: 20.0,
                                        child: Image.network(
                                            "./assets/images/feeling/${data["smile"]}.png")),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Container(
                                  width: w * .35,
                                  child: Text(
                                    data["feel"],
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
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

                    postKind != "personality" &&
                            postKind != "commentary" &&
                            postKind != "essay" &&
                            postKind != "inPic" &&
                            postKind != "broadcasting"
                        ? Container(
                            width: w * .4,
                            child: Row(
                              children: [
                                Container(
                                  width: w * .39,
                                  margin: intl.Bidi.detectRtlDirectionality(
                                          data["title"])
                                      ? EdgeInsets.only(right: 10.0)
                                      : EdgeInsets.only(left: 10.0),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    border: intl.Bidi.detectRtlDirectionality(
                                            data["title"])
                                        ? Border(
                                            right: BorderSide(
                                              color: Colors.black,
                                              width: 3.0,
                                            ),
                                          )
                                        : Border(
                                            left: BorderSide(
                                              color: Colors.black,
                                              width: 3.0,
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
                                          fontSize: 20.0,
                                          fontFamily: "Lora"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),

                    (postKind != "personality" &&
                            postKind != "howTo" &&
                            postKind != "research article")
                        ? Container(
                            child: Column(
                              children: [
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
                                                    color: Colors.brown,
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
                                                    color: Colors.brown,
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
                                                    color: Colors.brown,
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

                    postKind == "commentary" ||
                            postKind == "lastest_news" ||
                            postKind == "breaking_news" ||
                            postKind == "essay" ||
                            postKind == "story" ||
                            postKind == "analysis" ||
                            postKind == "investigation" ||
                            postKind == "research article" ||
                            postKind == "howTo" ||
                            postKind == "inPic" ||
                            postKind == "broadcasting"
                        ? Container(
                            child: Column(
                              children: [
                                postKind == "commentary" ||
                                        postKind == "lastest_news" ||
                                        postKind == "breaking_news" ||
                                        postKind == "essay" ||
                                        postKind == "story" ||
                                        postKind == "inPic" ||
                                        postKind == "broadcasting"
                                    ? ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxHeight: h * .1),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          width: w * .45,
                                          child: Text(
                                            data["description"],
                                            overflow: TextOverflow.fade,
                                            textDirection: intl.Bidi
                                                    .detectRtlDirectionality(
                                                        data["description"])
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                                fontFamily: "Avenir"),
                                          ),
                                        ),
                                      )
                                    : postKind == "howTo"
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxHeight: h * .1),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0),
                                              width: w * .45,
                                              child: Text(
                                                data["steps"][0]["details"],
                                                overflow: TextOverflow.fade,
                                                textDirection: intl.Bidi
                                                        .detectRtlDirectionality(
                                                            data["steps"][0]
                                                                ["details"])
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontFamily: "Avenir"),
                                              ),
                                            ),
                                          )
                                        : ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxHeight: h * .1),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 5.0),
                                              width: w * .45,
                                              child: Text(
                                                data["paragraph"][0]["details"],
                                                overflow: TextOverflow.fade,
                                                textDirection: intl.Bidi
                                                        .detectRtlDirectionality(
                                                            data["paragraph"][0]
                                                                ["details"])
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontFamily: "Avenir"),
                                              ),
                                            ),
                                          ),
                                closeNews
                                    ? Container(
                                        height: h * .05,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  S.of(context).trueKey,
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "SPProtext"),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                StreamBuilder<QuerySnapshot>(
                                                    stream: users
                                                        .doc(widget.userId)
                                                        .collection("Pub")
                                                        .doc(widget.id)
                                                        .collection(
                                                            "TrueOrFalse")
                                                        .where("trueOrfalse",
                                                            isEqualTo: "true")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Container(
                                                          height: 0.0,
                                                          width: 0.0,
                                                        );
                                                      }

                                                      return Text(
                                                        functionsServices
                                                            .dividethousand(
                                                                snapshot
                                                                    .data
                                                                    .docs
                                                                    .length),
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.green,
                                                          fontFamily:
                                                              "SPProtext",
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "SPProtext"),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                StreamBuilder<QuerySnapshot>(
                                                    stream: users
                                                        .doc(widget.userId)
                                                        .collection("Pub")
                                                        .doc(widget.id)
                                                        .collection(
                                                            "TrueOrFalse")
                                                        .where("trueOrfalse",
                                                            isEqualTo: "false")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Container(
                                                          height: 0.0,
                                                          width: 0.0,
                                                        );
                                                      }

                                                      return Text(
                                                        functionsServices
                                                            .dividethousand(
                                                                snapshot
                                                                    .data
                                                                    .docs
                                                                    .length),
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red,
                                                          fontFamily:
                                                              "SPProtext",
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: h * .05,
                                        width: w * .45,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Row(
                                          children: [
                                            Directionality(
                                              textDirection: intl.Bidi
                                                      .detectRtlDirectionality(S
                                                          .of(context)
                                                          .postViewWrittenBy)
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              child: InkWell(
                                                onTap: () {
                                                  Provider.of<ReadPostProvider>(
                                                          context,
                                                          listen: false)
                                                      .changePostId(userId, id);
                                                  showDialog(
                                                    context: (context),
                                                    builder: (context) {
                                                      return ShowPostDetails(
                                                        id: widget.id,
                                                        postKind: postKind,
                                                        views: postKind ==
                                                                    "inPic" ||
                                                                postKind ==
                                                                    "broadcasting"
                                                            ? true
                                                            : false,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: postKind == "inPic" ||
                                                        postKind ==
                                                            "broadcasting"
                                                    ? postAllFunctions
                                                        .watchButtonWidget(h, w,
                                                            S.of(context).watch)
                                                    : postAllFunctions
                                                        .readButtonWidget(
                                                          h,
                                                          w,
                                                          S.of(context).read,
                                                        )
                                                        .xShowPointerOnHover,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),
                  ],
                ),
              );
            }
            return loadingHomePost(h, w);
          }),
    );
  }
}

Widget buildIndicatorPage(bool iscurrentPage) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 350),
    height: iscurrentPage ? 10 : 7,
    width: iscurrentPage ? 10 : 7,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: iscurrentPage
          ? Color.alphaBlend(Color(0xFF6463AF), Color(0xFFF78361))
          : Color(0xFFDEE4E7),
    ),
  );
}
