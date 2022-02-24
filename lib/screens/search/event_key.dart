import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/pub_search_loading.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_home.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/screens/search/search_widget.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/services/provider/search_details_provider.dart';

class SearchEventsKey extends StatefulWidget {
  final bool extent;
  const SearchEventsKey({Key key, this.extent}) : super(key: key);

  @override
  _SearchEventsKeyState createState() => _SearchEventsKeyState();
}

class _SearchEventsKeyState extends State<SearchEventsKey> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference journalists =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');
  List<QueryDocumentSnapshot> results;
  ScrollController scrollController = ScrollController();
  FunctionsServices functionsServices = FunctionsServices();
  SearchWidgets searchWidgets = SearchWidgets();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String searchTyping =
        Provider.of<SearchDetailsProvider>(context).searchTyping;

    return Center(
      child: StreamBuilder<QuerySnapshot>(
          stream: allPub.where("postKind", isEqualTo: "event").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  margin: EdgeInsets.only(top: h * .05),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
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
              (DocumentSnapshot doc) =>
                  doc.data()["title"].toString().toLowerCase().contains(
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
                                  S.of(context).tagEvent)
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
                                  "${S.of(context).tagEvent}",
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
                          child: EventItemWidget(
                            userId: user.id.toString().split("==").first,
                            id: user.id.toString().split("==").last,
                            searchTyping: searchTyping,
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
                                .changeIndex(6);
                          },
                          child: HoverWidget(
                            child: searchWidgets.seeMoreWidget(
                                false, h, w, S.of(context).seeAllEvent),
                            hoverChild: searchWidgets.seeMoreWidget(
                                true, h, w, S.of(context).seeAllEvent),
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

class EventItemWidget extends StatefulWidget {
  final String userId;
  final String id;
  final String searchTyping;
  const EventItemWidget({Key key, this.userId, this.id, this.searchTyping})
      : super(key: key);

  @override
  _EventItemWidgetState createState() => _EventItemWidgetState();
}

class _EventItemWidgetState extends State<EventItemWidget> {
  bool interested = false;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  QueryDocumentSnapshot eventId;

  Future<void> interestedExist() async {
    DocumentSnapshot user = await users
        .doc(widget.userId)
        .collection("Pub")
        .doc(widget.id)
        .collection("interested")
        .doc(currentUser.uid)
        .get();
    setState(() {
      if (user.exists) {
        interested = true;
      } else {
        interested = false;
      }
    });
  }

  Widget eventWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.userId).collection("Pub").doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
                width: w * .4,
                height: h * .3,
                margin: EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.grey[400],
                  ),
                ),
                child: Column(
                  children: [
                    AheadPostHome(
                      userId: widget.userId,
                      data: data,
                    ),
                    Directionality(
                      textDirection: intl.Bidi.detectRtlDirectionality(
                              S.of(context).tagEvent)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              height: h * .2,
                              width: w * .1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.network(data["mediaUrl"]).image,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "${data["date"]}, ${data["startTime"]} - ${data["endTime"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SPProtext"),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                widget.searchTyping != null
                                    ? Container(
                                        width: w * .25,
                                        child: DynamicTextHighlighting(
                                          text: data["title"],
                                          highlights: [widget.searchTyping],
                                          caseSensitive: false,
                                          color: Colors.green[300],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SPProtext"),
                                        ),
                                      )
                                    : Container(
                                        width: w * .25,
                                        child: Text(
                                          data["title"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SPProtext"),
                                        ),
                                      ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "${data["place"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: h * .15,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    width: w * .25,
                                    child: Directionality(
                                      textDirection:
                                          intl.Bidi.detectRtlDirectionality(
                                                  data["about"])
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      child: Text(
                                        "${data["about"].toString().length <= 200 ? data["about"] : data["about"].toString().substring(0, 200)}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontFamily: "SPProtext"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                    )
                  ],
                )

                /*
                 InkWell(
                  child: Container(
                    height: h * 0.04,
                    width: w * .07,
                    padding: EdgeInsets.symmetric(
                        horizontal: !interested ? 5.0 : 5.0),
                    child: Center(
                      child: !interested
                          ? Text(
                              S.of(context).eventInterestedButton,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontFamily: "SPProtext"),
                            )
                          : interested
                              ? Text(
                                  S.of(context).eventNotInterestedButton,
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                )
                              : Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: !interested
                            ? Colors.lightBlueAccent
                            : Colors.grey[400]),
                  ),
                  onTap: () async {
                    if (!interested) {
                      await users
                          .doc(widget.userId)
                          .collection("Pub")
                          .doc(widget.id)
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
                          .doc(widget.userId)
                          .collection("Pub")
                          .doc(widget.id)
                          .collection("interested")
                          .doc(currentUser.uid)
                          .delete();
                      setState(() {
                        interested = false;
                      });
                    }
                  },
                ),
               
                  */
                //.xShowPointerOnHover,
                );
          }
          return pubSearchLoading(h, w);
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ReadPostProvider>(context, listen: false)
            .changePostId(widget.userId, widget.id);
        showDialog(
          context: (context),
          builder: (context) {
            return ShowPostDetails(
              id: widget.id,
              postKind: "event",
            );
          },
        );
      },
      child: HoverWidget(
          child: eventWidget(false),
          hoverChild: eventWidget(true),
          onHover: (event) {}),
    );
  }
}

class SearchEventsKeyExtent extends StatefulWidget {
  const SearchEventsKeyExtent({Key key}) : super(key: key);

  @override
  _SearchEventsKeyExtentState createState() => _SearchEventsKeyExtentState();
}

class _SearchEventsKeyExtentState extends State<SearchEventsKeyExtent> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference journalists =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');

  List<QueryDocumentSnapshot> results;
  ScrollController scrollController = ScrollController();
  FunctionsServices functionsServices = FunctionsServices();
  SearchWidgets searchWidgets = SearchWidgets();
  AlertWidgets alertWidgets = AlertWidgets();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String searchTyping =
        Provider.of<SearchDetailsProvider>(context).searchTyping;

    return Center(
      child: Container(
        width: w * .63,
        margin: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: allPub.where("postKind", isEqualTo: "event").snapshots(),
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
                (DocumentSnapshot doc) =>
                    doc.data()["title"].toString().toLowerCase().contains(
                          searchTyping.toLowerCase(),
                        ),
              );

              if (snapshot.hasError) {
                return alertWidgets.errorWidget(
                    h, w, S.of(context).noContentAvailable);
              }

              if (results.isEmpty) {
                return alertWidgets.emptyWidget(
                    h, w, S.of(context).noEventmatching);
              }
              return Container(
                width: w * .63,
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  children: [
                    Padding(
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
                              child: EventItemWidget(
                                userId: user.id.toString().split("==").first,
                                id: user.id.toString().split("==").last,
                                searchTyping: searchTyping,
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
