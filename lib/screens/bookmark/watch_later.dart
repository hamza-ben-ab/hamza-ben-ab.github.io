import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/pub_search_loading.dart';

import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/search/pub/pub_item.dart';
import 'package:uy/services/functions.dart';
import 'package:intl/intl.dart' as intl;

class WatchLaterList extends StatefulWidget {
  const WatchLaterList({Key key}) : super(key: key);
  @override
  _WatchLaterListState createState() => _WatchLaterListState();
}

class _WatchLaterListState extends State<WatchLaterList> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  ScrollController scrollControllerOne = ScrollController();
  AlertWidgets alertWidgets = AlertWidgets();
  PostFunctions postFunctions = PostFunctions();
  FunctionsServices functionsServices = FunctionsServices();

  deleteButtonWidget(
    bool hover,
    double h,
    String doc,
  ) {
    return InkWell(
      child: Container(
        height: h * .06,
        width: h * .06,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hover ? Colors.red[300] : Colors.red[200],
        ),
        child: Center(
          child: Icon(
            LineAwesomeIcons.times_circle_1,
            color: Colors.white,
            size: 25.0,
          ),
        ),
      ),
      onTap: () async {
        await users
            .doc(currentUser.uid)
            .collection("Watch Later")
            .doc(doc)
            .delete();
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Directionality(
        textDirection:
            intl.Bidi.detectRtlDirectionality(S.of(context).readLater)
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                children: [
                  Text(
                    S.of(context).watchLater,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        fontFamily: "SPProtext"),
                  ),
                ],
              ),
            ),
            Container(
              height: h * .91,
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: users
                    .doc(currentUser.uid)
                    .collection("Watch Later")
                    .orderBy("timeAgo", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (_, context) {
                          return Center(child: pubSearchLoading(h, w));
                        },
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return alertWidgets.errorWidget(
                        h, w, S.of(context).noContentAvailable);
                  }

                  if (snapshot.data.docs.isEmpty) {
                    return alertWidgets.emptyWidget(
                        h, w, S.of(context).noOtherPublication);
                  }
                  return Scrollbar(
                    thickness: 10.0,
                    showTrackOnHover: true,
                    isAlwaysShown: true,
                    radius: Radius.circular(20.0),
                    controller: scrollControllerOne,
                    child: AnimationLimiter(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        controller: scrollControllerOne,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final postKind =
                              snapshot.data.docs[index]["postKind"];
                          final String id = snapshot.data.docs[index].id
                              .toString()
                              .split("==")
                              .last;
                          final String user = snapshot.data.docs[index].id
                              .toString()
                              .split("==")
                              .first;

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(seconds: 2),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: SlideAnimation(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SearchPubItem(
                                    forSearch: false,
                                    byTitle: postKind != "commentary" &&
                                            postKind != "essay" &&
                                            postKind != "inPic" &&
                                            postKind != "broadcasting"
                                        ? true
                                        : false,
                                    userId: user,
                                    id: id,
                                  ),
                                  HoverWidget(
                                      child: deleteButtonWidget(false, h,
                                          snapshot.data.docs[index].id),
                                      hoverChild: deleteButtonWidget(true, h,
                                          snapshot.data.docs[index].id),
                                      onHover: (onHover) {}),
                                ],
                              )),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
