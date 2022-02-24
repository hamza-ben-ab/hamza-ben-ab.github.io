import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:uy/screens/bookmark/read_later.dart';
import 'package:uy/screens/bookmark/watch_later.dart';
import 'package:uy/screens/create_post_file/create_post.dart';
import 'package:uy/screens/dashboard/main_dashboard.dart';
import 'package:uy/screens/home/home_widgets/home_widget.dart';
import 'package:uy/screens/posts/breaking_news.dart/bn_details.dart';
import 'package:uy/screens/profile/profile_View.dart';
import 'package:uy/screens/message/conversation_chat.dart';
import 'package:uy/screens/search/search_details_page.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';

class CenterBox extends StatefulWidget {
  const CenterBox({
    Key key,
  }) : super(key: key);
  @override
  _CenterBoxState createState() => _CenterBoxState();
}

class _CenterBoxState extends State<CenterBox> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int value = Provider.of<CenterBoxProvider>(context).getIndex;

    return Expanded(
      child: value == 0
          ? HomeWidget()
          : value == 1
              ? CreatePost()
              : value == 2
                  ? ReadLaterList()
                  : value == 3
                      ? WatchLaterList()
                      : value == 4
                          ? DashBoard()
                          : value == 5
                              ? ConversationChat()
                              : value == 6
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: h * .93,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: BreakingNewsDetails(),
                                        ),
                                      ),
                                    )
                                  : value == 7
                                      ? ProfileView()
                                      : value == 8
                                          ? Container(
                                              width: w * .63,
                                              child: SearchDetailsPage(),
                                            )
                                          : Container(),
    );
  }
}
