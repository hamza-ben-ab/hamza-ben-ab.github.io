import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/pub_search_loading.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/search/pub/personality_item.dart';
import 'package:uy/screens/search/pub/pub_item.dart';
import 'package:uy/screens/search/search_widget.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/search_details_provider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:intl/intl.dart' as intl;

class SearchPublicationKeyExtent extends StatefulWidget {
  const SearchPublicationKeyExtent({Key key}) : super(key: key);

  @override
  _SearchPublicationKeyExtentState createState() =>
      _SearchPublicationKeyExtentState();
}

class _SearchPublicationKeyExtentState
    extends State<SearchPublicationKeyExtent> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');
  AlertWidgets alertWidgets = AlertWidgets();
  Time time = Time();

  List<QueryDocumentSnapshot> results;
  ScrollController scrollController = ScrollController();
  ScrollController loadingScrollController = ScrollController();
  FunctionsServices functionsServices = FunctionsServices();
  SearchWidgets searchWidgets = SearchWidgets();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String searchTyping =
        Provider.of<SearchDetailsProvider>(context).searchTyping;
    return Center(
      child: Directionality(
        textDirection:
            intl.Bidi.detectRtlDirectionality(S.of(context).postViewWrittenBy)
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Container(
          width: w * .63,
          margin: EdgeInsets.only(left: 10.0),
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  allPub.where("postKind", isNotEqualTo: "event").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.only(top: h * .05),
                    child: ListView.builder(
                      controller: loadingScrollController,
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
                  );
                }
                results = snapshot.data.docs;

                results.retainWhere((DocumentSnapshot doc) {
                  String postKind = doc.data()["postKind"];
                  String field = postKind != "commentary" &&
                          postKind != "essay" &&
                          postKind != "inPic" &&
                          postKind != "broadcasting"
                      ? "title"
                      : "description";
                  return doc.data()[field].toString().toLowerCase().contains(
                        searchTyping.toLowerCase(),
                      );
                });

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
                  height: h * .84,
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
                              String postKind = results[index]["postKind"];
                              QueryDocumentSnapshot user = results[index];

                              return Center(
                                child: postKind == "personality"
                                    ? SearchPersonalityItem(
                                        userId: user.id
                                            .toString()
                                            .split("==")
                                            .first,
                                        id: user.id.toString().split("==").last,
                                        searchType: searchTyping,
                                      )
                                    : SearchPubItem(
                                        forSearch: true,
                                        byTitle: postKind != "commentary" &&
                                                postKind != "essay" &&
                                                postKind != "inPic" &&
                                                postKind != "broadcasting"
                                            ? true
                                            : false,
                                        userId: user.id
                                            .toString()
                                            .split("==")
                                            .first,
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
      ),
    );
  }
}
