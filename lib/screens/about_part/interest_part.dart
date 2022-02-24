 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/services/provider/topic_provider.dart';
import 'package:uy/widget/topic_list.dart';

class InterestPart extends StatefulWidget {
  const InterestPart({Key key}) : super(key: key);

  @override
  _InterestPartState createState() => _InterestPartState();
}

class _InterestPartState extends State<InterestPart> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  modifyButtonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Provider.of<TopicProvider>(context, listen: false).backTo(0);
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 0.0,
                child: ShowTopicList(
                  interest: true,
                ),
              );
            });
      },
      child: Container(
        height: h * .05,
        width: h * .05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: hover ? Colors.blue : Colors.grey[400],
          ),
          color: Colors.white,
        ),
        child: Center(
          child: Icon(
            LineAwesomeIcons.pen,
            color: Colors.black,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  Widget interestItems(String title) {
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: h * .04,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            textDirection: intl.Bidi.detectRtlDirectionality(title)
                ? TextDirection.rtl
                : TextDirection.ltr,
            style: TextStyle(
              fontFamily: "SPProtext",
              fontWeight: FontWeight.w500,
              fontSize: 10.0,
              color: Colors.black,
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.grey[300]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<ProfileProvider>(context).userId;

    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).profileExperience)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 20.0, top: 5.0, bottom: 5.0),
        padding: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).profileInterest,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SPProtext"),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  currentUser.uid == userId
                      ? HoverWidget(
                          child: modifyButtonWidget(false),
                          hoverChild: modifyButtonWidget(true),
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
              stream: users.doc(userId).collection("Interests").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(height: 0.0, width: 0.0);
                }

                return Container(
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      runSpacing: 10.0,
                      spacing: 10.0,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return interestItems(
                          document.data()["data"],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
