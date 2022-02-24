import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/loading_widget/skills_exp_loading.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:intl/intl.dart' as intl;

class SkillsPart extends StatefulWidget {
  const SkillsPart({Key key}) : super(key: key);

  @override
  _SkillsPartState createState() => _SkillsPartState();
}

class _SkillsPartState extends State<SkillsPart> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  TextEditingController universityController = TextEditingController();
  TextEditingController diplomaController = TextEditingController();

  ScrollController skillsController = ScrollController();

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

  Widget requestConfirmButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.05,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: Text(
          S.of(context).confirmButton,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            fontFamily: "SPProtext",
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? Colors.cyan[500] : Colors.cyan[400],
      ),
    );
  }

  Widget requestCancelButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.05,
      width: w * 0.12,
      child: Center(
        child: Text(
          S.of(context).cancelButton,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontFamily: "SPProtext",
          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[400] : Colors.grey[300]),
    );
  }

  Widget skillsitemWidget(String university, String diploma) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).profileSkills)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Center(
        child: Container(
          width: w * .45,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.grey[400])),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      university,
                      textDirection:
                          intl.Bidi.detectRtlDirectionality(university)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SPProtext",
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      diploma,
                      textDirection: intl.Bidi.detectRtlDirectionality(diploma)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: TextStyle(
                          color: accentColor,
                          fontSize: 12.0,
                          fontFamily: "SPProtext"),
                    ),
                  ],
                ),
              ),
              Container(
                width: w * .03,
                child: InkWell(
                  onTap: () {
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
                              width: w * .3,
                              height: h * .2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: h * .03,
                                  ),
                                  Text(
                                    S.of(context).deleteAsk,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    height: h * .07,
                                    width: w * .3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: HoverWidget(
                                              child:
                                                  requestConfirmButton(false),
                                              hoverChild:
                                                  requestConfirmButton(true),
                                              onHover: (onHover) {}),
                                          onTap: () async {
                                            await users
                                                .doc(currentUser.uid)
                                                .collection("Skills")
                                                .doc(university)
                                                .delete();

                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        InkWell(
                                          child: HoverWidget(
                                              child: requestCancelButton(false),
                                              hoverChild:
                                                  requestCancelButton(true),
                                              onHover: (onHover) {}),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: HoverWidget(
                    child: deleteWidget(false),
                    hoverChild: deleteWidget(true),
                    onHover: (onHover) {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showSkills() {
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
              height: h * .9,
              width: w * .5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      height: h * .1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          cancelButton(),
                          Expanded(
                            child: Center(
                              child: Text(
                                S.of(context).profileSkills,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SPProtext",
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          Container(
                            width: w * .1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                createPostAllFunctions.doneButton(
                                  h,
                                  w,
                                  S.of(context).doneButton,
                                  () async {
                                    if (universityController.text.isNotEmpty &&
                                        diplomaController.text.isNotEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Skills")
                                          .doc(universityController.text.trim())
                                          .set({
                                        "university":
                                            universityController.text.trim(),
                                        "diploma":
                                            diplomaController.text.trim(),
                                      });
                                      universityController.clear();
                                      diplomaController.clear();
                                    }
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: w * .5,
                    height: h * .75,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: SingleChildScrollView(
                      controller: skillsController,
                      child: Container(
                        width: w * .63,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    S.of(context).profileSkillsEstablishment,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SPProtext"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: h * .06,
                              width: w * .45,
                              child: TextFormFieldWidget(
                                controller: universityController,
                                hintText: S
                                    .of(context)
                                    .profileSkillsEstablishmentHint,
                              ),
                            ),
                            SizedBox(
                              height: h * .03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    S.of(context).profileSkillsDiploma,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SPProtext"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: h * .06,
                              width: w * .45,
                              child: TextFormFieldWidget(
                                controller: diplomaController,
                                hintText:
                                    S.of(context).profileSkillsDiplomaHint,
                              ),
                            ),
                            SizedBox(
                              height: h * .03,
                            ),
                            Container(
                              height: h * .06,
                              width: w * .45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    child: HoverWidget(
                                        child: addButton(false),
                                        hoverChild: addButton(true),
                                        onHover: (onHover) {}),
                                    onTap: () {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Skills")
                                          .doc(universityController.text.trim())
                                          .set({
                                        "timeAgo": DateTime.now(),
                                        "university":
                                            universityController.text.trim(),
                                        "diploma":
                                            diplomaController.text.trim(),
                                      });
                                      universityController.clear();
                                      diplomaController.clear();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: h * .03,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: users
                                  .doc(currentUser.uid)
                                  .collection("Skills")
                                  .orderBy("timeAgo", descending: false)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.hasError) {
                                  return Container(
                                    width: w * .45,
                                    height: h * .34,
                                    child: ListView.builder(
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return skillsLoading(h, w);
                                      },
                                    ),
                                  );
                                }

                                return Container(
                                  width: w * .45,
                                  child: Column(
                                      children: snapshot.data.docs
                                          .map((DocumentSnapshot document) {
                                    return skillsitemWidget(
                                      document.data()["university"],
                                      document.data()["diploma"],
                                    );
                                  }).toList()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget addButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.04,
      width: w * .08,
      child: Center(
        child: Text(
          S.of(context).addButton,
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontFamily: "SPProtext"),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: !hover ? Colors.grey[300] : Colors.grey[400]),
    );
  }

  Widget deleteWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      decoration: BoxDecoration(
        border: Border.all(color: hover ? Colors.red : Colors.grey[400]),
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Center(
        child: Icon(
          LineAwesomeIcons.times_circle_1,
          color: Colors.black,
          size: 30.0,
        ),
      ),
    );
  }

  modifyButtonWidget(bool hover, double h, Function function) {
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
            size: 20.0,
          ),
        ),
      ),
      onTap: () {
        function();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).profileSkills)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 20.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Column(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).profileSkills,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "SPProtext"),
                ),
                currentUser.uid == userId
                    ? HoverWidget(
                        child: modifyButtonWidget(false, h, showSkills),
                        hoverChild: modifyButtonWidget(true, h, showSkills),
                        onHover: (onHover) {},
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: users
                .doc(userId)
                .collection("Skills")
                .orderBy("timeAgo", descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: w * .63,
                  height: h * .35,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return skillsLoading(h, w);
                    },
                  ),
                );
              }

              return Container(
                width: w * .63,
                padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 10.0),
                child: new Column(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return profileSkillsItemsWidget(
                        document.data()["university"],
                        document.data()["diploma"]);
                  }).toList(),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget profileSkillsItemsWidget(String university, String diploma) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).profileSkills)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        width: w * .63,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: h * .07,
              width: h * .07,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[200]),
              child: Center(
                child: SvgPicture.asset(
                  "./assets/icons/graduation-cap.svg",
                  color: accentColor,
                  height: 20.0,
                  width: 20.0,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SPProtext"),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      diploma,
                      style: TextStyle(
                          color: Color(0xFF30868F),
                          fontSize: 12.0,
                          fontFamily: "SPProtext"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
