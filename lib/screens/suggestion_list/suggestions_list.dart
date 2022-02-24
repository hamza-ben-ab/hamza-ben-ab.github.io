import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/breaking_card_loading.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/suggestion_list/suggestions_item.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:intl/intl.dart' as intl;

class SuggestionsList extends StatefulWidget {
  const SuggestionsList({Key key}) : super(key: key);

  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  User currentUser = FirebaseAuth.instance.currentUser;
  ScrollController suggestionsListScroll = ScrollController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AlertWidgets alertWidgets = AlertWidgets();
  String location;
  List<String> journalistByCountry = [];
  List<QueryDocumentSnapshot> results;

  Future getUserDocs() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Users");

    QuerySnapshot querySnapshot = await _collectionRef.get();
    QuerySnapshot query =
        await users.doc(currentUser.uid).collection("Subscriptions").get();

    setState(() {
      results = querySnapshot.docs
          .where(
            (document) =>
                document
                    .data()["currentLocation"]
                    .toString()
                    .split(", ")
                    .last
                    .toLowerCase() ==
                doc
                    .data()["currentLocation"]
                    .toString()
                    .toLowerCase()
                    .split(", ")
                    .last,
          )
          .toList();

      results = querySnapshot.docs
          .where(
            (document) => document.data()["kind"] == "Journalist",
          )
          .toList();

      results.map((doc) => journalistByCountry.add(doc.id)).toList();

      for (int i = 0; i < query.docs.length; i++) {
        if (journalistByCountry.contains(query.docs[i].id)) {
          journalistByCountry.remove(query.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getUserDocs();
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
      child: Container(
        height: h * .93,
        width: w * .2,
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).todayTopWritting,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        fontFamily: "SPProtext",
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                      endIndent: w * .05,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      S.of(context).suggestionsForyou,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        fontFamily: "SPProtext",
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[400],
                    endIndent: w * .05,
                  ),
                  journalistByCountry.isNotEmpty
                      ? Container(
                          width: w * .2,
                          height: h * .45,
                          child: Scrollbar(
                            controller: suggestionsListScroll,
                            isAlwaysShown: true,
                            radius: Radius.circular(20.0),
                            child: AnimationLimiter(
                              child: ListView.builder(
                                controller: suggestionsListScroll,
                                itemCount: journalistByCountry.length,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(seconds: 2),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: SlideAnimation(
                                        child: journalistByCountry[index] !=
                                                currentUser.uid
                                            ? SuggestionItem(
                                                userId:
                                                    journalistByCountry[index],
                                              ).xShowPointerOnHover
                                            : Container(
                                                height: 0.0,
                                                width: 0.0,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: w * .2,
                          height: h * .45,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: users.snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData || snapshot.hasError) {
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
                                return Scrollbar(
                                  controller: suggestionsListScroll,
                                  isAlwaysShown: true,
                                  radius: Radius.circular(20.0),
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      controller: suggestionsListScroll,
                                      itemCount: journalistByCountry.length,
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration: const Duration(seconds: 2),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: SlideAnimation(
                                              child:
                                                  journalistByCountry[index] !=
                                                          currentUser.uid
                                                      ? SuggestionItem(
                                                          userId:
                                                              journalistByCountry[
                                                                  index],
                                                        ).xShowPointerOnHover
                                                      : Container(
                                                          height: 0.0,
                                                          width: 0.0,
                                                        ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ),
                  Divider(
                    color: Colors.grey[400],
                    endIndent: w * .05,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
