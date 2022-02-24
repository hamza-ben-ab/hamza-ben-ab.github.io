import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/comment_loading.dart';
import 'package:uy/screens/profile/profile_image_widget.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/time_ago.dart';

class PostCommentWidget extends StatefulWidget {
  final String commentContent;
  final String timeAgo;
  final String userId;
  final String commentId;
  final String docId;
  final String collection;

  const PostCommentWidget({
    Key key,
    this.commentContent,
    this.timeAgo,
    this.userId,
    this.commentId,
    this.docId,
    this.collection,
  }) : super(key: key);

  @override
  _PostCommentWidgetState createState() => _PostCommentWidgetState();
}

class _PostCommentWidgetState extends State<PostCommentWidget> {
  bool reply = false;
  String userId;
  String commentId;
  String documentId;
  bool modifier = false;
  String commentValue;
  bool isLike = false;
  FocusNode myFocusNode;
  bool textUp = false;
  Time timeCal = new Time();
  TextEditingController commentModifier = TextEditingController();
  TextEditingController subCommentController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool like = false;

  Future<void> likeExist() async {
    DocumentSnapshot user = await users
        .doc(widget.userId)
        .collection(widget.collection)
        .doc(widget.docId)
        .collection("Comments")
        .doc(widget.commentId)
        .collection("Likes")
        .doc(currentUser.uid)
        .get();

    if (user.exists) {
      isLike = true;
    } else {
      isLike = false;
    }
  }

