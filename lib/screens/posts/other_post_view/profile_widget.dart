import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/bookmark/bookMark_button.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/posts/post_functions.dart';
import 'package:uy/screens/posts/ahead_post/ahead_post_home.dart';
import 'package:uy/screens/posts/post_widgets/true_false_bar.dart';
import 'package:uy/screens/profile/show_post_details.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/screens/search/hover.dart';

class PersonnalityProfileWidget extends StatefulWidget {
  final String userId;
  final String id;
  const PersonnalityProfileWidget({Key key, this.userId, this.id})
      : super(key: key);

  @override
  _PersonnalityProfileWidgetState createState() =>
      _PersonnalityProfileWidgetState();
}

class _PersonnalityProfileWidgetState extends State<PersonnalityProfileWidget> {
  User currentUser = FirebaseAuth.instance.currentUser;
  PageController pageController = PageController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String userId;
  String id;
  FunctionsServices functionsServices = FunctionsServices();
  PostFunctions postAllFunctions = PostFunctions();

  @override
  void initState() {
    userId = widget.userId;
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(userId).collection("Pub").doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
              width: w * .4,
              height: h * .7,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  AheadPostHome(
                    data: data,
                    userId: userId,
                  ),
                  Container(
                    width: w * .4,
                    child: Column(
                      children: [
                        TrueAndFalseBar(
                          userId: userId,
                          id: id,
                        ),
                        //bookMark
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 10.0, right: 12.0),
                          child: Row(
                            children: [
                              BookMarkButton(
                                postKind: data["postKind"],
                                userId: userId,
                                id: id,
                                read: true,
                              )
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: w * .4,
                              padding: EdgeInsets.only(bottom: h * .05),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: w * .2,
                                    height: h * .4,
                                    child: Center(
                                      child: Container(
                                        width: w * .15,
                                        height: h * .35,
                                        color: Colors.grey[200],
                                        child: Image.network(
                                          data["mediaUrl"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: w * .15,
                                            padding: const EdgeInsets.all(8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                  text:
                                                      "${S.of(context).fullNameTitleSignUpWithEmail} : ",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: data["full_name"],
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            width: w * .16,
                                            child: RichText(
                                              text: TextSpan(
                                                  text:
                                                      "${S.of(context).createProfileOccupation} : ",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "${data["Occupation"]}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            width: w * .16,
                                            child: RichText(
                                              text: TextSpan(
                                                  text:
                                                      "${S.of(context).createProfileNationality} : ",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "${data["Nationality"]}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            width: w * .16,
                                            child: RichText(
                                              text: TextSpan(
                                                  text:
                                                      "${S.of(context).createProfileAgeHintText} : ",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: "${data["age"]}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            width: w * .16,
                                            child: RichText(
                                              text: TextSpan(
                                                  text:
                                                      "${S.of(context).createProfilecurrentCityHintText} : ",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SPProtext",
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "${data["currentCity"]}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontFamily: "SPProtext",
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: w * .01,
                              top: h * .25,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: h * .2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  width: w * .24,
                                  child: Text(
                                    data["description"],
                                    overflow: TextOverflow.fade,
                                    textDirection:
                                        intl.Bidi.detectRtlDirectionality(
                                                data["description"])
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontFamily: "Avenir"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * .02,
                        ),
                        Container(
                          height: h * .04,
                          width: w * .4,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Provider.of<ReadPostProvider>(context,
                                          listen: false)
                                      .changePostId(userId, id);
                                  showDialog(
                                    context: (context),
                                    builder: (context) {
                                      return ShowPostDetails(
                                        id: widget.id,
                                        postKind: "personality",
                                      );
                                    },
                                  );
                                },
                                child: postAllFunctions
                                    .readButtonWidget(
                                      h,
                                      w,
                                      S.of(context).read,
                                    )
                                    .xShowPointerOnHover,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            height: 0.0,
            width: 0.0,
          );
        });
  }
}
