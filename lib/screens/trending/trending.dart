import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/trending/trending_item.dart';
import 'package:uy/screens/search/hover.dart';

class TrendingNews extends StatefulWidget {
  const TrendingNews({Key key}) : super(key: key);

  @override
  _TrendingNewsState createState() => _TrendingNewsState();
}

class _TrendingNewsState extends State<TrendingNews> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AlertWidgets alertWidgets = AlertWidgets();
  int growthDiffer;
  int newGrowDiffer;
  int firstRead;
  int timeDiffer;
  int lastTime;
  int lastRead;
  int readCountDiffer;
  void growthInViews() async {
    CollectionReference pubCollectionRef =
        FirebaseFirestore.instance.collection("AllPub");

    QuerySnapshot pubQuerySnapshot = await pubCollectionRef.get();

    pubQuerySnapshot.docs.map((document) async {
      QuerySnapshot readersCollection = await users
          .doc(document.id.split("==").first)
          .collection("Pub")
          .doc(document.id.split("==").last)
          .collection("Readers")
          .get();

      setState(() {
        lastRead = readersCollection.docs.length;
        readCountDiffer =
            readersCollection.docs.length - document.data()["lastRead"];

        lastTime = DateTime.now()
            .difference(document.data()["lastTimeRead"].toDate())
            .inMinutes;
      });
      double result;

      if (readCountDiffer != 0) {
        setState(() {
          result = readCountDiffer / lastTime;

          document.reference.update({"growOrder": result});
          lastRead = readersCollection.docs.length;

          document.reference
              .update({"lastRead": lastRead, "lastTimeRead": DateTime.now()});
        });
      }
    }).toList();
  }

  @override
  void initState() {
    growthInViews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        width: w * .63,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("AllPub")
                      //.where("close", isEqualTo: false)
                      .orderBy("growOrder", descending: true)
                      .limitToLast(100)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 0.0,
                        width: 0.0,
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

                    return AnimationLimiter(
                      child: GridView.count(
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: List.generate(
                          snapshot.data.docs.length,
                          (int index) {
                            final String postKind =
                                snapshot.data.docs[index]["postKind"];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 3,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: TrendingItem(
                                    views: postKind == "inPic" ||
                                            postKind == "broadcasting"
                                        ? true
                                        : false,
                                    id: snapshot.data.docs[index].id
                                        .split("==")
                                        .last,
                                    userId: snapshot.data.docs[index].id
                                        .split("==")
                                        .first,
                                    document: snapshot.data.docs[index],
                                  ).xShowPointerOnHover,
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
      ),
    );
  }
}