  Widget showMenu(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * .1,
      child: PopupMenuButton(
          offset: Offset(5.0, 35.0),
          child: Container(
            height: h * .08,
            width: h * .08,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hover ? Colors.grey[200] : Colors.grey[50]),
            child: Center(
              child: Icon(
                Icons.more_horiz,
                color: Colors.grey[800],
              ),
            ),
          ),
          elevation: 10.0,
          color: Colors.grey[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: "2",
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: w * .12,
                    child: ListTile(
                      hoverColor: Colors.transparent,
                      title: Text(
                        S.of(context).commentModifer,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: "SPProtext"),
                      ),
                      leading: Icon(LineAwesomeIcons.pen, color: Colors.black),
                      onTap: () async {
                        setState(() {
                          modifier = true;
                        });
                        Navigator.pop(context, "1");
                      },
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "2",
                  child: Container(
                    width: w * .12,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ListTile(
                      hoverColor: Colors.transparent,
                      leading:
                          Icon(LineAwesomeIcons.trash, color: Colors.black),
                      title: Text(
                        S.of(context).commentDelete,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: "SPProtext"),
                      ),
                      onTap: () async {
                        Navigator.pop(context, "2");
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(userId)
                            .collection(widget.collection)
                            .doc(documentId)
                            .collection("Comments")
                            .doc(commentId)
                            .delete();
                      },
                    ),
                  ),
                ),
              ]),
    );
  }

  Widget deleteButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      child: Center(
        child: Icon(
          LineAwesomeIcons.times_circle,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      decoration: BoxDecoration(
          color: hover ? Colors.red[500] : Colors.red[700],
          borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget readerProfile(String image, String name, String currentLocation,
      String homeLocation, String userId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .6,
      width: w * .25,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * .07,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: HoverWidget(
                      child: deleteButtonWidget(false),
                      hoverChild: deleteButtonWidget(true),
                      onHover: (onHover) {},
                    ),
                  ),
                ],
              ),
            ),
            ProfileImageWidget(
              profileImage: image,
              userId: userId,
            ),
            SizedBox(
              height: h * .02,
            ),
            Container(
              width: w * .25,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SPProtext",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * .02,
            ),
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                "./assets/icons/placeholder.svg",
                height: 25.0,
                width: 25.0,
                color: Colors.grey[600],
              ),
              label: Text(
                currentLocation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                  fontFamily: "SPProtext",
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                "./assets/icons/placeholder.svg",
                height: 25.0,
                width: 25.0,
                color: Colors.grey[600],
              ),
              label: Text(
                homeLocation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                  fontFamily: "SPProtext",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    commentModifier = TextEditingController(text: widget.commentContent);
    userId = widget.userId;
    documentId = widget.docId;
    commentId = widget.commentId;
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
          future: users.doc(userId).collection("Pub").doc(documentId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: EdgeInsets.only(bottom: 5.0),
                width: w * .25,
                child: Column(
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                        future: users.doc(userId).get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> data = snapshot.data.data();
                            return Container(
                              height: h * .08,
                              width: w * .25,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: h * .055,
                                    width: h * .055,
                                    decoration: BoxDecoration(
                                      borderRadius: intl.Bidi
                                              .detectRtlDirectionality(S
                                                  .of(context)
                                                  .postViewWrittenBy)
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0),
                                              bottomLeft: Radius.circular(15.0),
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
                                            Image.network(data["image"]).image,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 7.0),
                                      height: h * .08,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: h * .08,
                                            width: w * .17,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap:
                                                        data["kind"] == "writer"
                                                            ? () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
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
                                                              }
                                                            : () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                        ),
                                                                        elevation:
                                                                            0.0,
                                                                        child: readerProfile(
                                                                            data["image"],
                                                                            data["full_name"],
                                                                            data["location"],
                                                                            data["homeLocation"],
                                                                            userId),
                                                                      );
                                                                    });
                                                              },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        HoverWidget(
                                                            child: Text(
                                                              data["full_name"],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "SPProtext"),
                                                            ),
                                                            hoverChild: Text(
                                                              data["full_name"],
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "SPProtext"),
                                                            ),
                                                            onHover:
                                                                (onHover) {}),
                                                        SizedBox(
                                                          width: 3.0,
                                                        ),
                                                        data["kind"] == "writer"
                                                            ? Container(
                                                                height:
                                                                    h * .017,
                                                                width: h * .017,
                                                                child: Image.asset(
                                                                    "./assets/images/check (2).png"),
                                                              )
                                                            : Container(
                                                                height: 0.0,
                                                                width: 0.0,
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: h * .005,
                                                  ),
                                                  Text(
                                                    widget.timeAgo,
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontSize: 10.0,
                                                        fontFamily:
                                                            "SPProtext"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: h * .04,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: commentId.contains(
                                                        currentUser.uid)
                                                    ? Tooltip(
                                                        message:
                                                            "edit or delete",
                                                        child: HoverWidget(
                                                            child:
                                                                showMenu(false),
                                                            hoverChild:
                                                                showMenu(true),
                                                            onHover:
                                                                (onHover) {}),
                                                      )
                                                    : Container(
                                                        height: 0.0,
                                                        width: 0.0,
                                                      ),
                                              ),
                                            ).xShowPointerOnHover,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: w * .2,
                              child: Row(
                                children: [
                                  //image
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[200],
                                    highlightColor: Colors.grey[300],
                                    child: Container(
                                      height: h * .05,
                                      width: h * .05,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
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
                                                CrossAxisAlignment.start,
                                            children: [
                                              //written By
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[200],
                                                  highlightColor:
                                                      Colors.grey[300],
                                                  child: Container(
                                                    height: h * .015,
                                                    width: w * .07,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      color: Colors.grey[300],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Full_name & timeAgo
                                              Container(
                                                width: w * .1,
                                                child: Row(
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[200],
                                                      highlightColor:
                                                          Colors.grey[300],
                                                      child: Container(
                                                        height: h * .015,
                                                        width: w * .03,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[200],
                                                      highlightColor:
                                                          Colors.grey[300],
                                                      child: Container(
                                                        height: h * .015,
                                                        width: w * .05,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          color:
                                                              Colors.grey[300],
                                                        ),
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
                        }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        width: w * .25,
                        child: Column(
                          children: [
                            modifier
                                ? Container(
                                    width: w * .22,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: commentModifier,
                                          maxLines: null,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.0,
                                              fontFamily: "SPProtext"),
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: h * .07,
                                          width: w * .2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  height: h * 0.03,
                                                  width: w * 0.05,
                                                  child: Center(
                                                    child: Text(
                                                      S.of(context).saveButton,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                          fontFamily:
                                                              "SPProtext"),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                      color: Colors.blue),
                                                ),
                                                onTap: () async {
                                                  await users
                                                      .doc(userId)
                                                      .collection(
                                                          widget.collection)
                                                      .doc(documentId)
                                                      .collection("Comments")
                                                      .doc(commentId)
                                                      .update({
                                                    "comment": commentModifier
                                                        .text
                                                        .trim()
                                                  });

                                                  setState(() {
                                                    modifier = false;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  height: h * 0.03,
                                                  width: w * 0.05,
                                                  child: Center(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .cancelButton,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                          fontFamily:
                                                              "SPProtext"),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    color: Color(0xFF112B38),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    modifier = false;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: !intl.Bidi
                                              .detectRtlDirectionality(S
                                                  .of(context)
                                                  .postViewWrittenBy)
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(15.0),
                                              bottomLeft: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0),
                                            )
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0),
                                            ),
                                      color: Colors.grey[200],
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    width: w * .25,
                                    child: Text(
                                      widget.commentContent,
                                      textDirection:
                                          intl.Bidi.detectRtlDirectionality(
                                                  widget.commentContent)
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "Avenir"),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return loadingCommentPost(h, w);
          }),
    );
  }
}

Widget buildIndicatorPage(bool iscurrentPage) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 350),
    height: iscurrentPage ? 10 : 8,
    width: iscurrentPage ? 10 : 8,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: iscurrentPage ? Colors.blue : Colors.white,
    ),
  );
}
