import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/services/provider/attachementProvider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:uy/services/time_ago.dart';
import 'package:intl/intl.dart' as intl;

class MessageItemWidget extends StatefulWidget {
  final String userMessage;
  final int index;
  const MessageItemWidget({Key key, this.userMessage, this.index})
      : super(key: key);

  @override
  _MessageItemWidgetState createState() => _MessageItemWidgetState();
}

class _MessageItemWidgetState extends State<MessageItemWidget> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  Time timeCal = new Time();

  void updateNotificationCount() async {
    await users
        .doc(currentUser.uid)
        .collection("Chat")
        .doc(widget.userMessage)
        .update({
      "new message": false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.userMessage).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return InkWell(
              onTap: () {
                Provider.of<MessageProvider>(context, listen: false)
                    .changeMessageId(widget.userMessage);

                updateNotificationCount();
                Provider.of<AttachementMessageProvider>(context, listen: false)
                    .falseAtachement();
                Provider.of<MessageProvider>(context, listen: false)
                    .checkBlock();
                Provider.of<MessageProvider>(context, listen: false)
                    .checkBlockUser();
                //Provider.of<MessageProvider>(context, listen: false).blockConfirm();
              },
              child: HoverWidget(
                child: MessageListItem(
                  hover: false,
                  data: data,
                  userId: widget.userMessage,
                ),
                hoverChild: MessageListItem(
                  hover: true,
                  data: data,
                  userId: widget.userMessage,
                ),
                onHover: (onHover) {},
              ),
            );
          }
          return Container(
            height: 0.0,
            width: 0.0,
            color: Colors.white,
          );
        });
  }
}

class MessageListItem extends StatefulWidget {
  final bool hover;
  final Map<String, dynamic> data;
  final String userId;

  const MessageListItem({Key key, this.hover, this.data, this.userId})
      : super(key: key);

  @override
  _MessageListItemState createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  Time timeCal = new Time();
  Map<String, dynamic> data;
  String userId;

  @override
  void initState() {
    data = widget.data;
    userId = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 8.0, left: 3.0, right: 15.0),
      padding: EdgeInsets.only(left: 8.0, right: 5.0),
      height: h * .09,
      width: w * .2,
      decoration: BoxDecoration(
        color: widget.hover ? Colors.grey[300] : Colors.grey[100],
        //border: Border.all( color: widget.hover ? Colors.blue : Colors.grey[400],),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(children: [
        Container(
          height: h * .09,
          width: h * .07,
          child: Center(
            child: Container(
              height: h * .065,
              width: h * .065,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.network(data["image"]).image,
                    fit: BoxFit.cover),
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
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Container(
            height: h * .09,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: h * .04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data["full_name"]
                            .toString()
                            .split(" ")
                            .sublist(0, 2)
                            .join(" "),
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "SPProtext"),
                      ),
                      Container(
                        height: h * .03,
                        child: Center(
                          child: FutureBuilder<DocumentSnapshot>(
                              future: users
                                  .doc(currentUser.uid)
                                  .collection("Chat")
                                  .doc(userId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    timeCal.timeAgo(
                                      snapshot.data.data()["lastTime"].toDate(),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.grey[800],
                                        fontFamily: "SPProtext"),
                                  );
                                }
                                return Container(
                                  height: 0.0,
                                  width: 0.0,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * .01,
                ),
                Expanded(
                  child: Container(
                    width: w * .2,
                    child: FutureBuilder<DocumentSnapshot>(
                      future: users
                          .doc(currentUser.uid)
                          .collection("Chat")
                          .doc(userId)
                          .get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data.data();
                          var docKind = data["messageKind"] == "text"
                              ? "text"
                              : data["messageKind"] == "media" &&
                                      imagesFormat.contains(data["extension"])
                                  ? "image"
                                  : data["messageKind"] == "media" &&
                                          videoFormat
                                              .contains(data["extension"])
                                      ? "video"
                                      : "file";
                          var docType = data["messageType"];
                          var docSend = data["sendBy"];
                          var newMessage = data["new message"];

                          return Text(
                            docKind == "text"
                                ? data["lastMessage"].toString().length < 30
                                    ? data["lastMessage"].toString()
                                    : data["lastMessage"]
                                            .toString()
                                            .substring(0, 30) +
                                        "..."
                                : docType == "Sender"
                                    ? "You send $docKind"
                                    : "$docSend send $docKind",
                            textDirection: intl.Bidi.detectRtlDirectionality(
                                    S.of(context).message)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontFamily: "SPProtext",
                              fontWeight: docType == "Receiver" && newMessage
                                  ? FontWeight.w800
                                  : FontWeight.normal,
                            ),
                          );
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
