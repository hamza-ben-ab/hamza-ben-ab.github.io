import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:intl/intl.dart' as intl;

class SuggestionItem extends StatefulWidget {
  final String userId;

  const SuggestionItem({Key key, this.userId}) : super(key: key);

  @override
  _SuggestionItemState createState() => _SuggestionItemState();
}

class _SuggestionItemState extends State<SuggestionItem> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool seeMore = false;
  bool filterOnly = false;
  bool isFollow = false;
  List<String> highlights;

  Future<void> checkSubscribe(String userId) async {
    DocumentSnapshot user = await users
        .doc(currentUser.uid)
        .collection("Subscriptions")
        .doc(userId)
        .get();
    setState(() {
      if (user.exists) {
        isFollow = true;
      } else {
        isFollow = false;
      }
    });

    return isFollow;
  }

  Widget fullNameWidget(bool hover, String name) {
    double h = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            fontFamily: "SPProtext",
          ),
        ),
        SizedBox(
          width: 3.0,
        ),
        Container(
          height: h * .017,
          width: h * .017,
          child: Image.asset("./assets/images/check (2).png"),
        )
      ],
    );
  }

  Widget userWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.userId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return Center(
              child: InkWell(
                onTap: () {
                  Provider.of<HideLeftBarProvider>(context, listen: false)
                      .closeleftBar();
                  Provider.of<CenterBoxProvider>(context, listen: false)
                      .changeCurrentIndex(7);
                  Provider.of<ProfileProvider>(context, listen: false)
                      .changeProfileId(widget.userId);
                },
                child: Container(
                  width: w * .185,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: hover ? Colors.grey[300] : Colors.white),
                  child: Row(
                    children: [
                      Container(
                        height: h * .065,
                        width: h * .065,
                        decoration: BoxDecoration(
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
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.network(data["image"]).image),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HoverWidget(
                              child: fullNameWidget(
                                false,
                                data["full_name"],
                              ),
                              hoverChild: fullNameWidget(
                                true,
                                data["full_name"],
                              ),
                              onHover: (onHover) {},
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "${data["journalistKind"]}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.0,
                                fontFamily: "SPProtext",
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              data["currentLocation"],
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12.0,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).xShowPointerOnHover,
              ),
            );
          }
          return Container(
            height: 0.0,
            width: 0.0,
          );
        });
  }

  @override
  void initState() {
    checkSubscribe(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
        child: userWidget(false),
        hoverChild: userWidget(true),
        onHover: (event) {});
  }
}
