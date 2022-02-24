import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/services/functions.dart';
import 'package:intl/intl.dart' as intl;

class LikeAndDisLikeBar extends StatefulWidget {
  final String userId;
  final String id;
  final bool views;
  const LikeAndDisLikeBar({Key key, this.userId, this.id, this.views})
      : super(key: key);

  @override
  _LikeAndDisLikeBarState createState() => _LikeAndDisLikeBarState();
}

class _LikeAndDisLikeBarState extends State<LikeAndDisLikeBar> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FunctionsServices functionsServices = FunctionsServices();
  String userId;
  String id;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: intl.Bidi.detectRtlDirectionality(S.of(context).like)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        height: h * .05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: h * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).like,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("LikeOrDislike")
                          .where("LikeOrDislike", isEqualTo: "like")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        }

                        return Text(
                          functionsServices
                              .dividethousand(snapshot.data.docs.length),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500],
                            fontFamily: "SPProtext",
                          ),
                        );
                      }),
                ],
              ),
            ),
            Container(
              height: h * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).dislike,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.red,
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("LikeOrDislike")
                          .where("LikeOrDislike", isEqualTo: "dislike")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        }

                        return Text(
                          functionsServices
                              .dividethousand(snapshot.data.docs.length),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500],
                            fontFamily: "SPProtext",
                          ),
                        );
                      }),
                ],
              ),
            ),
            Container(
              height: h * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).commentReply,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[800],
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("Comments")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        }

                        return Text(
                          functionsServices
                              .dividethousand(snapshot.data.docs.length),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500],
                            fontFamily: "SPProtext",
                          ),
                        );
                      }),
                ],
              ),
            ),
            Container(
              height: h * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.views ? S.of(context).views : S.of(context).readers,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection(widget.views ? "Views" : "Readers")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        }

                        return Text(
                          functionsServices
                              .dividethousand(snapshot.data.docs.length),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500],
                            fontFamily: "SPProtext",
                          ),
                        );
                      }),
                ],
              ),
            ),
            Container(
              height: h * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).report,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[800],
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("Report")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        }

                        return Text(
                          functionsServices
                              .dividethousand(snapshot.data.docs.length),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500],
                            fontFamily: "SPProtext",
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
