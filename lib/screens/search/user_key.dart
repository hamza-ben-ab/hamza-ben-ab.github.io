import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/search_user_loading.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/profile/profile_image_widget.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/screens/search/search_widget.dart';
import 'package:uy/services/functions.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/provider/search_details_provider.dart';
import 'package:intl/intl.dart' as intl;

class SearchUsersKey extends StatefulWidget {
  final String title;

  final String whereString;

  const SearchUsersKey({
    Key key,
    this.title,
    this.whereString,
  }) : super(key: key);

  @override
  _SearchUsersKeyState createState() => _SearchUsersKeyState();
}

class _SearchUsersKeyState extends State<SearchUsersKey> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
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
      child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                margin: EdgeInsets.only(top: h * .05),
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  controller: loadingScrollController,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white),
                        child: searchUserLoading(h, w),
                      ),
                    );
                  },
                ),
              );
            }
            results = snapshot.data.docs;

            results.retainWhere(
              (DocumentSnapshot doc) => doc
                  .data()[widget.whereString]
                  .toString()
                  .toLowerCase()
                  .contains(
                    searchTyping.toLowerCase(),
                  ),
            );

            return results.length > 0
                ? Container(
                    width: w * .45,
                    margin: EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        results.isEmpty
                            ? Container(
                                height: 0.0,
                                width: 0.0,
                              )
                            : Directionality(
                                textDirection:
                                    intl.Bidi.detectRtlDirectionality(
                                            S.of(context).telltrueUser)
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.title,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "SPProtext",
                                        ),
                                      ),
                                      Text(
                                        "${functionsServices.dividethousand(results.length)} ${S.of(context).result}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            fontFamily: "SPProtext"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        Scrollbar(
                          controller: scrollController,
                          isAlwaysShown: true,
                          radius: Radius.circular(20.0),
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: results.length > 3 ? 3 : results.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              QueryDocumentSnapshot user = results[index];
                              return Center(
                                child: FollowButton(
                                  whereField: widget.whereString,
                                  index: index,
                                  userId: user,
                                  searchText: searchTyping,
                                ),
                              );
                            },
                          ),
                        ),
                        results.length > 3
                            ? InkWell(
                                onTap: () {
                                  Provider.of<SearchDetailsProvider>(context,
                                          listen: false)
                                      .changeIndex(1);
                                },
                                child: HoverWidget(
                                  child: searchWidgets.seeMoreWidget(
                                      false, h, w, S.of(context).seeAllpeople),
                                  hoverChild: searchWidgets.seeMoreWidget(
                                      true, h, w, S.of(context).seeAllpeople),
                                  onHover: (onHover) {},
                                ),
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              )
                      ],
                    ),
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  );
          }),
    );
  }
}

class FollowButton extends StatefulWidget {
  final int index;
  final QueryDocumentSnapshot userId;
  final String searchText;
  final String whereField;
  const FollowButton(
      {Key key, this.index, this.userId, this.searchText, this.whereField})
      : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool seeMore = false;
  bool filterOnly = false;
  bool isFollow = false;
  List<String> highlights;

  void applyChanges(List<String> newHighlights) {
    setState(() {
      highlights = newHighlights;
    });
  }

  Future<void> checkSubscribe(String userId) async {
    DocumentSnapshot user = await users
        .doc(currentUser.uid)
        .collection("Subscriptions")
        .doc(userId)
        .get();
    setState(() {
      if (user.exists) {
        isFollow = true;
      } else {
        isFollow = false;
      }
    });

    return isFollow;
  }

