import 'dart:async';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/options/tagPlace.dart';
import 'package:uy/services/functions.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart' as intl;

class TagPersonOrEvent extends StatefulWidget {
  final String tag;
  const TagPersonOrEvent({
    Key key,
    this.tag,
  }) : super(key: key);

  @override
  _TagPersonOrEventState createState() => _TagPersonOrEventState();
}

class _TagPersonOrEventState extends State<TagPersonOrEvent> {
  String person;
  String event;
  TextEditingController tagPersonOrEventController = TextEditingController();
  CollectionReference allPub = FirebaseFirestore.instance.collection('AllPub');
  List searchList = [];
  List finalSearchList = [];
  List<String> firstSearchList = [];
  FunctionsServices functionsServices = FunctionsServices();

  Future<void> getSearchResult(String searchTyping) async {
    firstSearchList = [];
    finalSearchList = [];
    searchList = [];
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("AllPub");

    QuerySnapshot querySnapshot = await _collectionRef.get();
    final seen = Set<String>();

    setState(() {
      var results = querySnapshot.docs.where(
          (a) => a.data()[widget.tag == "person" ? "person" : "event"] != null);

      results
          .map((doc) => firstSearchList
              .add(doc.data()[widget.tag == "person" ? "person" : "event"]))
          .toList();
      print(firstSearchList.length);

      firstSearchList.retainWhere(
        (item) => item.toLowerCase().contains(
              searchTyping.toLowerCase(),
            ),
      );

      finalSearchList = firstSearchList.where((str) => seen.add(str)).toList();

      for (int index = 0; index < finalSearchList.length; index++) {
        int count = 0;

        for (int i = 0; i < firstSearchList.length; i++) {
          if (finalSearchList[index] == firstSearchList[i]) {
            count += 1;
          }
        }

        searchList.add([finalSearchList[index], count]);
      }
    });
  }

