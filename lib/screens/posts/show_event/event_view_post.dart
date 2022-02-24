import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/bookmark/bookMark_button.dart';
import 'package:uy/screens/loading_widget/post_details_loading.dart';
import 'package:uy/screens/loading_widget/user_loading.dart';
import 'package:uy/screens/posts/post_widgets/invite_someOne.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:intl/intl.dart' as intl;

class EventViewPost extends StatefulWidget {
  final String userId;
  final String id;

  const EventViewPost({Key key, this.userId, this.id}) : super(key: key);
  @override
  _EventViewPostState createState() => _EventViewPostState();
}

class _EventViewPostState extends State<EventViewPost> {
  String userId;
  String id;
  Time timeCal = new Time();
  bool interested = false;
  bool isDone = false;
  User currentUser = FirebaseAuth.instance.currentUser;
  ScrollController scrollController = ScrollController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> interestedExist() async {
    DocumentSnapshot user = await users
        .doc(widget.userId)
        .collection("Pub")
        .doc(widget.id)
        .collection("interested")
        .doc(currentUser.uid)
        .get();

    if (user.exists) {
      interested = true;
    } else {
      interested = false;
    }
  }

  @override
  void initState() {
    userId = widget.userId;
    id = widget.id;
    interestedExist();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    interestedExist();
  }

  Widget interestButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .055,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          SvgPicture.asset(
            "./assets/icons/star.svg",
            color: Colors.grey[800],
            height: 20.0,
            width: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          !interested
              ? Text(
                  S.of(context).eventInterestedButton,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SPProtext"),
                )
              : interested
                  ? Text(
                      S.of(context).eventNotInterestedButton,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SPProtext",
                      ),
                    )
                  : Center(
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: !interested
            ? Colors.grey[50]
            : hover && !interested
                ? Colors.grey[400]
                : Colors.cyan[600],
      ),
    );
  }

  inviteToReadFunction(BuildContext context, String userId, String doc) {
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
              height: h * .7,
              width: w * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: InviteSomeOne(
                userId: userId,
                id: doc,
              ),
            ),
          );
        });
  }

  Widget inviteToRead(double h, double w, String title) {
    return InkWell(
      onTap: () {
        inviteToReadFunction(context, userId, id);
      },
      child: HoverWidget(
        child: inviteToReadWidget(false, h, w, title),
        hoverChild: inviteToReadWidget(true, h, w, title),
        onHover: (onHover) {},
      ),
    );
  }

  Widget inviteToReadWidget(bool hover, double h, double w, String title) {
    return Container(
      height: h * .055,
      width: w * .08,
      margin: EdgeInsets.only(bottom: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "./assets/icons/175-share.svg",
            color: Colors.grey[800],
            height: 22.0,
            width: 22.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
                fontFamily: "SPProtext"),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[300] : Colors.grey[50]),
    );
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

              return Container(
                width: w * .45,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(children: [
                  FutureBuilder<DocumentSnapshot>(
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
                            width: w * .4,
                            child: Row(
                              children: [
                                Container(
                                  height: h * .05,
                                  width: h * .05,
                                  decoration: BoxDecoration(
                                    borderRadius: intl.Bidi
                                            .detectRtlDirectionality(
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
                                        image: Image.network(document["image"])
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1.0),
                                              child: Text(
                                                S.of(context).addEventTitle,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "SPProtext"),
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
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        "  ${S.of(context).postViewUpdate} | ${intl.DateFormat.yMMMMd().format(data["timeAgo"].toDate()).toString()} - ${intl.DateFormat.Hm().format(data["timeAgo"].toDate()).toString()} ",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: Colors
                                                                .grey[500],
                                                            fontWeight:
                                                                FontWeight.w500,
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
                        return userLoading(h, w, .45);
                      }),
                  Stack(
                    children: [
                      Container(
                        height: h * .4,
                        width: w * .45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(data["mediaUrl"]).image,
                          ),
                        ),
                      ),
                      Container(
                        height: h * .4,
                        width: w * .45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.grey, Colors.transparent],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: w * .45,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              child: Text(
                                data["place"],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: "SPProtext",
                                ),
                              ),
                            ),
                            Container(
                              width: w * .45,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              child: Text(
                                data["title"],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "SPProtext",
                                ),
                              ),
                            ),
                            Container(
                              width: w * .45,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: users
                                      .doc(userId)
                                      .collection("Pub")
                                      .doc(id)
                                      .collection("interested")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        "${snapshot.data.docs.length}  ${S.of(context).participants}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontFamily: "SPProtext",
                                        ),
                                      );
                                    }
                                    return Container(
                                      height: 0.0,
                                      width: 0.0,
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: h * .02,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: w * .3,
                            padding: EdgeInsets.only(
                              top: 20.0,
                              bottom: 5.0,
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Text(
                              data["date"],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[800],
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ),
                          userId != currentUser.uid
                              ? Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: BookMarkButton(
                                    postKind: data["postKind"],
                                    read: true,
                                    userId: userId,
                                    id: id,
                                  ),
                                )
                              : Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 5.0),
                        width: w * .45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${data["startTime"]} - ${data["endTime"]}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[800],
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: w * .45,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            for (int i = 0; i < data["speaker"].length; i++)
                              ListTile(
                                title: Text(
                                  data["speaker"][i],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                                subtitle: Text(
                                  S.of(context).eventViewSpeaker,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey[500],
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                                leading: CircleAvatar(
                                    child: Center(
                                      child: Text(
                                        data["speaker"][i][0].toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "SPProtext"),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFF112B38)),
                              )
                          ],
                        ),
                      ),
                      Container(
                        width: w * .4,
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Text(
                          data["about"],
                          textDirection: intl.Bidi.detectRtlDirectionality(
                            data["about"],
                          )
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: "Avenir"),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[400],
                    endIndent: w * .05,
                    indent: w * .05,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    height: h * .08,
                    width: w * .4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        inviteToRead(h, w, S.of(context).inviteButton),
                        SizedBox(
                          width: 20.0,
                        ),
                        InkWell(
                          child: HoverWidget(
                              child: interestButton(false),
                              hoverChild: interestButton(true),
                              onHover: (onHover) {}),
                          onTap: () async {
                            if (!interested) {
                              await users
                                  .doc(userId)
                                  .collection("Pub")
                                  .doc(id)
                                  .collection("interested")
                                  .doc(currentUser.uid)
                                  .set({
                                "uid": currentUser.uid,
                              });
                              setState(() {
                                interested = true;
                              });
                            } else {
                              await users
                                  .doc(userId)
                                  .collection("Pub")
                                  .doc(id)
                                  .collection("interested")
                                  .doc(currentUser.uid)
                                  .delete();
                              setState(() {
                                interested = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  )
                ]),
              );
            }
            return postDetailsLoading(h, w);
          }),
    );
  }
}
