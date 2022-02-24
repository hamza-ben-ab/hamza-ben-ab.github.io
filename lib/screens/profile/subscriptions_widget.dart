import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/loading_widget/invite_item_loading.dart';
import 'package:uy/screens/profile/profile_image_widget.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:intl/intl.dart' as intl;

class SubscriptionsWidget extends StatefulWidget {
  const SubscriptionsWidget({Key key}) : super(key: key);

  @override
  _SubscriptionsWidgetState createState() => _SubscriptionsWidgetState();
}

class _SubscriptionsWidgetState extends State<SubscriptionsWidget> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  ScrollController subscriptionListController = ScrollController();
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  Function cancelFunction() {
    Navigator.of(context).pop();
    return null;
  }

  Widget cancelButton() {
    double h = MediaQuery.of(context).size.height;
    return HoverWidget(
        child:
            createPostAllFunctions.cancelButtonWidget(false, h, cancelFunction),
        hoverChild:
            createPostAllFunctions.cancelButtonWidget(true, h, cancelFunction),
        onHover: (onHover) {});
  }

  void showSubscriptions(String userId, String collection, String title) {
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
              height: h * .8,
              width: w * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                width: w * .4,
                height: h * .8,
                child: Column(
                  children: [
                    Container(
                      height: h * .1,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: h * .1,
                            child: Center(
                              child: Text(
                                title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SPProtext",
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          cancelButton(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: w * .4,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(userId)
                              .collection(collection)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                itemCount: 6,
                                itemBuilder: (BuildContext context, int index) {
                                  return loadingInviteItems(h, w);
                                },
                              );
                            }
                            if (snapshot.data.docs.isEmpty) {
                              return Center();
                            }

                            return AnimationLimiter(
                              child: Scrollbar(
                                controller: subscriptionListController,
                                radius: Radius.circular(20.0),
                                isAlwaysShown: true,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  controller: subscriptionListController,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(seconds: 2),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: SlideAnimation(
                                          child: SubscriptionsItems(
                                              a: snapshot.data.docs[index].id),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * .01,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget subscriptionWidget(
      bool hover, String collection, String title, String userId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        showSubscriptions(userId, collection, title);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: h * .06,
          width: w * .12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black),
            color: hover ? Colors.grey[200] : Colors.white,
          ),
          child: Row(
            children: [
              Text(
                "$title",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: "SPProtext",
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: users.doc(userId).collection(collection).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      "0",
                    );
                  }
                  return Center(
                    child: Text(
                      "${snapshot.data.docs.length}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SPProtext",
                      ),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Container(
      height: h * .12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HoverWidget(
            child: subscriptionWidget(
                false, "Subscriptions", S.of(context).profileFollowing, userId),
            hoverChild: subscriptionWidget(
                true, "Subscriptions", S.of(context).profileFollowing, userId),
            onHover: (onHover) {},
          ),
          SizedBox(
            width: w * .02,
          ),
          HoverWidget(
            child: subscriptionWidget(
                false, "Subscribers", S.of(context).profileFollowers, userId),
            hoverChild: subscriptionWidget(
                true, "Subscribers", S.of(context).profileFollowers, userId),
            onHover: (onHover) {},
          ),
        ],
      ),
    );
  }
}

class SubscriptionsItems extends StatefulWidget {
  final String a;

  const SubscriptionsItems({Key key, this.a}) : super(key: key);
  @override
  _SubscriptionsItemsState createState() => _SubscriptionsItemsState();
}

class _SubscriptionsItemsState extends State<SubscriptionsItems> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  String document;

  Widget deleteButtonWidget() {
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
          color: Colors.red[700], borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget readerProfile(String image, String name, String currentLocation,
      String homeLocation, String userId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .6,
      width: w,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: deleteButtonWidget(),
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
              width: w,
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

  @override
  void initState() {
    super.initState();
    document = widget.a;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(document).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return ListTile(
              leading: Container(
                height: h * .055,
                width: h * .055,
                decoration: BoxDecoration(
                  borderRadius: intl.Bidi.detectRtlDirectionality(
                          S.of(context).profileFollowing)
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
                    image: Image.network(data["image"]).image,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: data["kind"] == "Journalist"
                        ? () {
                            Provider.of<HideLeftBarProvider>(context,
                                    listen: false)
                                .closeleftBar();
                            Provider.of<CenterBoxProvider>(context,
                                    listen: false)
                                .changeCurrentIndex(7);
                            Provider.of<ProfileProvider>(context, listen: false)
                                .changeProfileId(currentUser.uid);
                            Navigator.of(context).pop();
                          }
                        : () {
                            Navigator.of(context).pop();
                            showModalBottomSheet(
                                context: context,
                                builder: (builder) {
                                  return readerProfile(
                                      data["image"],
                                      data["full_name"],
                                      data["location"],
                                      data["homeLocation"],
                                      currentUser.uid);
                                });
                          },
                    child: HoverWidget(
                        child: Text(
                          data["full_name"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SPProtext"),
                        ),
                        hoverChild: Text(
                          data["full_name"],
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SPProtext"),
                        ),
                        onHover: (onHover) {}),
                  ),
                  SizedBox(
                    width: 7.0,
                  ),
                  Container(
                    height: h * .020,
                    width: h * .020,
                    child: Image.asset("./assets/images/check (2).png"),
                  )
                ],
              ),
              subtitle: Text(
                data["currentLocation"],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontFamily: "SPProtext"),
              ),
              trailing: InkWell(
                onTap: () async {},
                child: Container(
                  height: h * .045,
                  width: w * .07,
                  decoration: BoxDecoration(),
                ),
              ),
            );
          }
          return loadingInviteItems(h, w);
        });
  }
}
