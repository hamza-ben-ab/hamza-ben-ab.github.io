import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/services/provider/profile_image_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:uy/widget/show_video.dart';

class PictureView extends StatefulWidget {
  final int current;
  final String imageUrl;
  final String userId;
  final String id;
  final bool edit;
  final String postKind;
  final Function refresh;
  final bool video;

  const PictureView({
    Key key,
    this.current,
    this.imageUrl,
    this.userId,
    this.id,
    this.edit,
    this.refresh,
    this.postKind,
    @required this.video,
  }) : super(key: key);
  @override
  _PictureViewState createState() => _PictureViewState();
}

class _PictureViewState extends State<PictureView> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int currentPageValue = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  String id;
  int currentIndex;
  bool scroll = false;
  int currentPage = 0;
  bool expanded = false;
  int count = 0;
  Time timeCal = new Time();
  Tween<double> valueTween;
  String image;
  bool showPicOption = false;
  ScrollController scrollController = ScrollController();

  Widget requestConfirmButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.05,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: Text(
          S.of(context).confirmButton,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            fontFamily: "SPProtext",
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? buttonColorHover : buttonColor,
      ),
    );
  }

  Widget requestCancelButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.05,
      width: w * 0.12,
      child: Center(
        child: Text(
          S.of(context).cancelButton,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontFamily: "SPProtext",
          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[400] : Colors.grey[300]),
    );
  }

  Future<void> deleteFileFromFirebase(String urlFile, String fileTime) async {
    String fileName = urlFile.replaceAll("/o/", "*");
    fileName = fileName.replaceAll("?", "*");
    fileName = fileName.split("*")[1];

    firebase_storage.FirebaseStorage.instance
        .ref("${currentUser.uid}/")
        .child("Pictures/$fileTime")
        .child("$fileName")
        .delete()
        .then((_) => print('Successfully deleted $fileName storage item'));
  }

  Widget setAsProfileImageWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        await users.doc(currentUser.uid).update({
          "image": widget.imageUrl,
        });
        Provider.of<ProfileImageProvider>(context, listen: false)
            .changeProfileImage(
          widget.imageUrl,
        );

        showPicOption = false;
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        width: w * .12,
        height: h * .05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[300] : Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              LineAwesomeIcons.user_circle,
              color: accentColor,
              size: 20.0,
            ),
            Text(
              S.of(context).pictureSetAsProfilePic,
              style: TextStyle(
                  color: Colors.black, fontSize: 12.0, fontFamily: "SPProtext"),
            ),
          ],
        ),
      ),
    );
  }

  Widget deletePicture(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  width: w * .3,
                  height: h * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: h * .03,
                      ),
                      Text(
                        S.of(context).pictureDeleteRequest,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        height: h * .07,
                        width: w * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: HoverWidget(
                                  child: requestConfirmButton(false),
                                  hoverChild: requestConfirmButton(true),
                                  onHover: (onHover) {}),
                              onTap: () async {
                                await users
                                    .doc(currentUser.uid)
                                    .collection("Pictures")
                                    .doc(widget.id)
                                    .delete();
                                deleteFileFromFirebase(
                                  widget.imageUrl,
                                  widget.id,
                                );

                                widget.refresh();
                                setState(() {
                                  showPicOption = false;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              child: HoverWidget(
                                  child: requestCancelButton(false),
                                  hoverChild: requestCancelButton(true),
                                  onHover: (onHover) {}),
                              onTap: () {
                                setState(() {
                                  showPicOption = false;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        width: w * .12,
        height: h * .05,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.grey[200]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              LineAwesomeIcons.trash,
              color: accentColor,
              size: 20.0,
            ),
            Text(
              S.of(context).pictureDelete,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontFamily: "SPProtext",
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    id = widget.id;
    currentIndex = widget.current;
    image = widget.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        child: Stack(
          children: [
            !widget.video
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: Image.network(
                          image,
                        ).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ShowVideo(
                      videoUrl: widget.imageUrl,
                    ),
                  ),
            widget.video
                ? Center(
                    child: Icon(
                      LineAwesomeIcons.play,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  )
                : Container(),
            (currentUser.uid == userId) && widget.edit
                ? Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: InkWell(
                      child: Container(
                        child: Center(
                            child: Icon(
                          LineAwesomeIcons.pen,
                          color: Colors.white,
                        )),
                        height: h * .04,
                        width: h * .04,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          showPicOption = !showPicOption;
                        });
                      },
                    ),
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  ),
            showPicOption
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HoverWidget(
                          child: setAsProfileImageWidget(false),
                          hoverChild: setAsProfileImageWidget(true),
                          onHover: (onHover) {},
                        ),
                        HoverWidget(
                            child: deletePicture(false),
                            hoverChild: deletePicture(true),
                            onHover: (onHover) {})
                      ],
                    ),
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  )
          ],
        ),
        onTap: () async {
          Provider.of<ReadPostProvider>(context, listen: false)
              .changePostId(userId, widget.id);
          widget.edit
              ? showDialog(
                  context: (context),
                  builder: (context) {
                    return ShowCustomDialogBox(
                      image: image,
                      index: widget.current,
                    );
                  },
                )
              : showDialog(
                  context: (context),
                  builder: (context) {
                    return ShowPostDetails(
                      id: widget.id,
                      postKind: widget.postKind,
                    );
                  },
                );
        },
      ),
    );
  }
}

class ShowCustomDialogBox extends StatefulWidget {
  final int index;
  final String image;

  const ShowCustomDialogBox({Key key, this.image, this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowCustomDialogBoxState();
}

class ShowCustomDialogBoxState extends State<ShowCustomDialogBox>
    with SingleTickerProviderStateMixin {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AnimationController controller;
  Animation<double> scaleAnimation;
  String image;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  PageController pageController = PageController();

  cancelFunction() {
    Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
    image = widget.image;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  width: w,
                  height: h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200].withOpacity(0.2),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pictures")
                          .orderBy("timeAgo", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) => Container(
                              width: w,
                              height: h * .93,
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Center(
                                child: Image.network(
                                    snapshot.data.docs[index]["mediaUrl"]),
                              ),
                            ),
                          );
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: cancelButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
