import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/home/home_widgets/watch_list_home/watch_home_list.dart';
import 'package:uy/screens/loading_widget/postHome_loading.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/trending/trending.dart';
import 'package:uy/screens/posts/show_event/event_view_post.dart';
import 'package:uy/screens/posts/other_post_view/poll_widget.dart';
import 'package:uy/screens/posts/general_post_view/post_home_view.dart';
import 'package:uy/screens/posts/other_post_view/profile_widget.dart';
import 'package:uy/screens/posts/other_post_view/research_A.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/read_filter_provider.dart';
import 'package:uy/services/provider/home_partProvider.dart';
import 'package:intl/intl.dart' as intl;

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  User currentUser = FirebaseAuth.instance.currentUser;
  ScrollController scrollController = ScrollController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AlertWidgets alertWidgets = AlertWidgets();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    FilterProvider filter = Provider.of<FilterProvider>(context);
    int currentindex = context.watch<HomePartIndexProvider>().currentIndex;
    return Container(
      height: h * .93,
      child: Column(
        children: [
          HomeCenterBoxOptionBar(),
          currentindex == 0
              ? Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: filter.filterString.isNotEmpty
                          ? users
                              .doc(currentUser.uid)
                              .collection("Home")
                              .where("topic", whereIn: filter.filterString)
                              .snapshots(includeMetadataChanges: true)
                          : users
                              .doc(currentUser.uid)
                              .collection("Home")
                              .orderBy("timeAgo", descending: true)
                              .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return loadingHomePost(h, w);
                            },
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
                          isAlwaysShown: true,
                          radius: Radius.circular(20.0),
                          controller: scrollController,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            cacheExtent: snapshot.data.docs.length * h * .92,
                            controller: scrollController,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              final String postKind =
                                  snapshot.data.docs[index]["postKind"];
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
                                  child: postKind == "event"
                                      ? EventViewPost(
                                          userId: user,
                                          id: id,
                                        )
                                      : postKind == "poll"
                                          ? PollWidget(
                                              userId: user,
                                              id: id,
                                            )
                                          : postKind == "research article"
                                              ? ResearchArticleWidget(
                                                  userId: user,
                                                  id: id,
                                                )
                                              : postKind == "personality"
                                                  ? PersonnalityProfileWidget(
                                                      userId: user,
                                                      id: id,
                                                    )
                                                  : PostHomeView(
                                                      userId: user,
                                                      id: id,
                                                    ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                )
              : currentindex == 1
                  ? WatchPostList()
                  : currentindex == 2
                      ? TrendingNews()
                      : Container(
                          height: 0.0,
                          width: 0.0,
                        )
        ],
      ),
    );
  }
}

class HomeCenterBoxOptionBar extends StatefulWidget {
  const HomeCenterBoxOptionBar({Key key}) : super(key: key);

  @override
  _HomeCenterBoxOptionBarState createState() => _HomeCenterBoxOptionBarState();
}

class _HomeCenterBoxOptionBarState extends State<HomeCenterBoxOptionBar> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int currentIndex = Provider.of<HomePartIndexProvider>(context).currentIndex;
    return Container(
      height: h * .1,
      width: w * .7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HoverWidget(
            child:
                buildProfileItems(0, S.of(context).read, "book", false, true),
            hoverChild:
                buildProfileItems(0, S.of(context).read, "book", true, true),
            onHover: (onHover) {},
          ),
          HoverWidget(
            child: buildProfileItems(
                1, S.of(context).watch, "streaming", false, true),
            hoverChild: buildProfileItems(
                1, S.of(context).watch, "streaming", true, true),
            onHover: (onHover) {},
          ),
          HoverWidget(
            child: buildProfileItems(
                2, S.of(context).trending, "fire", false, false),
            hoverChild: buildProfileItems(
                2, S.of(context).trending, "fire", true, false),
            onHover: (onHover) {},
          ),
          currentIndex == 0 || currentIndex == 1
              ? HoverWidget(
                  child: buildFilterButton(false),
                  hoverChild: buildFilterButton(true),
                  onHover: (onHover) {},
                )
              : Container(
                  height: 0.0,
                  width: 0.0,
                )
        ],
      ),
    );
  }

  InkWell buildFilterButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    FilterProviderChangeState filter =
        Provider.of<FilterProviderChangeState>(context);
    return InkWell(
      onTap: () {
        Provider.of<FilterProviderChangeState>(context, listen: false)
            .activeAndinactiveFilter();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        height: h * 0.06,
        width: w * .08,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[300] : Colors.grey[50],
          borderRadius:
              intl.Bidi.detectRtlDirectionality(S.of(context).postViewWrittenBy)
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
          //border: Border.all(color: Colors.grey[400]),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: h * .05,
                    width: h * .05,
                    child: Center(
                      child: SvgPicture.asset(
                        "./assets/icons/filter.svg",
                        height: 20.0,
                        width: 20.0,
                        color: filter.activeFilter ? accentColor : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Text(
                          S.of(context).filter,
                          style: TextStyle(
                            color: filter.activeFilter
                                ? accentColor
                                : Colors.grey[800],
                            fontSize: 12,
                            fontFamily: "SPProtext",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 3.0,
              width: w * .03,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: filter.activeFilter ? accentColor : Colors.grey[200],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell buildProfileItems(
      int index, String title, String icon, bool hover, bool read) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int currentindex = Provider.of<HomePartIndexProvider>(context).currentIndex;
    return InkWell(
      onTap: () {
        read
            ? Provider.of<HideLeftBarProvider>(context, listen: false)
                .openLeftBar()
            : Provider.of<HideLeftBarProvider>(context, listen: false)
                .closeleftBar();
        Provider.of<HomePartIndexProvider>(context, listen: false)
            .changeIndex(index);
        Provider.of<FilterProviderChangeState>(context, listen: false)
            .inactive();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        height: h * 0.06,
        width: w * .08,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[300] : Colors.grey[50],
          borderRadius:
              intl.Bidi.detectRtlDirectionality(S.of(context).postViewWrittenBy)
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
          //border: Border.all(color: Colors.grey[400]),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: h * .05,
                    width: h * .05,
                    child: Center(
                      child: SvgPicture.asset(
                        "./assets/icons/$icon.svg",
                        height: 20.0,
                        width: 20.0,
                        color:
                            currentindex == index ? accentColor : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: index == currentindex
                                ? accentColor
                                : Colors.black,
                            fontSize: 12,
                            fontFamily: "SPProtext",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 3.0,
              width: w * .03,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: index == currentindex ? accentColor : Colors.grey[200],
              ),
            )
          ],
        ),
      ),
    );
  }
}
