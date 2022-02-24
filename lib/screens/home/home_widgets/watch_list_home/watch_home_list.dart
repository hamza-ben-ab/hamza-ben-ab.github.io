import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/posts/general_post_view/post_home_view.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/services/provider/home_partProvider.dart';
import 'package:uy/services/provider/watch_filter_provider.dart';

class WatchPostList extends StatefulWidget {
  @override
  _WatchPostListState createState() => _WatchPostListState();
}

class _WatchPostListState extends State<WatchPostList> {
  User currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final ScrollController watchListScrollController = ScrollController();
  int currentPage = 0;
  PageController controller = PageController(initialPage: 0);
  AlertWidgets alertWidgets = AlertWidgets();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    WatchFilterProvider watchProvider =
        Provider.of<WatchFilterProvider>(context);

    return Expanded(
      child: Container(
        width: w * .63,
        child: StreamBuilder<QuerySnapshot>(
            stream: watchProvider.filterString.isNotEmpty
                ? users
                    .doc(currentUser.uid)
                    .collection("Watch")
                    .where("topic", whereIn: watchProvider.filterString)
                    .snapshots()
                : users
                    .doc(currentUser.uid)
                    .collection("Watch")
                    .orderBy("timeAgo", descending: true)
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

              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  itemBuilder: (context, index) {
                    final String user = snapshot.data.docs[index].id
                        .toString()
                        .split("==")
                        .first;
                    final String id = snapshot.data.docs[index].id
                        .toString()
                        .split("==")
                        .last;

                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        width: w * .4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child: PostHomeView(
                          userId: user,
                          id: id,
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
