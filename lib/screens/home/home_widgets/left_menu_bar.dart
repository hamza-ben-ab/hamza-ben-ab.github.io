import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/suggestion_list/suggestions_list.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/home_partProvider.dart';
import 'package:intl/intl.dart' as intl;

class LeftMenuBar extends StatefulWidget {
  const LeftMenuBar({Key key}) : super(key: key);
  @override
  _LeftMenuBarState createState() => _LeftMenuBarState();
}

class _LeftMenuBarState extends State<LeftMenuBar> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AlertWidgets alertWidgets = AlertWidgets();

  InkWell buildHomeItems(
      int index, String title, String icon, bool hover, bool home) {
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        home
            ? Provider.of<HideLeftBarProvider>(context, listen: false)
                .openLeftBar()
            : Provider.of<HideLeftBarProvider>(context, listen: false)
                .closeleftBar();
        home
            ? Provider.of<HomePartIndexProvider>(context, listen: false)
                .changeIndex(0)
            : print("");
        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeCurrentIndex(index);
        //Provider.of<RightBarProvider>(context, listen: false).changeIndex(0);
      },
      child: Tooltip(
        message: title,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            height: h * .07,
            width: h * .07,
            decoration: BoxDecoration(
              color: hover ? Colors.grey[300] : Colors.grey[50],
              borderRadius: intl.Bidi.detectRtlDirectionality(
                      S.of(context).postViewWrittenBy)
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
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      height: h * .06,
                      width: h * .06,
                      child: Center(
                        child: SvgPicture.asset(
                          "./assets/icons/$icon.svg",
                          color: Colors.black,
                          height: 22.0,
                          width: 22.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: h * .025,
                  width: 3.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.white),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool show = Provider.of<HideLeftBarProvider>(context).show;
    return Container(
      height: h * .93,
      width: show ? w * .25 : w * .06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          show
              ? SuggestionsList()
              : Container(
                  height: 0.0,
                  width: 0.0,
                ),
          FutureBuilder<DocumentSnapshot>(
              future: users.doc(currentUser.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return Container(
                    height: h * .93,
                    width: w * .05,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: h * .15,
                        ),
                        HoverWidget(
                          child: buildHomeItems(
                              0, S.of(context).home, "house", false, true),
                          hoverChild: buildHomeItems(
                              0, S.of(context).home, "house", true, true),
                          onHover: (onHover) {},
                        ),
                        data["kind"] == "Journalist"
                            ? HoverWidget(
                                child: buildHomeItems(1, S.of(context).write,
                                    "edit", false, false),
                                hoverChild: buildHomeItems(1,
                                    S.of(context).write, "edit", true, false),
                                onHover: (onHover) {},
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        HoverWidget(
                          child: buildHomeItems(
                              2, S.of(context).readLater, "book", false, true),
                          hoverChild: buildHomeItems(
                              2, S.of(context).readLater, "book", true, true),
                          onHover: (onHover) {},
                        ),
                        HoverWidget(
                          child: buildHomeItems(3, S.of(context).watchLater,
                              "streaming", false, true),
                          hoverChild: buildHomeItems(
                              3,
                              S.of(context).watchLater,
                              "streaming",
                              true,
                              true),
                          onHover: (onHover) {},
                        ),
                        data["kind"] == "Journalist"
                            ? HoverWidget(
                                child: buildHomeItems(4, S.of(context).dashbord,
                                    "menu-3", false, false),
                                hoverChild: buildHomeItems(
                                    4,
                                    S.of(context).dashbord,
                                    "menu-3",
                                    true,
                                    false),
                                onHover: (onHover) {},
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        data["kind"] == "Journalist"
                            ? HoverWidget(
                                child: buildHomeItems(9, S.of(context).payment,
                                    "048-credit card", false, false),
                                hoverChild: buildHomeItems(
                                    9,
                                    S.of(context).payment,
                                    "048-credit card",
                                    true,
                                    false),
                                onHover: (onHover) {},
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                      ],
                    ),
                  );
                }
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              }),
        ],
      ),
    );
  }
}
