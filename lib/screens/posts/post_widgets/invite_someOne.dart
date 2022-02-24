import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hovering/hovering.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/loading_widget/invite_item_loading.dart';
import 'package:uy/services/time_ago.dart';
import 'package:intl/intl.dart' as intl;

class InviteSomeOne extends StatefulWidget {
  final String userId;
  final String id;

  const InviteSomeOne({Key key, this.userId, this.id}) : super(key: key);
  @override
  _InviteSomeOneState createState() => _InviteSomeOneState();
}

class _InviteSomeOneState extends State<InviteSomeOne> {
  TextEditingController searchFriendController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  String id;
  String userId;
  Time timeCal = new Time();
  bool isSend = false;
  List<QueryDocumentSnapshot> results;
  String searchTyping = "";
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  Widget cancelButton() {
    double h = MediaQuery.of(context).size.height;
    return HoverWidget(
        child:
            createPostAllFunctions.cancelButtonWidget(false, h, cancelFunction),
        hoverChild:
            createPostAllFunctions.cancelButtonWidget(true, h, cancelFunction),
        onHover: (onHover) {});
  }

  cancelFunction() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    id = widget.id;
    isSend = false;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: h * .1,
          width: w * .4,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: h * .1,
                  child: Align(
                    alignment: intl.Bidi.detectRtlDirectionality(
                            S.of(context).inviteButton)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      S.of(context).inviteButton,
                      style: TextStyle(
                          color: Color(0xFF11202D),
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
              ),
              cancelButton(),
            ],
          ),
        ),
        Container(
          height: h * .1,
          width: w * .4,
          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 17.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w * .35,
                height: h * 0.8,
                child: Center(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        value = searchFriendController.value.text;
                        searchTyping = value;
                      });
                    },
                    minLines: null,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: "SPProtext"),
                    controller: searchFriendController,
                    autofocus: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 17.0),
                      hintText: S.of(context).searchFriend,
                      hintStyle:
                          TextStyle(color: Colors.grey[800], fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: w * .35,
            child: StreamBuilder(
              stream: users.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (_, index) {
                        return loadingInviteItems(h, w);
                      });
                }
                results = snapshot.data.docs;
                print(searchTyping);

                results.retainWhere(
                  (DocumentSnapshot doc) =>
                      doc.data()["full_name"].toString().toLowerCase().contains(
                            searchTyping.toLowerCase(),
                          ),
                );
                return searchTyping != ""
                    ? ListView(
                        children: results
                            .map<Widget>(
                              (a) => SearchItem(
                                userId: userId,
                                id: id,
                                a: a.id,
                              ),
                            )
                            .toList(),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SearchItem extends StatefulWidget {
  final String a;
  final String id;
  final String userId;

  const SearchItem({Key key, this.a, this.id, this.userId}) : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String id;
  String userId;
  String document;
  bool isSend = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    document = widget.a;
    id = widget.id;
    userId = widget.userId;
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
                height: h * .06,
                width: h * .06,
                decoration: BoxDecoration(
                  borderRadius: intl.Bidi.detectRtlDirectionality(
                          S.of(context).inviteButton)
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
              title: Text(
                data["full_name"],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: "SPProtext"),
              ),
              subtitle: Text(
                data["location"],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontFamily: "SPProtext"),
              ),
              trailing: document != currentUser.uid
                  ? InkWell(
                      onTap: () async {
                        setState(() {
                          isSend = true;
                        });

                        DocumentSnapshot user =
                            await users.doc(currentUser.uid).get();
                        DocumentSnapshot pub = await users
                            .doc(userId)
                            .collection("Pub")
                            .doc(id)
                            .get();

                        await users
                            .doc(document)
                            .collection("Notifications")
                            .doc("$userId*inviteToRead*$id")
                            .set({
                          "seen": false,
                          "timeAgo": DateTime.now(),
                          "postKind": "inviteToRead",
                          "uid": currentUser.uid,
                          "pubKind": pub.data()["postKind"],
                          "userName": user.data()["full_name"],
                        });

                        setState(() {
                          isSend = false;
                          isDone = true;
                        });
                      },
                      child: Container(
                        height: h * .045,
                        width: w * .07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: !isSend && !isDone
                              ? Colors.lightBlueAccent
                              : !isSend && isDone
                                  ? Colors.grey[400]
                                  : Colors.lightBlueAccent,
                        ),
                        child: Center(
                          child: !isSend && !isDone
                              ? Text(
                                  S.of(context).inviteButton,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontFamily: "SPProtext",
                                  ),
                                )
                              : !isSend && isDone
                                  ? Text(
                                      S.of(context).sentButton,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 12.0,
                                          fontFamily: "SPProtext"),
                                    )
                                  : Center(
                                      child: SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                    ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
            );
          }
          return loadingInviteItems(h, w);
        });
  }
}
