import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/loading_widget/about_loading.dart';
import 'package:uy/services/provider/profile_provider.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({Key key}) : super(key: key);

  @override
  _AboutWidgetState createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  TextEditingController aboutController = TextEditingController();
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  cancelFunction() {
    Navigator.of(context).pop();
  }

  Widget cancelButton() {
    double h = MediaQuery.of(context).size.height;
    return HoverWidget(
        child:
            createPostAllFunctions.cancelButtonWidget(false, h, cancelFunction),
        hoverChild:
            createPostAllFunctions.cancelButtonWidget(true, h, cancelFunction),
        onHover: (onHover) {});
  }

  void createAbout() {
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
              height: h * .6,
              width: w * .5,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      height: h * .1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          cancelButton(),
                          Container(
                            height: h * .05,
                            width: w * .3,
                            child: Center(
                              child: Text(
                                S.of(context).profileAbout,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SPProtext",
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: h * .05,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    createPostAllFunctions.doneButton(
                                      h,
                                      w,
                                      S.of(context).doneButton,
                                      () async {
                                        await users
                                            .doc(currentUser.uid)
                                            .collection("About")
                                            .doc("about")
                                            .set({
                                          "about": aboutController.text.trim(),
                                        });
                                        Provider.of<ProfileProvider>(context,
                                                listen: false)
                                            .changeProfileId(currentUser.uid);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: h * .01),
                  Container(
                    height: h * .4,
                    width: w * .4,
                    child: TextFormFieldLengthLimitedWidget(
                      lengthLimit: 800,
                      controller: aboutController,
                      hintText: S.of(context).profileAbout,
                    ),
                  ),
                  SizedBox(
                    height: h * .01,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showAllAbout(String userId) {
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
              width: w * .5,
              height: h * .5,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    width: w * .5,
                    height: h * .1,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: h * .1,
                          width: w * .1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).biography,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 30.0,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: cancelButton(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * .03),
                  Expanded(
                    child: Container(
                      width: w * .5,
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            users.doc(userId).collection("About").snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return aboutLoading(h, w);
                          }
                          if (!snapshot.hasData) {
                            return Container(
                              height: 0.0,
                              width: 0.0,
                            );
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: snapshot.data.docs
                                  .map<Widget>((DocumentSnapshot document) {
                                return Container(
                                  child: Directionality(
                                      textDirection:
                                          intl.Bidi.detectRtlDirectionality(
                                                  document.data()["about"])
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      child: Text(
                                        "${document.data()["about"]}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: "SPProtext",
                                        ),
                                      )),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * .01,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> checkAboutText() async {
    var doc =
        await users.doc(currentUser.uid).collection("About").doc("about").get();
    if (doc.exists) {
      aboutController = TextEditingController(text: doc.data()["about"]);
    } else {
      aboutController = TextEditingController();
    }
  }

  modifyButtonWidget(bool hover, double h) {
    return InkWell(
      child: Container(
        height: h * .05,
        width: h * .05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          border: Border.all(
            color: hover ? Colors.blue : Colors.grey[400],
          ),
        ),
        child: Center(
          child: Icon(
            LineAwesomeIcons.pen,
            color: hover ? Colors.blue : Colors.black,
            size: 15.0,
          ),
        ),
      ),
      onTap: () {
        createAbout();
      },
    );
  }

  @override
  void initState() {
    checkAboutText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).biography,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SPProtext"),
              ),
              currentUser.uid == userId
                  ? HoverWidget(
                      child: modifyButtonWidget(false, h),
                      hoverChild: modifyButtonWidget(true, h),
                      onHover: (onHover) {},
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    ),
            ],
          ),
        ),
        Container(
          width: w * .4,
          child: StreamBuilder<QuerySnapshot>(
            stream: users.doc(userId).collection("About").snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return aboutLoading(h, w);
              }
              if (!snapshot.hasData) {
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              }

              return Column(
                children:
                    snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                  return Container(
                    child: Directionality(
                      textDirection: intl.Bidi.detectRtlDirectionality(
                              document.data()["about"])
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: document.data()["about"].toString().length < 600
                          ? Text(
                              "${document.data()["about"]}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontFamily: "SPProtext",
                              ),
                            )
                          : Container(
                              width: w * .4,
                              height: h * .2,
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Text(
                                    "${document.data()["about"].toString().substring(0, 600)}...",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showAllAbout(userId);
                                    },
                                    child: Text(
                                      S.of(context).readMore,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontFamily: "SPProtext",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ]),
    );
  }
}
