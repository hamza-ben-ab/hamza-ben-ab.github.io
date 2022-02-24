import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/home/home_widgets/home_filter/data_topic.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:uy/services/provider/topic_provider.dart';

class ShowTopicList extends StatefulWidget {
  final bool interest;
  const ShowTopicList({
    Key key,
    this.interest,
  }) : super(key: key);

  @override
  _ShowTopicListState createState() => _ShowTopicListState();
}

class _ShowTopicListState extends State<ShowTopicList> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  ScrollController topicListController = ScrollController();
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();
  int firstCurrent = 1000;
  int secondCurrent = 1000;
  int currentIndex = 0;

  Widget deleteWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.red[900] : Colors.red[800]),
      child: Center(
        child: Icon(
          LineAwesomeIcons.times_circle_1,
          color: Colors.black,
          size: 30.0,
        ),
      ),
    );
  }

  Widget interestItemsWidget(bool hover, String title, int index) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: h * .06,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        margin: EdgeInsets.all(2.0),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext",
              color: Colors.grey[800],
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[100] : Colors.white,
          border: Border.all(
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  InkWell interestItems(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
        Provider.of<TopicProvider>(context, listen: false).goTo(index);
      },
      child: HoverWidget(
        child: interestItemsWidget(false, title, index),
        hoverChild: interestItemsWidget(true, title, index),
        onHover: (onHover) {},
      ).xShowPointerOnHover,
    );
  }

  Widget topicGeneralPart() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: h * .3,
      width: w * .5,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          runSpacing: 10.0,
          spacing: 10.0,
          children: [
            interestItems(S.of(context).interestWorld, 1),
            interestItems(S.of(context).interestBusiness, 2),
            interestItems(S.of(context).interestLifestyle, 3),
            interestItems(S.of(context).interestTechnology, 4),
            interestItems(S.of(context).interestSport, 5),
            interestItems(S.of(context).interestHealth, 6),
            interestItems(S.of(context).interestScience, 7),
            interestItems(S.of(context).interestEntertainment, 8),
            interestItems(S.of(context).interestAgriculture, 9),
            interestItems(S.of(context).interestMechanical, 10),
            interestItems(S.of(context).interestOther, 11),
          ],
        ),
      ),
    );
  }

  Widget subItemList(List<dynamic> list) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int index = Provider.of<TopicProvider>(context).index;
    return Container(
      height: h * .7,
      width: w * .5,
      child: ListView(
        children: [
          Container(
            height: h * .1,
            child: index != 0
                ? goToPreviousPage(index)
                : Container(
                    height: 0.0,
                    width: 0.0,
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              verticalDirection: VerticalDirection.down,
              runSpacing: 10.0,
              spacing: 10.0,
              children: [
                for (int i = 0; i < list.length; i++)
                  !widget.interest
                      ? HoverWidget(
                          child: topicItem(list[i], index, i, false),
                          hoverChild: topicItem(list[i], index, i, true),
                          onHover: (onHover) {},
                        )
                      : HoverWidget(
                          child: InterestItem(title: list[i], hover: false),
                          hoverChild: InterestItem(title: list[i], hover: true),
                          onHover: (onHover) {},
                        )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topicItem(String title, int first, int second, bool hover) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        setState(() {
          firstCurrent = first;
          secondCurrent = second;
        });
        Provider.of<TagPostProvider>(context, listen: false)
            .changeTagTopic(title);
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: h * .05,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "SPProtext",
                  fontSize: 14.0,
                  color: Colors.grey[800]),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            border: Border.all(
              color: (firstCurrent == first && secondCurrent == second)
                  ? Colors.blue
                  : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  Widget goBackWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Provider.of<TopicProvider>(context, listen: false).backTo(0);
      },
      child: Container(
        height: h * .05,
        width: h * .05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: hover ? Colors.grey[300] : Colors.grey[200],
        ),
        child: Center(
          child: Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget goToPreviousPage(int index) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .06,
      width: w * .45,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HoverWidget(
            child: goBackWidget(false),
            hoverChild: goBackWidget(true),
            onHover: (onHover) {},
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Center(
              child: Text(
                index == 0
                    ? S.of(context).topicButton
                    : index == 1
                        ? S.of(context).interestWorld
                        : index == 2
                            ? S.of(context).interestBusiness
                            : index == 3
                                ? S.of(context).interestLifestyle
                                : index == 4
                                    ? S.of(context).interestTechnology
                                    : index == 5
                                        ? S.of(context).interestSport
                                        : index == 6
                                            ? S.of(context).interestHealth
                                            : index == 7
                                                ? S.of(context).interestScience
                                                : index == 8
                                                    ? S
                                                        .of(context)
                                                        .interestEntertainment
                                                    : index == 9
                                                        ? S
                                                            .of(context)
                                                            .interestAgriculture
                                                        : index == 10
                                                            ? S
                                                                .of(context)
                                                                .interestMechanical
                                                            : S
                                                                .of(context)
                                                                .interestOther,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    fontFamily: "SPProtext"),
              ),
            ),
          ),
          HoverWidget(
            child: createPostAllFunctions.cancelButtonWidget(false, h, () {
              Navigator.of(context).pop();
            }),
            hoverChild: createPostAllFunctions.cancelButtonWidget(true, h, () {
              Navigator.of(context).pop();
            }),
            onHover: (onHover) {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int index = Provider.of<TopicProvider>(context).index;
    return Container(
      width: index == 0 ? w * .4 : w * .5,
      height: index == 0 ? h * .4 : h * .7,
      child: Column(
        children: [
          index == 0
              ? Directionality(
                  textDirection: intl.Bidi.detectRtlDirectionality(
                          S.of(context).notificationTitle)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Container(
                    height: h * .1,
                    padding:
                        EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        index != 0
                            ? goToPreviousPage(index)
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          width: w * .02,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              S.of(context).topicButton,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                  fontFamily: "SPProtext"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: HoverWidget(
                              child: deleteWidget(false),
                              hoverChild: deleteWidget(true),
                              onHover: (onHover) {}),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 0.0,
                  width: 0.0,
                ),
          index == 0
              ? topicGeneralPart()
              : index == 1
                  ? subItemList(worldList)
                  : index == 2
                      ? subItemList(businessList)
                      : index == 3
                          ? subItemList(lifeStyleList)
                          : index == 4
                              ? subItemList(technologyList)
                              : index == 5
                                  ? subItemList(sportList)
                                  : index == 6
                                      ? subItemList(healthList)
                                      : index == 7
                                          ? subItemList(scienceList)
                                          : index == 8
                                              ? subItemList(entertainmentList)
                                              : index == 9
                                                  ? subItemList(agricultureList)
                                                  : index == 10
                                                      ? subItemList(
                                                          mechanicList)
                                                      : index == 11
                                                          ? subItemList(
                                                              otherList)
                                                          : Container()
        ],
      ),
    );
  }
}

class InterestItem extends StatefulWidget {
  final String title;
  final bool hover;
  const InterestItem({Key key, this.title, this.hover}) : super(key: key);

  @override
  _InterestItemState createState() => _InterestItemState();
}

class _InterestItemState extends State<InterestItem> {
  bool selected = false;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        setState(() {
          selected = !selected;
        });
        if (selected) {
          users
              .doc(currentUser.uid)
              .collection("Interests")
              .doc(widget.title)
              .set({"data": widget.title});
        } else {
          users
              .doc(currentUser.uid)
              .collection("Interests")
              .doc(widget.title)
              .delete();
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: h * .05,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "SPProtext",
                  fontSize: 14.0,
                  color: Colors.grey[800]),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: widget.hover ? Colors.grey[200] : Colors.white,
            border: Border.all(
              color: selected ? Colors.blue : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