  Widget fullNameWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeCurrentIndex(7);
        Provider.of<HideLeftBarProvider>(context, listen: false).closeleftBar();
        Provider.of<ProfileProvider>(context, listen: false)
            .changeProfileId(widget.userId.id);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DynamicTextHighlighting(
            text: widget.userId.data()["full_name"],
            highlights: [widget.searchText],
            caseSensitive: false,
            color: Colors.green[300],
            style: TextStyle(
                decoration:
                    hover ? TextDecoration.underline : TextDecoration.none,
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          ),
          SizedBox(
            width: 3.0,
          ),
          Container(
            height: h * .017,
            width: h * .017,
            child: Image.asset("./assets/images/check (2).png"),
          )
        ],
      ).xShowPointerOnHover,
    );
  }

  Widget fullNameReader(bool hover) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0.0,
                child: readerProfile(
                    widget.userId.data()["image"],
                    widget.userId.data()["full_name"],
                    widget.userId.data()["currentLocation"],
                    widget.userId.data()["homeTownLocation"],
                    currentUser.uid),
              );
            });
      },
      child: Text(
        widget.userId.data()["full_name"],
        style: TextStyle(
          decoration: hover ? TextDecoration.underline : TextDecoration.none,
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          fontFamily: "SPProtext",
        ),
      ),
    );
  }

  Widget deleteButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      child: Center(
        child: Icon(
          LineAwesomeIcons.times_circle,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      decoration: BoxDecoration(
          color: hover ? Colors.red[500] : Colors.red[700],
          borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget readerProfile(String image, String name, String currentLocation,
      String homeLocation, String userId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .6,
      width: w * .25,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * .07,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: HoverWidget(
                      child: deleteButtonWidget(false),
                      hoverChild: deleteButtonWidget(true),
                      onHover: (onHover) {},
                    ),
                  ),
                ],
              ),
            ),
            ProfileImageWidget(
              profileImage: image,
              userId: userId,
            ),
            SizedBox(
              height: h * .02,
            ),
            Container(
              width: w * .25,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SPProtext",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * .02,
            ),
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                "./assets/icons/placeholder.svg",
                height: 25.0,
                width: 25.0,
                color: Colors.grey[600],
              ),
              label: Text(
                currentLocation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                  fontFamily: "SPProtext",
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                "./assets/icons/placeholder.svg",
                height: 25.0,
                width: 25.0,
                color: Colors.grey[600],
              ),
              label: Text(
                homeLocation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                  fontFamily: "SPProtext",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).postViewWrittenBy)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        width: w * .4,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.white),
        child: Row(
          children: [
            Container(
              height: h * .065,
              width: h * .065,
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
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(widget.userId.data()["image"]).image),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.userId.data()["kind"] == "Journalist"
                        ? HoverWidget(
                            child: fullNameWidget(false),
                            hoverChild: fullNameWidget(true),
                            onHover: (onHover) {},
                          )
                        : HoverWidget(
                            child: fullNameReader(false),
                            hoverChild: fullNameReader(true),
                            onHover: (onHover) {},
                          ),
                    SizedBox(
                      height: 5.0,
                    ),
                    widget.whereField == 'journalistKind'
                        ? Row(
                            children: [
                              widget.whereField == 'journalistKind'
                                  ? DynamicTextHighlighting(
                                      text: widget.userId
                                          .data()["journalistKind"],
                                      highlights: [widget.searchText],
                                      caseSensitive: false,
                                      color: Colors.green[300],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "SPProtext"),
                                    )
                                  : Text(
                                      "${widget.userId.data()["journalistKind"]}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "SPProtext"),
                                    ),
                              Text(
                                " - ${widget.userId.data()["workspace"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "SPProtext"),
                              ),
                            ],
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.userId.data()["currentLocation"],
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12.0,
                          fontFamily: "SPProtext"),
                    ),
                  ],
                ),
                widget.userId.id != currentUser.uid
                    ? AddButton(
                        userId: widget.userId.id,
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      )
              ],
            )),
          ],
        ),
      ).xShowPointerOnHover,
    );
  }

  @override
  void initState() {
    checkSubscribe(widget.userId.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
        child: userWidget(false),
        hoverChild: userWidget(true),
        onHover: (event) {});
  }
}

class SearchUsersKeyExtent extends StatefulWidget {
  final String title;

