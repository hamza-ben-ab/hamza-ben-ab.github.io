import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/message_list_loading.dart';
import 'package:uy/screens/message/menu_button.dart';
import 'package:uy/screens/message/message_item.dart';
import 'package:uy/screens/message/text_input_widget.dart';
import 'package:uy/screens/message/upload_file.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart' as intl;

class ConversationWidget extends StatefulWidget {
  const ConversationWidget({Key key}) : super(key: key);

  @override
  _ConversationWidgetState createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  VideoPlayerController videoPlayerController;
  ScrollController listController = ScrollController();

  Widget unblockBotton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .05,
      width: w * .2,
      decoration: BoxDecoration(
        color: hover ? Colors.grey[400] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Text(
          S.of(context).suggestionChatUnBlock,
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontFamily: "SPProtext"),
        ),
      ),
    );
  }

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 200));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      listController.animateTo(listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<MessageProvider>(context).userId;
    bool isBlock = Provider.of<MessageProvider>(context).isBlock;
    String blockedBy = Provider.of<MessageProvider>(context).blockedBy;
    String receiverName = Provider.of<MessageProvider>(context).userName;
    return Stack(
      children: [
        Container(
          width: w * .4,
          height: h * .85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                  future: users.doc(userId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> data = snapshot.data.data();

                      return Container(
                        height: h * .07,
                        width: w * .4,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: h * .06,
                              width: h * .06,
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
                            InkWell(
                              onTap: () {
                                Provider.of<CenterBoxProvider>(context,
                                        listen: false)
                                    .changeCurrentIndex(7);
                                Provider.of<ProfileProvider>(context,
                                        listen: false)
                                    .changeProfileId(userId);
                              },
                              child: HoverWidget(
                                child: Container(
                                  width: w * .27,
                                  child: Center(
                                    child: Text(
                                      data["full_name"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "SPProtext"),
                                    ),
                                  ),
                                ),
                                hoverChild: Container(
                                  width: w * .27,
                                  child: Center(
                                    child: Text(
                                      data["full_name"],
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "SPProtext"),
                                    ),
                                  ),
                                ),
                                onHover: (onHover) {},
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: h * .05,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: MenuButtonWidget(
                                    receiverName: data["full_name"],
                                  ),
                                ),
                              ).xShowPointerOnHover,
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  }),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0),
                  width: w * .4,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: users
                        .doc(currentUser.uid)
                        .collection("Chat")
                        .doc(userId)
                        .collection("Messages")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return messageListLoading(h, w);
                      }

                      scrollToBottom();
                      return Scrollbar(
                        controller: listController,
                        isAlwaysShown: true,
                        radius: Radius.circular(20.0),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: listController,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var document = snapshot.data.docs[index];

                            return MessageItem(document: document);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              isBlock
                  ? Container(
                      width: w * .4,
                      child: isBlock && blockedBy == currentUser.uid
                          ? Column(
                              children: [
                                Divider(
                                  color: Colors.grey[400],
                                ),
                                Directionality(
                                  textDirection:
                                      intl.Bidi.detectRtlDirectionality(
                                              S.of(context).message)
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                  child: Container(
                                    height: h * .12,
                                    width: w * .4,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: h * .03,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: S
                                                  .of(context)
                                                  .suggestionChatBlocktitle1,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontFamily: "SPProtext",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: " $receiverName ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        SizedBox(
                                          height: h * .02,
                                        ),
                                        Text(
                                          S
                                              .of(context)
                                              .suggestionChatBlockDescrip,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 12.0,
                                            fontFamily: "SPProtext",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: h * .03,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await users
                                        .doc(currentUser.uid)
                                        .collection("Block")
                                        .doc(userId)
                                        .delete();
                                    await users
                                        .doc(userId)
                                        .collection("Block")
                                        .doc(currentUser.uid)
                                        .delete();
                                    Provider.of<MessageProvider>(context,
                                            listen: false)
                                        .cancelBlock();
                                  },
                                  child: HoverWidget(
                                    child: unblockBotton(false),
                                    hoverChild: unblockBotton(true),
                                    onHover: (onHover) {},
                                  ),
                                ),
                                SizedBox(
                                  height: h * .03,
                                ),
                              ],
                            )
                          : isBlock && blockedBy != currentUser.uid
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Divider(
                                      color: Colors.grey[400],
                                    ),
                                    Container(
                                      height: h * .1,
                                      width: w * .4,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Center(
                                        child: Text(
                                          S.of(context).messageSorryCannotSend,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontFamily: "SPProtext"),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container(
                                  height: 0.0,
                                  width: 0.0,
                                ),
                    )
                  : UploadFileWidget(),
              !isBlock
                  ? Container(
                      height: h * .05,
                      width: w * .4,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextInputWidget(),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    )
            ],
          ),
        ),
      ],
    );
  }
}
