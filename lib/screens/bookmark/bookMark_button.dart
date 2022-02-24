import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';

class BookMarkButton extends StatefulWidget {
  final String userId;
  final String id;
  final bool read;
  final String postKind;
  const BookMarkButton(
      {Key key, this.userId, this.id, this.read, @required this.postKind})
      : super(key: key);

  @override
  _BookMarkButtonState createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {
  bool isBookmark = false;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    //checkBookMark();
    super.initState();
  }

  void checkBookMark() async {
    DocumentSnapshot doc = await users
        .doc(currentUser.uid)
        .collection(widget.read ? "Read Later" : "Watch Later")
        .doc("${widget.userId}==${widget.id}")
        .get();

    if (doc.exists) {
      setState(() {
        isBookmark = true;
      });
    } else {
      setState(() {
        isBookmark = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return InkWell(
      child: Tooltip(
        message:
            widget.read ? S.of(context).readLater : S.of(context).watchLater,
        child: Container(
          height: h * .035,
          child: Icon(
            LineAwesomeIcons.bookmark,
            color: isBookmark ? Colors.red : accentColor,
            size: 25.0,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          isBookmark = !isBookmark;
        });
        if (isBookmark) {
          users
              .doc(currentUser.uid)
              .collection(widget.read ? "Read Later" : "Watch Later")
              .doc("${widget.userId}==${widget.id}")
              .set({"timeAgo": DateTime.now(), "postKind": widget.postKind});
        } else {
          users
              .doc(currentUser.uid)
              .collection(widget.read ? "Read Later" : "Watch Later")
              .doc(widget.id)
              .delete();
        }
      },
    );
  }
}
