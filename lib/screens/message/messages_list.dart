import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/comment_loading.dart';
import 'package:uy/screens/message/message_list_tem.dart';
import 'package:uy/services/provider/message_list_provider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:intl/intl.dart' as intl;

class MessagesList extends StatefulWidget {
  final bool empty;
  const MessagesList({Key key, this.empty}) : super(key: key);
  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList>
    with TickerProviderStateMixin {
  CollectionReference journalists =
      FirebaseFirestore.instance.collection('Users');
  bool searchDisplay = false;
  User currentUser = FirebaseAuth.instance.currentUser;
  Time timeCal = new Time();
  ScrollController messageListController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int listLength = Provider.of<MessageListProvider>(context).list;
    return Directionality(
      textDirection: intl.Bidi.detectRtlDirectionality(S.of(context).account)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        width: w * .23,
        decoration: BoxDecoration(
          border: Border.all(
              color: !widget.empty ? Colors.grey[400] : Colors.transparent),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: h * .07,
              width: w * .23,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).message,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        fontFamily: "SPProtext"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                    stream: journalists
                        .doc(currentUser.uid)
                        .collection("Chat")
                        .orderBy("lastTime", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: h * .8,
                          width: w * .23,
                          child: ListView.builder(
                            itemCount: 8,
                            itemBuilder: (BuildContext context, int index) {
                              return loadingCommentPost(h, w);
                            },
                          ),
                        );
                      }
                      if (snapshot.data.docs.isEmpty) {
                        return Center(
                          child: Container(
                            height: h * .86,
                            width: w * .23,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: !widget.empty
                                      ? Colors.grey[300]
                                      : Colors.transparent),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).messageNoMessageYet,
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "SPProtext"),
                                ),
                                SizedBox(
                                  height: h * .01,
                                ),
                                Text(
                                  S.of(context).messageStartMessage,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Scrollbar(
                        controller: messageListController,
                        isAlwaysShown: true,
                        radius: Radius.circular(20.0),
                        child: AnimationLimiter(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            controller: messageListController,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(seconds: 2),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: SlideAnimation(
                                    child: MessageItemWidget(
                                      index: index,
                                      userMessage: snapshot.data.docs[index].id,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