  Widget tagPersonTextField() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
      height: h * .05,
      width: w * .4,
      child: TextFormField(
        onChanged: (value) {
          value = tagPersonOrEventController.value.text;
          getSearchResult(value);
        },
        controller: tagPersonOrEventController,
        autofocus: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontFamily: "SPProtext",
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400], width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          hintText: widget.tag == "event"
              ? S.of(context).addPostSearchEventHint
              : S.of(context).addPostSearchPersonHint,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            fontFamily: "SPProtext",
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w,
      height: h,
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(height: h * .08),
        Container(
          height: h * .05,
          width: w,
          child: Center(
            child: Container(
              height: h * .05,
              width: w * .6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: h * .05,
                      width: w * .08,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).cancelButton,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SPProtext"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  tagPersonTextField(),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    child: HoverWidget(
                        child: addbuttonWidget(false),
                        hoverChild: addbuttonWidget(true),
                        onHover: (onHover) {}),
                    onTap: () async {
                      widget.tag == "person"
                          ? Provider.of<TagPostProvider>(context, listen: false)
                              .changeTagPerson(
                              tagPersonOrEventController.text.trim(),
                            )
                          : Provider.of<TagPostProvider>(context, listen: false)
                              .changeTagEvent(
                              tagPersonOrEventController.text.trim(),
                            );

                      Navigator.of(context).pop();
                      tagPersonOrEventController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: h * .02,
        ),
        searchDelegateWidget(),
        SizedBox(
          height: h * .02,
        ),
      ]),
    );
  }

  Widget searchDelegateWidget() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .45,
      height: h * .8,
      child: tagPersonOrEventController.text.isEmpty
          ? Container(
              child: Center(
                child: Text(
                  S.of(context).tagTypeToSearch,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: "SPProtext",
                  ),
                ),
              ),
            )
          : finalSearchList.isEmpty
              ? Center(
                  child: Text(
                    S.of(context).tagNoTagSearchFound,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: "SPProtext",
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: finalSearchList.length,
                  itemBuilder: (context, index) {
                    return searchDelegateItem(
                        searchList[index][0], searchList[index][1]);
                  }),
    );
  }

  Widget addbuttonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? Colors.grey[300] : Colors.grey[200],
      ),
      height: h * .06,
      width: h * .06,
      child: Center(
        child: Icon(LineAwesomeIcons.plus, color: Colors.black),
      ),
    );
  }

  Widget searchDelegateItem(String title, int count) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: w * .4,
        height: h * .1,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: w * .28,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    tagPersonOrEventController.text.isNotEmpty
                        ? Expanded(
                            child: DynamicTextHighlighting(
                              text: title.toLowerCase(),
                              highlights: [
                                tagPersonOrEventController.value.text
                                    .toLowerCase()
                              ],
                              color: Colors.green,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: "SPProtext",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "${S.of(context).tagSearchNumberOf} ${functionsServices.dividethousand(count)}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12.0,
                          fontFamily: "SPProtext",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            HoverWidget(
                child: useButton(false, title),
                hoverChild: useButton(true, title),
                onHover: (onHover) {})
          ],
        ),
      ),
    );
  }

  Widget useButton(bool hover, title) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .1,
      width: w * .12,
      child: Center(
        child: InkWell(
          onTap: () {
            widget.tag == "person"
                ? Provider.of<TagPostProvider>(context, listen: false)
                    .changeTagPerson(
                    title,
                  )
                : Provider.of<TagPostProvider>(context, listen: false)
                    .changeTagEvent(
                    title,
                  );

            Navigator.of(context).pop();
            tagPersonOrEventController.clear();
          },
          child: Container(
            height: h * .05,
            width: w * .06,
            decoration: BoxDecoration(
              color: hover ? buttonColorHover : buttonColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                S.of(context).useButton,
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowFeeling extends StatefulWidget {
  const ShowFeeling({Key key}) : super(key: key);

  @override
  _ShowFeelingState createState() => _ShowFeelingState();
}

class _ShowFeelingState extends State<ShowFeeling> {
  int currentIndex = 1000;

  Widget feelingItem(int index, String feel, String smile, bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        setState(() {
          currentIndex = index;
        });
        Provider.of<TagPostProvider>(context, listen: false)
            .changeTagFeeling(feel, smile);
        Navigator.of(context).pop();
      },
      child: Container(
        height: h * .05,
        width: w * .1,
        margin: EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: h * .035,
              width: h * .035,
              child: Center(
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage:
                      ExactAssetImage("./assets/images/feeling/$smile.png"),
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Container(
              height: h * .05,
              child: Center(
                child: Text(
                  feel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "SPProtext",
                      fontSize: 14.0,
                      color: currentIndex == index
                          ? Colors.white
                          : Colors.grey[800]),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: hover ? Colors.blue : Colors.grey[400]),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .5,
      width: w * .4,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            runSpacing: 10.0,
            spacing: 10.0,
            children: [
              HoverWidget(
                  child: feelingItem(
                      0, S.of(context).feelingHappy, "001-happy-18", false),
                  hoverChild: feelingItem(
                      0, S.of(context).feelingHappy, "001-happy-18", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      1, S.of(context).feelingCool, "002-cool-5", false),
                  hoverChild: feelingItem(
                      1, S.of(context).feelingCool, "002-cool-5", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(2, S.of(context).feelingSurprised,
                      "004-surprised-9", false),
                  hoverChild: feelingItem(2, S.of(context).feelingSurprised,
                      "004-surprised-9", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      3, S.of(context).feelingShocked, "005-shocked-4", false),
                  hoverChild: feelingItem(
                      3, S.of(context).feelingShocked, "005-shocked-4", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      4, S.of(context).feelingNervous, "007-nervous-2", false),
                  hoverChild: feelingItem(
                      4, S.of(context).feelingNervous, "007-nervous-2", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      5, S.of(context).feelingAngry, "036-angry-4", false),
                  hoverChild: feelingItem(
                      5, S.of(context).feelingAngry, "036-angry-4", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      6, S.of(context).feelingDrool, "010-drool", false),
                  hoverChild: feelingItem(
                      6, S.of(context).feelingDrool, "010-drool", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      8, S.of(context).feelingSweat, "024-sweat-1", false),
                  hoverChild: feelingItem(
                      8, S.of(context).feelingSweat, "024-sweat-1", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      9, S.of(context).feelingCrying, "030-crying-8", false),
                  hoverChild: feelingItem(
                      9, S.of(context).feelingCrying, "030-crying-8", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      10, S.of(context).feelingSad, "035-sad-14", false),
                  hoverChild: feelingItem(
                      10, S.of(context).feelingSad, "035-sad-14", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      11, S.of(context).feelingDead, "044-dead-1", false),
                  hoverChild: feelingItem(
                      11, S.of(context).feelingDead, "044-dead-1", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      12, S.of(context).feelingDubious, "046-dubious", false),
                  hoverChild: feelingItem(
                      12, S.of(context).feelingDubious, "046-dubious", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      13, S.of(context).feelingTired, "053-tired-1", false),
                  hoverChild: feelingItem(
                      13, S.of(context).feelingTired, "053-tired-1", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      14, S.of(context).feelingLoved, "074-in-love-10", false),
                  hoverChild: feelingItem(
                      14, S.of(context).feelingLoved, "074-in-love-10", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      15, S.of(context).feelingPain, "081-pain", false),
                  hoverChild: feelingItem(
                      15, S.of(context).feelingPain, "081-pain", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      16, S.of(context).feelingMuted, "111-muted-3", false),
                  hoverChild: feelingItem(
                      16, S.of(context).feelingMuted, "111-muted-3", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      17, S.of(context).feelingGreed, "119-greed", false),
                  hoverChild: feelingItem(
                      17, S.of(context).feelingGreed, "119-greed", true),
                  onHover: (onHover) {}),
              HoverWidget(
                  child: feelingItem(
                      18, S.of(context).feelingSick, "151-sick-1", false),
                  hoverChild: feelingItem(
                      18, S.of(context).feelingSick, "151-sick-1", true),
                  onHover: (onHover) {}),
            ]),
      ),
    );
  }
}

class CreatePostAllFunctions {
  Widget addbuttonWidget(bool hover, double h) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        shape: BoxShape.circle,
        color: hover ? Colors.grey[200] : Colors.white,
      ),
      height: h * .06,
      width: h * .06,
      child: Center(
        child: Icon(LineAwesomeIcons.plus, color: Colors.black),
      ),
    );
  }

  Widget uploadButton(
      bool hover, double h, double w, Function function, String title) {
    return InkWell(
      onTap: () async {
        function();
      },
      child: Container(
        height: h * .06,
        width: w * .12,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(LineAwesomeIcons.file_upload, color: accentColor),
          Text(
            title,
            style: TextStyle(
                color: accentColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          )
        ]),
      ),
    );
  }

  Widget tagPersonButton(bool hover, double h, double w) {
    return OpenContainer(
      transitionDuration: Duration(seconds: 1),
      openColor: Colors.grey[50],
      closedColor: Colors.grey[200],
      openBuilder: (context, _) => TagPersonOrEvent(
        tag: "person",
      ),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      closedBuilder: (context, openContainer) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: h * .06,
        width: w * .12,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(LineAwesomeIcons.user_circle, color: accentColor),
          SizedBox(
            width: 8.0,
          ),
          Text(
            S.of(context).tagPerson,
            style: TextStyle(
                color: accentColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          )
        ]),
      ),
    ).xShowPointerOnHover;
  }

  Widget tagEventButton(bool hover, double h, double w) {
    return OpenContainer(
      transitionDuration: Duration(seconds: 1),
      openColor: Colors.grey[200],
      closedColor: Colors.grey[200],
      openBuilder: (context, _) => TagPersonOrEvent(
        tag: "event",
      ),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      closedBuilder: (context, openContainer) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: h * .06,
        width: w * .12,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(LineAwesomeIcons.calendar_check, color: accentColor),
          SizedBox(
            width: 8.0,
          ),
          Text(
            S.of(context).tagEvent,
            style: TextStyle(
                color: accentColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          )
        ]),
      ),
    ).xShowPointerOnHover;
  }

  Widget tagPlaceButton(bool hover, double h, double w) {
    return OpenContainer(
      transitionDuration: Duration(seconds: 1),
      openColor: Colors.grey[50],
      closedColor: Colors.grey[200],
      openBuilder: (context, _) => TagPlace(),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      closedBuilder: (context, openContainer) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: h * .06,
        width: w * .12,
        decoration: BoxDecoration(
          color: hover ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(Icons.location_on, color: accentColor),
          SizedBox(
            width: 8.0,
          ),
          Text(
            S.of(context).tagPlace,
            style: TextStyle(
                color: accentColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "SPProtext"),
          )
        ]),
      ),
    ).xShowPointerOnHover;
  }

  Widget topicButton(bool hover, double h, double w, String title) {
    return Container(
      height: h * .06,
      width: w * .12,
      decoration: BoxDecoration(
        color: hover ? Colors.grey[300] : Colors.grey[200],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Icon(
          LineAwesomeIcons.hashtag,
          color: accentColor,
        ),
        Text(
          title,
          style: TextStyle(
              color: accentColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        )
      ]),
    ).xShowPointerOnHover;
  }

  Widget topicWidget(double h, String topic) {
    return Container(
      height: h * .03,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            LineAwesomeIcons.hashtag,
            color: accentColor,
            size: 20.0,
          ),
          SizedBox(
            width: 1.0,
          ),
          Text(
            topic,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12.0,
              fontFamily: "SPProtext",
            ),
          ),
        ],
      ),
    );
  }

  Widget feelingButton(bool hover, String title, double h, double w) {
    return Container(
      height: h * .06,
      width: w * .12,
      decoration: BoxDecoration(
        color: hover ? Colors.grey[300] : Colors.grey[200],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Icon(LineAwesomeIcons.smiling_face, color: accentColor),
        Text(
          title,
          style: TextStyle(
              color: accentColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext"),
        )
      ]),
    ).xShowPointerOnHover;
  }

  Widget tagPerson(double w, String tagPerson) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      width: w * .34,
      child: (tagPerson != null)
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(
                LineAwesomeIcons.user_circle,
                color: accentColor,
                size: 20.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    tagPerson,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.0,
                      fontFamily: "SPProtext",
                    ),
                  ),
                ),
              )
            ])
          : Container(
              height: 0.0,
              width: 0.0,
            ),
    );
  }

  Widget tagEvent(double w, String tagEvent) {
    return Container(
      width: w * .34,
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: (tagEvent != null)
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(
                LineAwesomeIcons.calendar_check,
                color: accentColor,
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    tagEvent,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.0,
                        fontFamily: "SPProtext"),
                  ),
                ),
              )
            ])
          : Container(
              height: 0.0,
              width: 0.0,
            ),
    );
  }

  Widget tagPlace(double w, String tagPlace) {
    return Container(
      width: w * .34,
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: (tagPlace != null)
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(Icons.location_on, color: accentColor),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    tagPlace,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.0,
                        fontFamily: "SPProtext"),
                  ),
                ),
              )
            ])
          : Container(
              height: 0.0,
              width: 0.0,
            ),
    );
  }

  Widget tagFeeling(double h, double w, String smile, String feeling) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      width: w * .35,
      child: (feeling != null && smile != null)
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: h * .05,
                margin: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: h * .035,
                      width: h * .035,
                      child: Center(
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: ExactAssetImage(
                              "./assets/images/feeling/$smile.png"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.0,
                    ),
                    Container(
                      height: h * .05,
                      child: Center(
                        child: Text(
                          feeling,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "SPProtext",
                              fontSize: 14.0,
                              color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
            ])
          : Container(
              height: 0.0,
              width: 0.0,
            ),
    );
  }

  Widget doneButton(double h, double w, String title, Function function) {
    return InkWell(
      child: HoverWidget(
          child: Container(
            height: h * .04,
            width: w * .08,
            decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontFamily: "SPProtext",
                ),
              ),
            ),
          ),
          hoverChild: Container(
            height: h * .04,
            width: w * .08,
            decoration: BoxDecoration(
              color: Colors.green[400],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontFamily: "SPProtext"),
              ),
            ),
          ),
          onHover: (onHover) {}),
      onTap: () async {
        function();
      },
    );
  }

  void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'$https://firebasestorage.googleapis.com/v0/b/dial-in-2345.appspot.com/o/'),
        '');

    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

    firebase_storage.Reference storageReferance =
        FirebaseStorage.instance.ref();

    storageReferance
        .child(filePath)
        .delete()
        .then((_) => print('Successfully deleted $filePath storage item'));
  }

  cancelButtonWidget(
    bool hover,
    double h,
    Function function,
  ) {
    return InkWell(
      child: Container(
        height: h * .04,
        width: h * .04,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.red[400] : Colors.red[300],
        ),
        child: Center(
          child: Icon(
            LineAwesomeIcons.times_circle_1,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
      onTap: () {
        function();
      },
    );
  }

  closeNewsButtonWidget(
    bool hover,
    double h,
    double w,
    String title,
    Function function,
  ) {
    return InkWell(
      child: Container(
        height: h * .045,
        width: w * .12,
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[200] : Colors.grey[50],
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            fontFamily: "SPProtext",
            fontWeight: FontWeight.w500,
          ),
        )),
      ),
      onTap: () {
        function();
      },
    );
  }

  unDoneDialog(
      double h,
      double w,
      BuildContext context,
      String title,
      String des,
      String discard,
      String cancel,
      Function discardFunction,
      Function cancelFunction) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          // "Discard Post",
        ),
        titleTextStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            fontFamily: "SPProtext",
            fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: Text(
          des,
          //"This can’t be undone and you’ll lose your draft.",
          style: TextStyle(
              fontSize: 14.0, color: Colors.black, fontFamily: "SPProtext"),
        ),
        actions: <Widget>[
          InkWell(
            child: HoverWidget(
                child: Container(
                  height: h * .05,
                  width: w * .08,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      discard,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Colors.white,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
                hoverChild: Container(
                  height: h * .05,
                  width: w * .08,
                  decoration: BoxDecoration(
                    color: buttonColorHover,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      discard,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Colors.white,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
                onHover: (onHover) {}),
            onTap: () {
              discardFunction();
            },
          ),
          InkWell(
            child: HoverWidget(
                child: Container(
                  height: h * .05,
                  width: w * .08,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      cancel,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Colors.black,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
                hoverChild: Container(
                  height: h * .05,
                  width: w * .08,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      cancel,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Colors.black,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
                onHover: (onHover) {}),
            onTap: () {
              cancelFunction();
            },
          ),
        ],
      ),
    );
  }
}

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String errorText;
  final bool validate;
  final Function func;
  final bool condition;
  final String errorCondition;
  const TextFormFieldWidget(
      {Key key,
      this.controller,
      this.hintText,
      this.errorText,
      this.validate,
      this.func,
      this.condition,
      this.errorCondition})
      : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  String currentValue;
  @override
  void initState() {
    currentValue = widget.controller.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.func != null
          ? widget.func
          : () {
              setState(() {});
            },
      textDirection: intl.Bidi.detectRtlDirectionality(widget.hintText)
          ? TextDirection.rtl
          : TextDirection.ltr,
      controller: widget.controller,
      expands: true,
      maxLines: null,
      minLines: null,
      maxLength: null,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontFamily: "SPProtext",
      ),
      keyboardType: TextInputType.text,
      validator: (text) {
        if (widget.validate && text.isEmpty) {
          return widget.errorText;
        }
        if (widget.condition != null && !widget.condition) {
          return widget.errorCondition;
        }

        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 14,
          height: 0.6,
        ),
        isDense: true,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        fillColor: Colors.white,
        filled: true,
        labelText: widget.hintText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontFamily: "SPProtext",
          letterSpacing: 1.2,
        ),
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontFamily: "SPProtext",
          letterSpacing: 1.2,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[600], width: 0.2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[600],
            width: 0.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        hintTextDirection: intl.Bidi.detectRtlDirectionality(widget.hintText)
            ? TextDirection.rtl
            : TextDirection.ltr,
      ),
    );
  }
}

class TextFormFieldLengthLimitedWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int lengthLimit;
  const TextFormFieldLengthLimitedWidget(
      {Key key, this.controller, this.hintText, @required this.lengthLimit})
      : super(key: key);

  @override
  _TextFormFieldLengthLimitedWidgetState createState() =>
      _TextFormFieldLengthLimitedWidgetState();
}

class _TextFormFieldLengthLimitedWidgetState
    extends State<TextFormFieldLengthLimitedWidget> {
  String currentValue;
  @override
  void initState() {
    currentValue = widget.controller.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: null,
      minLines: null,
      expands: true,
      onFieldSubmitted: (newValue) {
        setState(() {
          currentValue = newValue;
        });
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.lengthLimit),
      ],
      style: TextStyle(
          color: Colors.black, fontSize: 16.0, fontFamily: "SPProtext"),
      keyboardType: TextInputType.text,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        isDense: true,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        fillColor: Colors.white,
        filled: true,
        hoverColor: Colors.grey[100],
        labelText: widget.hintText,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[600], letterSpacing: 1.2),
        labelStyle: TextStyle(
          backgroundColor: Colors.transparent,
          height: 0.8,
          color: Colors.black,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 0.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 0.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 0.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: accentColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        hintTextDirection: intl.Bidi.detectRtlDirectionality(widget.hintText)
            ? TextDirection.rtl
            : TextDirection.ltr,
      ),
    );
  }
}
