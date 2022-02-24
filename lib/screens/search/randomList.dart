import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/invite_item_loading.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/provider/search_details_provider.dart';
import 'package:uy/services/provider/search_field_provider.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:intl/intl.dart' as intl;

typedef void SelectedItemCallback(selected);

///List of some random words for demo
class RandomList extends StatefulWidget {
  final String searchTextTyping;

  RandomList({
    Key key,
    this.searchTextTyping,
  }) : super(key: key);

  @override
  _RandomListState createState() => _RandomListState();
}

class _RandomListState extends State<RandomList> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  List<QueryDocumentSnapshot> results;
  ScrollController overlayTextController = ScrollController();

  Widget _tile(bool hover, QueryDocumentSnapshot data) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Provider.of<HideLeftBarProvider>(context, listen: false).closeleftBar();
        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeCurrentIndex(7);
        Provider.of<ProfileProvider>(context, listen: false)
            .changeProfileId(data.id);
      },
      child: Directionality(
        textDirection:
            intl.Bidi.detectRtlDirectionality(S.of(context).telltrueUser)
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Container(
          width: w * .2,
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: hover ? Colors.blue : Colors.transparent),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            children: [
              Container(
                height: h * .05,
                width: h * .05,
                decoration: BoxDecoration(
                  borderRadius: intl.Bidi.detectRtlDirectionality(
                          S.of(context).famousPersonIdentified)
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
                  children: [
                    Container(
                      width: w * .15,
                      child: Text(
                        '${data["full_name"]}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: "SPProtext"),
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
                          fontFamily: "SPProtext"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ).xShowPointerOnHover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String searchTyping =
        Provider.of<SearchFieldProvider>(context).searchTypingField;
    return Container(
      height: h * .6,
      width: w * .22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return loadingInviteItems(h, w);
                },
              );
            }

            results = snapshot.data.docs;

            results.retainWhere(
              (DocumentSnapshot doc) =>
                  doc.data()["full_name"].toString().toLowerCase().contains(
                        searchTyping.toLowerCase(),
                      ),
            );
            results = results
                .where(
                  (document) => document.data()["kind"] == "Journalist",
                )
                .toList();

            if (results.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    searchTyping,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SPProtext",
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  HoverWidget(
                      child: emptySearch(false, searchTyping),
                      hoverChild: emptySearch(true, searchTyping),
                      onHover: (onHover) {})
                ],
              );
            }
            return Scrollbar(
              isAlwaysShown: true,
              radius: Radius.circular(20.0),
              controller: overlayTextController,
              child: ListView(
                controller: overlayTextController,
                children: results
                    .map<Widget>(
                      (a) => HoverWidget(
                        child: _tile(false, a),
                        hoverChild: _tile(true, a),
                        onHover: (onHover) {},
                      ),
                    )
                    .toList(),
              ),
            );
          }),
    );
  }

  Widget emptySearch(bool hover, String searchTyping) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<CenterBoxProvider>(context, listen: false)
            .changeCurrentIndex(8);
        Provider.of<SearchDetailsProvider>(context, listen: false)
            .changeSearch(searchTyping);
      },
      child: Container(
        width: w * .23,
        height: h * .07,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: hover ? Colors.grey[400] : Colors.white)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey[200],
              child: Center(
                child: Icon(
                  LineAwesomeIcons.search,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: "SPProtext",
                ),
                text: S.of(context).searchFor,
                children: [
                  TextSpan(
                    text: searchTyping.length <= 20
                        ? searchTyping
                        : " ${searchTyping.substring(0, 20)}...",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                      fontFamily: "SPProtext",
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ).xShowPointerOnHover,
    );
  }
}
