import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:flutter/rendering.dart';
import 'package:uy/screens/posts/other_post_view/poll_widget.dart';
import 'package:uy/screens/posts/show_event/event_view_post.dart';
import 'package:uy/screens/posts/show_personnality/personnality_profile_details.dart';
import 'package:uy/screens/posts/general_post_view/post_details_widget.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';
//import 'package:intl/intl.dart' as intl;

class ShowPostDetails extends StatefulWidget {
  final String id;
  final String postKind;
  final bool views;
  const ShowPostDetails({Key key, this.id, this.postKind, this.views})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowPostDetailsState();
}

class ShowPostDetailsState extends State<ShowPostDetails>
    with SingleTickerProviderStateMixin {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AnimationController controller;
  Animation<double> scaleAnimation;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  FunctionsServices functionsServices = FunctionsServices();
  ScrollController pollController = ScrollController();

  cancelFunction() {
    Navigator.of(context).pop();
  }

  Widget cancelButton() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return HoverWidget(
        child: createPostAllFunctions.closeNewsButtonWidget(
            false, h, w, S.of(context).closeButton, cancelFunction),
        hoverChild: createPostAllFunctions.closeNewsButtonWidget(
            true, h, w, S.of(context).closeButton, cancelFunction),
        onHover: (onHover) {});
  }

  @override
  void initState() {
    super.initState();

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
    String userId = Provider.of<ReadPostProvider>(context).userId;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  width: w,
                  height: h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200].withOpacity(0.2),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: widget.postKind == "event"
                      ? Center(
                          child: EventViewPost(
                            userId: userId,
                            id: widget.id,
                          ),
                        )
                      : widget.postKind == "personality"
                          ? GlobalPersonnalityProfil(
                              userId: userId,
                              id: widget.id,
                            )
                          : widget.postKind == "poll"
                              ? Center(
                                  child: SingleChildScrollView(
                                    controller: pollController,
                                    child: Container(
                                      width: w * .4,
                                      height: h * .95,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.white),
                                      child: PollWidget(
                                        userId: userId,
                                        id: widget.id,
                                      ),
                                    ),
                                  ),
                                )
                              : PostDetailsWidget(
                                  userId: userId,
                                  doc: widget.id,
                                  views: widget.views,
                                ),
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
