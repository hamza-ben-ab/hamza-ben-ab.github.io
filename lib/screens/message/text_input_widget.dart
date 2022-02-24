import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/services/provider/attachementProvider.dart';
import 'package:uy/services/provider/message_list_provider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:intl/intl.dart' as intl;

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({Key key}) : super(key: key);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  TextEditingController messageController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final ScrollController listController = ScrollController();
  String postTime;
  bool attachement = false;
  String senderName;
  User currentUser = FirebaseAuth.instance.currentUser;
  String currentTextFieldValue;

  scrollToBottom() {
    listController.animateTo(
      listController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  }

  void updateNotificationCount(String userId) async {
    var snapshots = users
        .doc(currentUser.uid)
        .collection("Chat")
        .doc(userId)
        .collection("Messages")
        .where("new message", isEqualTo: false)
        .snapshots();

    await snapshots.forEach((snapshot) async {
      List<DocumentSnapshot> documents = snapshot.docs;

      for (var document in documents) {
        await document.reference.update({
          "new message": true,
        });
      }
    });
  }

  Widget attachementButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[900] : Colors.grey[800]),
      height: h * .05,
      width: h * .05,
      child: Center(
        child: SvgPicture.asset("./assets/icons/142-paperclip.svg",
            height: 20.0, width: 20.0, color: Colors.white),
      ),
    );
  }

  Widget sendButoonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[900] : Colors.grey[800]),
      height: h * .05,
      width: h * .05,
      child: Center(
        child: Icon(Icons.send, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    String userId = Provider.of<MessageProvider>(context).userId;
    return Directionality(
      textDirection: intl.Bidi.detectRtlDirectionality(S.of(context).message)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: w * 0.3,
            height: h * .05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey,
            ),
            child: TextFormField(
              maxLines: null,
              minLines: null,
              expands: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "SPProtext",
              ),
              controller: messageController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                fillColor: Colors.white,
                filled: true,
                hoverColor: Colors.grey[100],
                hintText: S.of(context).suggestionChatTypeMsg,
                hintTextDirection:
                    intl.Bidi.detectRtlDirectionality(S.of(context).message)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                hintStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.2,
                  fontSize: 12.0,
                  fontFamily: "SPProtext",
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor, width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor, width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor, width: 0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: accentColor,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              onTap: () async {
                Provider.of<AttachementMessageProvider>(context, listen: false)
                    .falseAtachement();
                updateNotificationCount(userId);
              },
            ),
          ),
          InkWell(
            child: HoverWidget(
              child: attachementButtonWidget(false),
              hoverChild: attachementButtonWidget(true),
              onHover: (onHover) {},
            ),
            onTap: () async {
              Provider.of<AttachementMessageProvider>(context, listen: false)
                  .trueAtachement();
            },
          ),
          InkWell(
              child: HoverWidget(
                  child: sendButoonWidget(false),
                  hoverChild: sendButoonWidget(true),
                  onHover: (onHover) {}),
              onTap: () async {
                if (messageController.text.isNotEmpty) {
                  setState(() {
                    currentTextFieldValue = messageController.text.trim();
                  });
                  DocumentSnapshot doc = await users.doc(currentUser.uid).get();
                  postTime = "${DateTime.now()}".split('.').first;
                  Provider.of<MessageListProvider>(context, listen: false)
                      .addMessageList(4);
                  await users
                      .doc(currentUser.uid)
                      .collection("Chat")
                      .doc(userId)
                      .set(
                    {
                      "lastTime": DateTime.now(),
                      "lastMessage": currentTextFieldValue,
                      'messageKind': "text",
                      "messageType": "Sender",
                      "sendBy": currentUser.uid,
                    },
                    SetOptions(merge: true),
                  );

                  await users
                      .doc("${currentUser.uid}")
                      .collection("Chat")
                      .doc(userId)
                      .collection("Messages")
                      .doc(postTime)
                      .set({
                    "message": currentTextFieldValue,
                    "messageType": "Sender",
                    "timeAgo": DateTime.now(),
                    "messageKind": "text",
                    "sendBy": currentUser.uid,
                    "image": doc.data()["image"]
                  });

                  messageController.clear();
                  print("En cours");
                  await users
                      .doc(userId)
                      .collection("Chat")
                      .doc(currentUser.uid)
                      .set(
                    {
                      "lastTime": DateTime.now(),
                      "lastMessage": currentTextFieldValue,
                      'messageKind': "text",
                      "messageType": "Receiver",
                      "new message": true,
                      "sendBy": currentUser.uid,
                    },
                  );

                  await users
                      .doc(userId)
                      .collection("Chat")
                      .doc("${currentUser.uid}")
                      .collection("Messages")
                      .doc(postTime)
                      .set({
                    "message": currentTextFieldValue,
                    "messageType": "Receiver",
                    "timeAgo": DateTime.now(),
                    "messageKind": "text",
                    "sendBy": currentUser.uid,
                    "image": doc.data()["image"]
                  }, SetOptions(merge: true));
                  print("Envoie");
                }
              }),
        ],
      ),
    );
  }
}
