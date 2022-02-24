import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/services/provider/message_list_provider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:intl/intl.dart' as intl;

class MenuButtonWidget extends StatefulWidget {
  final receiverName;
  const MenuButtonWidget({Key key, this.receiverName}) : super(key: key);

  @override
  _MenuButtonWidgetState createState() => _MenuButtonWidgetState();
}

class _MenuButtonWidgetState extends State<MenuButtonWidget> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;

  bool isBlock = false;

  Future getThelastUser() async {
    QuerySnapshot doc = await users
        .doc(currentUser.uid)
        .collection("Chat")
        .orderBy("lastTime", descending: true)
        .get();
    Provider.of<MessageProvider>(context, listen: false)
        .changeMessageId(doc.docs.first.id);
  }

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

  Widget blockRequestButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.05,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: Text(
          S.of(context).blockButton,
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

  void deleteConversationConfirm(BuildContext context, String userId) {
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
              height: h * .27,
              width: w * .3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    width: w * .3,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Center(
                      child: Text(
                        S.of(context).suggestionChatDeleteConversation,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SPProtext"),
                      ),
                    ),
                  ),
                  Container(
                    width: w * .3,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Center(
                      child: Text(
                        S.of(context).suggestionChatDeleteConversationDescrip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14.0,
                            fontFamily: "SPProtext"),
                      ),
                    ),
                  ),
                  Container(
                    height: h * .08,
                    width: w * .27,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: HoverWidget(
                            child: requestConfirmButton(false),
                            hoverChild: requestConfirmButton(true),
                            onHover: (onHover) {},
                          ),
                          onTap: () async {
                            QuerySnapshot msg = await users
                                .doc(currentUser.uid)
                                .collection("Chat")
                                .doc(userId)
                                .collection("Messages")
                                .get();
                            QuerySnapshot media = await users
                                .doc(currentUser.uid)
                                .collection("Chat")
                                .doc(userId)
                                .collection("Media")
                                .get();

                            msg.docs.forEach((element) {
                              element.reference.delete();
                            });

                            media.docs.forEach((element) {
                              element.reference.delete();
                            });

                            Provider.of<MessageListProvider>(context,
                                    listen: false)
                                .addMessageList(4);
                            await users
                                .doc(currentUser.uid)
                                .collection("Chat")
                                .doc(userId)
                                .delete();

                            getThelastUser();
                            //deleteFileFromFirebase(userId);
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
  }

  void blockConfirm(String userId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: w * .3,
              height: h * .27,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    width: w * .3,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Center(
                      child: Text(
                        S.of(context).suggestionChatBlockMsgRequest,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SPProtext"),
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection:
                        intl.Bidi.detectRtlDirectionality(S.of(context).message)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    child: Container(
                      width: w * .3,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Center(
                        child: Text(
                          "${S.of(context).suggestionChatBlockMsgDescrip1} ${widget.receiverName}. ${S.of(context).suggestionChatBlockMsgDescrip2}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14.0,
                              fontFamily: "SPProtext"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: h * .05,
                    width: w * .3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: HoverWidget(
                              child: blockRequestButton(false),
                              hoverChild: blockRequestButton(true),
                              onHover: (onHover) {}),
                          onTap: () async {
                            await users
                                .doc(currentUser.uid)
                                .collection("Block")
                                .doc(userId)
                                .set(
                              {
                                "blockedBy": currentUser.uid,
                              },
                              SetOptions(merge: true),
                            );

                            await users
                                .doc(userId)
                                .collection("Block")
                                .doc(currentUser.uid)
                                .set(
                              {
                                "blockedBy": currentUser.uid,
                              },
                              SetOptions(merge: true),
                            );
                            Provider.of<MessageProvider>(context, listen: false)
                                .checkBlock();
                            Provider.of<MessageProvider>(context, listen: false)
                                .checkBlockUser();
                            Provider.of<MessageProvider>(context, listen: false)
                                .blockConfirm();

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
  }

  Widget deleteChat(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Tooltip(
      message: S.of(context).suggestionChatDeleteConversation,
      child: Container(
        height: h * .08,
        width: h * .08,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: !hover ? Colors.red[300] : Colors.red[400]),
        child: Center(
          child: Icon(
            LineAwesomeIcons.trash,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget blockUser(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Tooltip(
      message: S.of(context).blockButton,
      child: Container(
        height: h * .08,
        width: h * .08,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hover ? Colors.grey[300] : Colors.grey[200]),
        child: Center(
          child: Icon(
            LineAwesomeIcons.ban,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<MessageProvider>(context).userId;
    bool isBlock = Provider.of<MessageProvider>(context).isBlock;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              deleteConversationConfirm(context, userId);
            },
            child: HoverWidget(
              child: deleteChat(false),
              hoverChild: deleteChat(true),
              onHover: (onHover) {},
            ),
          ),
          !isBlock
              ? InkWell(
                  onTap: () {
                    blockConfirm(userId);
                  },
                  child: HoverWidget(
                    child: blockUser(false),
                    hoverChild: blockUser(true),
                    onHover: (onHover) {},
                  ),
                )
              : blockUser(false)
        ],
      ),
    );
  }
}
