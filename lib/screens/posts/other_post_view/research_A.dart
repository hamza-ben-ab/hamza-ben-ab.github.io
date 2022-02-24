import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uy/screens/bookmark/bookMark_button.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_home.dart';
import 'package:uy/screens/posts/post_widgets/like_dislike_bar.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/loading_widget/postHome_loading.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';

class ResearchArticleWidget extends StatefulWidget {
  final String userId;
  final String id;
  const ResearchArticleWidget({Key key, this.userId, this.id})
      : super(key: key);

  @override
  _ResearchArticleWidgetState createState() => _ResearchArticleWidgetState();
}

class _ResearchArticleWidgetState extends State<ResearchArticleWidget> {
  User currentUser = FirebaseAuth.instance.currentUser;
  PageController pageController = PageController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String userId;
  String id;
  FunctionsServices functionsServices = FunctionsServices();
  PostFunctions postAllFunctions = PostFunctions();

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
          Map<String, dynamic> data = snapshot.data.data();

          return Container(
            width: w * .4,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                AheadPostHome(
                  data: data,
                  userId: userId,
                ),
                SingleChildScrollView(
                  child: Directionality(
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            S.of(context).postViewWrittenBy)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Container(
                      width: w * .4,
                      child: Column(
                        children: [
                          LikeAndDisLikeBar(
                            id: id,
                            userId: userId,
                            views: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    width: w * .3,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "#${data["topic"]}",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 11.0,
                                              fontFamily: "SPProtext"),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        for (int i = 0;
                                            i < data["writers"].length;
                                            i++)
                                          Text(
                                            "# ${data["writers"][i]} ",
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "SPProtext"),
                                          ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          "# ${data["keywords"]}",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 11.0,
                                              fontFamily: "SPProtext"),
                                        ),
                                      ],
                                    )),
                                BookMarkButton(
                                  postKind: data["postKind"],
                                  userId: userId,
                                  id: id,
                                  read: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: h * .02,
                          ),
                          Container(
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
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: h * .15),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              width: w * .45,
                              child: Text(
                                data["abstract"],
                                overflow: TextOverflow.fade,
                                textDirection:
                                    intl.Bidi.detectRtlDirectionality(
                                            data["intro"])
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontFamily: "Avenir"),
                              ),
                            ),
                          ),
                          Container(
                            height: h * .04,
                            width: w * .4,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Provider.of<ReadPostProvider>(context,
                                            listen: false)
                                        .changePostId(userId, id);
                                    showDialog(
                                      context: (context),
                                      builder: (context) {
                                        return ShowPostDetails(
                                          id: widget.id,
                                          postKind: "research article",
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
                          ),
                          SizedBox(
                            height: h * .02,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return loadingHomePost(h, w);
      },
    );
  }
}
