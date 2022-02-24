import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/home/home_widgets/home_filter/list_filter.dart';
import 'package:uy/screens/menu/menu_list.dart';
import 'package:uy/screens/message/messages_list.dart';
import 'package:uy/screens/notification_page.dart';
import 'package:uy/screens/posts/breaking_news.dart/bn_list.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:uy/services/provider/read_filter_provider.dart';
import 'package:uy/services/provider/right_bar_provider.dart';
import 'package:uy/services/provider/switch_provider.dart';
import 'package:intl/intl.dart' as intl;

class RightBreakingNewsBar extends StatefulWidget {
  const RightBreakingNewsBar({
    Key key,
  }) : super(key: key);
  @override
  _RightBreakingNewsBarState createState() => _RightBreakingNewsBarState();
}

class _RightBreakingNewsBarState extends State<RightBreakingNewsBar> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  ScrollController breakingNewsController = ScrollController();
  String genderValue;
  Future getThelastUser() async {
    QuerySnapshot doc = await users
        .doc(currentUser.uid)
        .collection("Chat")
        .orderBy("lastTime", descending: true)
        .get();

    Provider.of<RightBarProvider>(context, listen: false).changeIndex(1);
    Provider.of<MessageProvider>(context, listen: false)
        .changeMessageId(doc.docs.first.id);
    Provider.of<CenterBoxProvider>(context, listen: false)
        .changeCurrentIndex(5);
  }

  getStringGender() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    if (doc.data()["Gender"] == "male") {
      setState(() {
        genderValue = "male";
      });
    } else {
      setState(() {
        genderValue = "women";
      });
    }
  }

  InkWell rigthBarButtonWidget(int index, String title, String icon,
      dynamic stream, bool hover, bool isMessage) {
    double h = MediaQuery.of(context).size.height;
    int indexCurrent = context.watch<RightBarProvider>().currentIndex;

    return InkWell(
      onTap: () async {
        Provider.of<RightBarProvider>(context, listen: false)
            .changeIndex(index);

        Provider.of<FilterProviderChangeState>(context, listen: false)
            .inactive();
      },
      child: Tooltip(
        message: title,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              height: h * .055,
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "./assets/icons/$icon.svg",
                      height: 20.0,
                      width: 20.0,
                      color: indexCurrent == index ? accentColor : Colors.black,
                    ),
                    Container(
                      height: 3.0,
                      width: 7.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: index == indexCurrent
                            ? accentColor
                            : Colors.grey[50],
                      ),
                    )
                  ],
                ),
              ),
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
                //border: Border.all(color: Colors.grey[400]),
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: stream != null
                  ? Container(
                      height: h * .02,
                      width: h * .02,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: stream,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 0.0,
                                width: 0.0,
                              );
                            }
                            if (snapshot.data.docs.isEmpty) {
                              return Container(
                                height: 0.0,
                                width: 0.0,
                              );
                            }
                            return Container(
                              height: h * .04,
                              width: h * .04,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF505072),
                              ),
                              child: Center(
                                child: Text(
                                  snapshot.data.docs.length < 10
                                      ? snapshot.data.docs.length.toString()
                                      : "+9",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 12.0),
                                ),
                              ),
                            );
                          }),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
            )
          ],
        ),
      ),
    );
  }

  InkWell messageButtonWidget(dynamic stream, bool hover) {
    double h = MediaQuery.of(context).size.height;
    int indexCurrent = context.watch<RightBarProvider>().currentIndex;
    //int index = Provider.of<SwitchProvider>(context).listLength;
    return InkWell(
      onTap: () async {
        QuerySnapshot doc =
            await users.doc(currentUser.uid).collection("Chat").get();
        Provider.of<SwitchProvider>(context, listen: false)
            .getlistLength(doc.docs.length);
        // Provider.of<HideLeftBarProvider>(context, listen: false).closeleftBar();
        doc.docs.length == 0
            ? Provider.of<HideLeftBarProvider>(context, listen: false)
                .closeleftBar()
            : Provider.of<HideLeftBarProvider>(context, listen: false)
                .openLeftBar();

        Provider.of<FilterProviderChangeState>(context, listen: false)
            .inactive();
        Provider.of<SwitchProvider>(context, listen: false).listLength > 0
            ? getThelastUser()
            : Provider.of<RightBarProvider>(context, listen: false)
                .changeIndex(1);
      },
      child: Tooltip(
        message: S.of(context).message,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              height: h * .055,
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "./assets/icons/msg.svg",
                      height: 20.0,
                      width: 20.0,
                      color: indexCurrent == 1 ? accentColor : Colors.black,
                    ),
                    Container(
                      height: 3.0,
                      width: 7.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color:
                            1 == indexCurrent ? accentColor : Colors.grey[50],
                      ),
                    )
                  ],
                ),
              ),
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
                //border: Border.all(color: Colors.grey[400]),
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: stream != null
                  ? Container(
                      height: h * .02,
                      width: h * .02,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: stream,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 0.0,
                                width: 0.0,
                              );
                            }
                            if (snapshot.data.docs.isEmpty) {
                              return Container(
                                height: 0.0,
                                width: 0.0,
                              );
                            }
                            return Container(
                              height: h * .04,
                              width: h * .04,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF505072),
                              ),
                              child: Center(
                                child: Text(
                                  snapshot.data.docs.length < 10
                                      ? snapshot.data.docs.length.toString()
                                      : "+9",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 12.0),
                                ),
                              ),
                            );
                          }),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Stream messageStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Chat")
      .where("new message", isEqualTo: true)
      .snapshots();
  Stream notificationStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Notifications")
      .where("seen", isEqualTo: false)
      .snapshots();

  Widget buildRigthBarProfile(int index) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: h * .055,
      child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(currentUser.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data.data();
              return InkWell(
                onTap: () {
                  Provider.of<RightBarProvider>(context, listen: false)
                      .changeIndex(index);
                  Provider.of<FilterProviderChangeState>(context, listen: false)
                      .inactive();
                },
                child: Tooltip(
                  message: S.of(context).account,
                  child: Container(
                    height: h * .06,
                    width: h * .06,
                    decoration: BoxDecoration(
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
                        image: data["image"] == "" && genderValue == "male"
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    Image.asset("./assets/images/man.png").image
                                /* data["image"] == "" && genderValue == "male"
                              ? Image.asset("./assets/images/man.png").image
                              : data["image"] == "" && genderValue == "women"
                                  ? Image.asset("./assets/images/women.png")
                                      .image
                                  : Image.network(data["image"]).image*/
                                )
                            : data["image"] == "" && genderValue == "women"
                                ? DecorationImage(
                                    image:
                                        Image.asset("./assets/images/women.png")
                                            .image)
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(data["image"]).image)),
                  ),
                ),
              );
            }
            return Container(
              height: h * .07,
              width: w * .05,
            );
          }),
    );
  }

  Widget rightWidgetPart(Widget widget) {
    return Stack(
      children: [
        widget,
        InterestList(),
      ],
    );
  }

  @override
  void initState() {
    getStringGender();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int indexCurrent = context.watch<RightBarProvider>().currentIndex;
    int listLength = Provider.of<SwitchProvider>(context).listLength;
    return Container(
      width: w * .24,
      height: h * .93,
      child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
              future: users.doc(currentUser.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return Container(
                    height: h * .1,
                    width: w * .24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HoverWidget(
                          child: rigthBarButtonWidget(
                            0,
                            S.of(context).createPostBreakingNewsTitle,
                            "fast-time",
                            null,
                            false,
                            false,
                          ),
                          hoverChild: rigthBarButtonWidget(
                            0,
                            S.of(context).createPostBreakingNewsTitle,
                            "fast-time",
                            null,
                            true,
                            false,
                          ),
                          onHover: (onHover) {},
                        ),
                        HoverWidget(
                          child: messageButtonWidget(
                            messageStream,
                            false,
                          ),
                          hoverChild: messageButtonWidget(
                            messageStream,
                            true,
                          ),
                          onHover: (onHover) {},
                        ),
                        data["kind"] == "Journalist"
                            ? HoverWidget(
                                child: rigthBarButtonWidget(
                                  2,
                                  S.of(context).notificationTitle,
                                  "notification",
                                  notificationStream,
                                  false,
                                  false,
                                ),
                                hoverChild: rigthBarButtonWidget(
                                  2,
                                  S.of(context).notificationTitle,
                                  "notification",
                                  notificationStream,
                                  true,
                                  false,
                                ),
                                onHover: (onHover) {},
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        buildRigthBarProfile(3)
                      ],
                    ),
                  );
                }
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              }),
          indexCurrent == 0 || (indexCurrent == 1 && listLength > 0)
              ? Expanded(
                  child: Stack(
                    children: [
                      BreakingNewsList(),
                      InterestList(),
                    ],
                  ),
                )
              : (indexCurrent == 1 && listLength == 0)
                  ? Expanded(
                      child: MessagesList(
                        empty: true,
                      ),
                    )
                  : indexCurrent == 2
                      ? Expanded(
                          child: rightWidgetPart(
                            NotificationPage(),
                          ),
                        )
                      : Expanded(
                          child: rightWidgetPart(
                            MenuListButton(),
                          ),
                        )
        ],
      ),
    );
  }
}
