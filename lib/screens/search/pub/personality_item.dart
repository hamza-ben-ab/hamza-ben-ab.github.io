import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/loading_widget/pub_search_loading.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_home.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/widget/show_video.dart';
import 'package:uy/screens/search/hover.dart';

class SearchPersonalityItem extends StatefulWidget {
  final String userId;
  final String id;
  final String searchType;
  final bool forSearch;

  const SearchPersonalityItem(
      {Key key, this.userId, this.id, this.searchType, this.forSearch})
      : super(key: key);

  @override
  _SearchPersonalityItemState createState() => _SearchPersonalityItemState();
}

class _SearchPersonalityItemState extends State<SearchPersonalityItem> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String postKind;
  FunctionsServices functionsServices = FunctionsServices();
  PostFunctions postAllFunctions = PostFunctions();
  String userId;
  String id;

  @override
  void initState() {
    userId = widget.userId;
    id = widget.id;
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
            Map<String, dynamic> pubData = snapshot.data.data();
            final String postKind = pubData["postKind"];
            return Container(
              height: h * .4,
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
                    userId: userId,
                    data: pubData,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      width: w * .4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
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
                                                BorderRadius.circular(12.0),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.network(
                                                        pubData["mediaUrl"])
                                                    .image),
                                          ),
                                        ),
                                      ])
                                    : videoFormat.contains(pubData["extension"])
                                        ? Stack(children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              height: h * .2,
                                              width: w * .15,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                child: ShowVideo(
                                                  videoUrl: pubData["mediaUrl"],
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Icon(
                                                LineAwesomeIcons.play_circle,
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
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  margin: intl.Bidi.detectRtlDirectionality(
                                    pubData["full_name"],
                                  )
                                      ? EdgeInsets.only(right: 5.0)
                                      : EdgeInsets.only(left: 5.0),
                                  decoration: BoxDecoration(
                                    border: intl.Bidi.detectRtlDirectionality(
                                            pubData["full_name"])
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
                                  child: widget.forSearch
                                      ? Directionality(
                                          textDirection:
                                              intl.Bidi.detectRtlDirectionality(
                                                      pubData["full_name"])
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                          child: DynamicTextHighlighting(
                                            text: pubData["full_name"],
                                            highlights: [widget.searchType],
                                            caseSensitive: false,
                                            color: Colors.green[300],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              fontFamily: "Lora",
                                            ),
                                          ),
                                        )
                                      : Text(
                                          pubData["full_name"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            fontFamily: "Lora",
                                          ),
                                        ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: w * .16,
                                  child: Text(
                                    "${pubData["Occupation"]}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: w * .16,
                                  child: Text(
                                    "${pubData["Nationality"]}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: w * .16,
                                  child: Text(
                                    "${pubData["age"]}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: w * .16,
                                  child: Text(
                                    "${pubData["currentCity"]}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: h * .04,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: h * .05,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "./assets/icons/036-check.svg",
                                      color: Colors.black,
                                      height: 15.0,
                                      width: 15.0,
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
                                            functionsServices.dividethousand(
                                                snapshot.data.docs.length),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: "SPProtext",
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                height: h * .05,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "./assets/icons/068-cancel.svg",
                                      color: Colors.black,
                                      height: 15.0,
                                      width: 15.0,
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
                                            functionsServices.dividethousand(
                                                snapshot.data.docs.length),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: "SPProtext",
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                height: h * .05,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "./assets/icons/chat_1.svg",
                                      color: Colors.black,
                                      height: 15.0,
                                      width: 15.0,
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
                                            functionsServices.dividethousand(
                                                snapshot.data.docs.length),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: "SPProtext",
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              Container(
                                height: h * .05,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "./assets/icons/eyeglasses.svg",
                                      color: Colors.black,
                                      height: 25.0,
                                      width: 25.0,
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
                                            functionsServices.dividethousand(
                                                snapshot.data.docs.length),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: "SPProtext",
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              Container(
                                height: h * .05,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "./assets/icons/alert.svg",
                                      color: Colors.black,
                                      height: 15.0,
                                      width: 15.0,
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
                                            functionsServices.dividethousand(
                                                snapshot.data.docs.length),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: "SPProtext",
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
