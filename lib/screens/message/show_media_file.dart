import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/message/video_view_chat.dart';
import 'package:uy/services/provider/media_message_provider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:uy/widget/show_video.dart';

class ShowMediaWidget extends StatefulWidget {
  final int index;
  final String image;
  final String mediaExtension;

  const ShowMediaWidget({
    Key key,
    this.image,
    this.index,
    this.mediaExtension,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowMediaWidgetState();
}

class ShowMediaWidgetState extends State<ShowMediaWidget>
    with SingleTickerProviderStateMixin {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AnimationController controller;
  Animation<double> scaleAnimation;
  String image;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  PageController pageController = PageController();

  User currentUser = FirebaseAuth.instance.currentUser;

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

  Widget bottomListItem(int index, String extension, String message) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int currentIndex = Provider.of<MediaMessageProvider>(context).index;
    return Stack(
      children: [
        imagesFormat.contains(extension)
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                height: h * .1,
                width: w * .08,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(
                      message,
                    ).image,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              )
            : Stack(alignment: Alignment.center, children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  height: h * .1,
                  width: w * .08,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: ShowVideo(
                      videoUrl: message,
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    LineAwesomeIcons.play,
                    size: 30.0,
                    color: Colors.white,
                  ),
                )
              ]),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          height: h * .1,
          width: w * .08,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.transparent
                : Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ],
    );
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
    String userId = Provider.of<MessageProvider>(context).userId;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: Colors.grey[200].withOpacity(0.2),
                border: Border.all(color: Colors.transparent),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: users
                      .doc(currentUser.uid)
                      .collection("Chat")
                      .doc(userId)
                      .collection("Media")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          PageView.builder(
                              controller: pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                String extension =
                                    snapshot.data.docs[index]["extension"];
                                String message =
                                    snapshot.data.docs[index]["message"];
                                return Container(
                                  width: w,
                                  height: h * .93,
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      imagesFormat.contains(extension)
                                          ? Container(
                                              height: h * .7,
                                              width: w * .7,
                                              child: Image.network(
                                                message,
                                              ),
                                            )
                                          : videoFormat.contains(extension)
                                              ? Container(
                                                  height: h * .7,
                                                  width: w * .7,
                                                  child: ClipRRect(
                                                    child: VideoViewChat(
                                                      videoUrl: message,
                                                      isFile: false,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                    ],
                                  ),
                                );
                              }),
                          Positioned(
                            top: 10.0,
                            right: 10.0,
                            child: cancelButton(),
                          ),
                          Positioned(
                              bottom: 10.0,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                height: h * .1,
                                width: w,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: users
                                        .doc(currentUser.uid)
                                        .collection("Chat")
                                        .doc(userId)
                                        .collection("Media")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                          height: 0.0,
                                          width: 0.0,
                                        );
                                      }
                                      return ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String extension = snapshot
                                              .data.docs[index]["extension"];
                                          String message = snapshot
                                              .data.docs[index]["message"];
                                          return InkWell(
                                            onTap: () {
                                              Provider.of<MediaMessageProvider>(
                                                      context,
                                                      listen: false)
                                                  .changeIndexImage(index);
                                              pageController.jumpToPage(index);
                                            },
                                            child: bottomListItem(
                                              index,
                                              extension,
                                              message,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ))
                        ],
                      );
                    }
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
