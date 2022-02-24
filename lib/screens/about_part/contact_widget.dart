import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/services/provider/profile_provider.dart';

class ContactWidget extends StatefulWidget {
  const ContactWidget({Key key}) : super(key: key);

  @override
  _ContactWidgetState createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  TextEditingController facebookLink = TextEditingController();
  TextEditingController mailLink = TextEditingController();
  TextEditingController twitterLink = TextEditingController();
  TextEditingController instagramLink = TextEditingController();
  TextEditingController linkedInLink = TextEditingController();
  TextEditingController youtubeLink = TextEditingController();
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;

  Future<void> checkContact() async {
    var mail = await users
        .doc(currentUser.uid)
        .collection("Contacts")
        .doc("Mail")
        .get();
    var facebook = await users
        .doc(currentUser.uid)
        .collection("Contacts")
        .doc("Facebook")
        .get();
    var twitter = await users
        .doc(currentUser.uid)
        .collection("Contacts")
        .doc("Twitter")
        .get();
    var linkedin = await users
        .doc(currentUser.uid)
        .collection("Contacts")
        .doc("LinkedIn")
        .get();
    var instagram = await users
        .doc(currentUser.uid)
        .collection("Contacts")
        .doc("Instagram")
        .get();
    var youtube = await users
        .doc(currentUser.uid)
        .collection("Contacts")
        .doc("Youtube")
        .get();
    if (mail.exists) {
      mailLink = TextEditingController(text: mail.data()["data"]);
    }
    if (facebook.exists) {
      facebookLink = TextEditingController(text: facebook.data()["data"]);
    }
    if (twitter.exists) {
      twitterLink = TextEditingController(text: twitter.data()["data"]);
    }
    if (linkedin.exists) {
      linkedInLink = TextEditingController(text: linkedin.data()["data"]);
    }
    if (instagram.exists) {
      instagramLink = TextEditingController(text: instagram.data()["data"]);
    }
    if (youtube.exists) {
      youtubeLink = TextEditingController(text: youtube.data()["data"]);
    }
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

  discardFunction() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  alertDialogCancelFunction() {
    Navigator.of(context).pop();
  }

  cancelFunction() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (mailLink.text.isNotEmpty ||
        facebookLink.text.isNotEmpty ||
        instagramLink.text.isNotEmpty ||
        twitterLink.text.isNotEmpty ||
        linkedInLink.text.isNotEmpty ||
        youtubeLink.text.isNotEmpty) {
      return createPostAllFunctions.unDoneDialog(
        h,
        w,
        context,
        S.of(context).unDoneDialogDiscardPost,
        S.of(context).unDoneDialogDiscardDes,
        S.of(context).unDoneDialogDiscardButton,
        S.of(context).cancelButton,
        discardFunction,
        alertDialogCancelFunction,
      );
    }

    Navigator.of(context).pop();
  }

  void showContact() {
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
              height: h * .8,
              width: w * .4,
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
                          Container(
                            width: w * .25,
                            child: Center(
                              child: Text(
                                S.of(context).profileContacts,
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
                                    if (mailLink.text.isNotEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Mail")
                                          .set(
                                        {"data": mailLink.text.trim()},
                                        SetOptions(merge: true),
                                      );
                                    }
                                    if (facebookLink.text.isNotEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Facebook")
                                          .set(
                                        {"data": facebookLink.text.trim()},
                                        SetOptions(merge: true),
                                      );
                                    }
                                    if (twitterLink.text.isNotEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Twitter")
                                          .set(
                                        {"data": twitterLink.text.trim()},
                                        SetOptions(merge: true),
                                      );
                                    }
                                    if (linkedInLink.text.isNotEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("LinkedIn")
                                          .set(
                                        {"data": linkedInLink.text.trim()},
                                        SetOptions(merge: true),
                                      );
                                    }
                                    if (instagramLink.text.isNotEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Instagram")
                                          .set(
                                        {"data": instagramLink.text.trim()},
                                        SetOptions(merge: true),
                                      );
                                    }
                                    if (youtubeLink.text.isNotEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Youtube")
                                          .set(
                                        {"data": youtubeLink.text.trim()},
                                        SetOptions(merge: true),
                                      );
                                    }
                                    if (mailLink.text.isEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Mail")
                                          .delete();
                                    }
                                    if (facebookLink.text.isEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Facebook")
                                            ..delete();
                                    }
                                    if (twitterLink.text.isEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Twitter")
                                          .delete();
                                    }
                                    if (linkedInLink.text.isEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("LinkedIn")
                                          .delete();
                                    }
                                    if (instagramLink.text.isEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Instagram")
                                          .delete();
                                    }
                                    if (youtubeLink.text.isEmpty) {
                                      users
                                          .doc(currentUser.uid)
                                          .collection("Contacts")
                                          .doc("Youtube")
                                          .delete();
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
                  SizedBox(
                    height: h * .03,
                  ),
                  contactItem(
                    mailLink,
                    S.of(context).emailTitleSignUpWithEmail,
                    "Mail",
                    "Mail.png",
                  ),
                  contactItem(
                    facebookLink,
                    "Facebook",
                    "Facebook",
                    "Facebook.png",
                  ),
                  contactItem(
                    twitterLink,
                    "Twitter",
                    "Twitter",
                    "Twitter.png",
                  ),
                  contactItem(
                    linkedInLink,
                    "LinkedIn",
                    "LinkedIn",
                    "LinkedIn.png",
                  ),
                  contactItem(
                    instagramLink,
                    "Instagram",
                    "Instagram",
                    "Instagram.png",
                  ),
                  contactItem(
                    youtubeLink,
                    "Youtube",
                    "Youtube",
                    "Youtube.png",
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    checkContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).profileContacts)
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
                  S.of(context).profileContacts,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "SPProtext"),
                ),
                currentUser.uid == userId
                    ? HoverWidget(
                        child: modifyButtonWidget(false, h, showContact),
                        hoverChild: modifyButtonWidget(true, h, showContact),
                        onHover: (onHover) {},
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget contactItem(TextEditingController textController, String hintText,
      String docName, String image) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .1,
      width: w * .35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: h * .05,
            width: h * .05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blueGrey[300],
              image: DecorationImage(
                  image: Image.asset("./assets/images/$image").image,
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            height: h * .05,
            width: w * .3,
            child: TextFormFieldWidget(
              controller: textController,
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
