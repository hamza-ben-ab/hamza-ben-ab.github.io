import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/services/functions.dart';
import 'package:intl/intl.dart' as intl;

class TrueAndFalseBar extends StatefulWidget {
  final String userId;
  final String id;
  const TrueAndFalseBar({Key key, this.userId, this.id}) : super(key: key);

  @override
  _TrueAndFalseBarState createState() => _TrueAndFalseBarState();
}

class _TrueAndFalseBarState extends State<TrueAndFalseBar> {
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
    //double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: intl.Bidi.detectRtlDirectionality(S.of(context).trueKey)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        height: h * .05,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: h * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).trueKey,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("TrueOrFalse")
                          .where("trueOrfalse", isEqualTo: "true")
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
                    S.of(context).falseKey,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.red,
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("TrueOrFalse")
                          .where("trueOrfalse", isEqualTo: "false")
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
                    width: 12.0,
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
                    S.of(context).readers,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[800],
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(userId)
                          .collection("Pub")
                          .doc(id)
                          .collection("Readers")
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
                    width: 12.0,
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
                            fontSize: 10.0,
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