  final String whereString;

  const SearchUsersKeyExtent({
    Key key,
    this.title,
    this.whereString,
  }) : super(key: key);

  @override
  _SearchUsersKeyExtentState createState() => _SearchUsersKeyExtentState();
}

class _SearchUsersKeyExtentState extends State<SearchUsersKeyExtent> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool seeMore = false;
  List<QueryDocumentSnapshot> results;
  ScrollController scrollController = ScrollController();
  ScrollController loadingScrollController = ScrollController();
  FunctionsServices functionsServices = FunctionsServices();
  SearchWidgets searchWidgets = SearchWidgets();
  AlertWidgets alertWidgets = AlertWidgets();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String searchTyping =
        Provider.of<SearchDetailsProvider>(context).searchTyping;
    return Center(
      child: Container(
        width: w * .63,
        margin: EdgeInsets.only(left: 10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.only(top: h * .05),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    controller: loadingScrollController,
                    itemCount: seeMore ? 8 : 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white),
                          child: searchUserLoading(h, w),
                        ),
                      );
                    },
                  ),
                );
              }
              results = snapshot.data.docs;

              results.retainWhere(
                (DocumentSnapshot doc) => doc
                    .data()[widget.whereString]
                    .toString()
                    .toLowerCase()
                    .contains(
                      searchTyping.toLowerCase(),
                    ),
              );

              if (snapshot.hasError) {
                return alertWidgets.errorWidget(
                    h, w, S.of(context).noContentAvailable);
              }

              if (results.isEmpty) {
                return alertWidgets.emptyWidget(
                    h, w, S.of(context).noTelltruefound);
              }

              return results.length > 0
                  ? Container(
                      width: w * .63,
                      height: h * .83,
                      child: Column(
                        children: [
                          results.isEmpty
                              ? Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                              : Directionality(
                                  textDirection:
                                      intl.Bidi.detectRtlDirectionality(
                                              S.of(context).telltrueUser)
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${functionsServices.dividethousand(results.length)} ${S.of(context).result}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontFamily: "SPProtext"),
                                        )
                                      ],
                                    ),
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
                                  QueryDocumentSnapshot user = results[index];
                                  return user
                                          .data()[widget.whereString]
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchTyping.toLowerCase())
                                      ? Center(
                                          child: FollowButton(
                                            whereField: widget.whereString,
                                            index: index,
                                            userId: user,
                                            searchText: searchTyping,
                                          ),
                                        )
                                      : Container(height: 0.0, width: 0.0);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    );
            }),
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  final String userId;

  const AddButton({Key key, this.userId}) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  bool isFollow = false;

  Future<void> checkSubscribe() async {
    DocumentSnapshot user = await users
        .doc(currentUser.uid)
        .collection("Subscriptions")
        .doc(widget.userId)
        .get();
    setState(() {
      if (user.exists) {
        isFollow = true;
      } else {
        isFollow = false;
      }
    });
  }

  @override
  void initState() {
    checkSubscribe();
    super.initState();
  }

  void unFollow(String profileName, String profileImage, String uid) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                width: w * .35,
                height: h * .25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: h * .03,
                    ),
                    Container(
                      height: h * .08,
                      width: h * .08,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: Image.network(profileImage).image,
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      height: h * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: S.of(context).profileUnfollowRequest,
                              style: TextStyle(fontSize: 14.0),
                              children: [
                                TextSpan(
                                  text: "  " + profileName + " ?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: h * .07,
                      width: w * .35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              height: h * 0.05,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Center(
                                child: Text(
                                  S.of(context).profileUnfolowButton,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.red[300],
                              ),
                            ),
                            onTap: () async {
                              setState(() {
                                isFollow = false;
                              });

                              await users
                                  .doc(currentUser.uid)
                                  .collection("Subscriptions")
                                  .doc(uid)
                                  .delete();
                              await users
                                  .doc(uid)
                                  .collection("Subscribers")
                                  .doc(currentUser.uid)
                                  .delete();

                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            child: Container(
                              height: h * 0.05,
                              width: w * 0.12,
                              child: Center(
                                child: Text(
                                  S.of(context).cancelButton,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontFamily: "SPProtext"),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.cyan[600],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

  Widget subscribeIconWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      height: !isFollow ? h * 0.05 : h * 0.06,
      width: !isFollow ? w * 0.08 : h * 0.06,
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
      child: !isFollow
          ? Center(
              child: Text(
                S.of(context).profileFollow,
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[800],
                    fontFamily: "SPProtext"),
              ),
            )
          : Tooltip(
              message: S.of(context).profileUnfolowButton,
              child: Center(
                child: Icon(
                  LineAwesomeIcons.user_check,
                  color: Colors.blue,
                ),
              ),
            ),
      decoration: isFollow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.blue),
              color: Colors.white,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.grey[400]),
              color: hover ? Colors.grey[200] : Colors.white,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data.data();
          return InkWell(
              child: HoverWidget(
                  child: subscribeIconWidget(false),
                  hoverChild: subscribeIconWidget(true),
                  onHover: (onHover) {}),
              onTap: () async {
                DocumentSnapshot user = await users.doc(currentUser.uid).get();
                DocumentSnapshot doc = await users.doc(widget.userId).get();
                QuerySnapshot querySnapshot = await users
                    .doc(widget.userId)
                    .collection("Pub")
                    .where("postKind",
                        whereNotIn: ["inPic", "broadcasting"]).get();
                QuerySnapshot querySnapshotWatch = await users
                    .doc(widget.userId)
                    .collection("Pub")
                    .where("postKind",
                        whereIn: ["inPic", "broadcasting"]).get();

                if (isFollow == false) {
                  setState(() {
                    isFollow = true;
                  });
                  users
                      .doc(currentUser.uid)
                      .collection("Subscriptions")
                      .doc(widget.userId)
                      .set({
                    "name": doc.data()["full_name"],
                    "image": doc.data()["image"],
                    "location": doc.data()["location"],
                  });
                  users
                      .doc(widget.userId)
                      .collection("Subscribers")
                      .doc(currentUser.uid)
                      .set({
                    "name": user.data()["full_name"],
                    "image": user.data()["image"],
                    "location": user.data()["location"],
                  });
                  users
                      .doc(widget.userId)
                      .collection("Notifications")
                      .doc(currentUser.uid)
                      .set({
                    "seen": false,
                    "postKind": "subscribe",
                    "userName": user.data()["full_name"],
                    "timeAgo": DateTime.now(),
                  });
                  for (int i = 0; i < querySnapshot.docs.length; i++) {
                    users
                        .doc(currentUser.uid)
                        .collection("Home")
                        .doc("${widget.userId}==${querySnapshot.docs[i].id}")
                        .set({
                      "postKind": querySnapshot.docs[i].data()["postKind"],
                      "timeAgo": querySnapshot.docs[i].data()["timeAgo"],
                      "topic": querySnapshot.docs[i].data()["topic"],
                    });
                  }
                  for (int i = 0; i < querySnapshotWatch.docs.length; i++) {
                    users
                        .doc(currentUser.uid)
                        .collection("Watch")
                        .doc(
                            "${widget.userId}==${querySnapshotWatch.docs[i].id}")
                        .set({
                      "postKind": querySnapshotWatch.docs[i].data()["postKind"],
                      "timeAgo": querySnapshotWatch.docs[i].data()["timeAgo"],
                      "topic": querySnapshotWatch.docs[i].data()["topic"],
                      "mediaUrl": querySnapshotWatch.docs[i].data()["mediaUrl"],
                    });
                  }
                } else {
                  unFollow(data["full_name"], data["image"], widget.userId);
                }
              });
        }

        return Container(
          height: 0.0,
          width: 0.0,
        );
      },
    );
  }
}
