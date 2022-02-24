import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/home/home_widgets/home_filter/data_topic.dart';
import 'package:uy/screens/search/hover.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:uy/services/provider/home_partProvider.dart';
import 'package:uy/services/provider/read_filter_provider.dart';
import 'package:uy/services/provider/watch_filter_provider.dart';
import 'package:intl/intl.dart' as intl;

class InterestList extends StatefulWidget {
  const InterestList({
    Key key,
  }) : super(key: key);
  @override
  _InterestListState createState() => _InterestListState();
}

class _InterestListState extends State<InterestList> {
  int currentIndex = 0;
  List<Widget> generalInterestList;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  Widget showInterestList(List<String> list, String title) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * .24,
      height: h * .5,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: SingleChildScrollView(
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          runSpacing: 10.0,
          spacing: 10.0,
          children: [
            for (int i = 0; i < list.length; i++)
              HoverWidget(
                child: FilterNestedItems(title: list[i], hover: false),
                hoverChild: FilterNestedItems(title: list[i], hover: true),
                onHover: (onHover) {},
              )
          ],
        ),
      ),
    );
  }

  InkWell interestItemsAll(String title, int index, List<String> list) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = 0;
        });
        Provider.of<FilterProvider>(context, listen: false).emptyFilterString();
      },
      child: HoverWidget(
        child: interestItemsWidget(false, title, index, list),
        hoverChild: interestItemsWidget(true, title, index, list),
        onHover: (onHover) {},
      ).xShowPointerOnHover,
    );
  }

  Widget interestItemsWidget(
      bool hover, String title, int index, List<dynamic> list) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(children: [
      Directionality(
        textDirection:
            intl.Bidi.detectRtlDirectionality(S.of(context).interestAll)
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Container(
          width: w * .22,
          height: h * .07,
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          margin: EdgeInsets.all(2.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: w * .217,
                height: h * .06,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SPProtext",
                        color: Colors.black),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: h * .03,
                  width: 3.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color:
                        index == currentIndex ? accentColor : Colors.grey[50],
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey[400]),
            color: hover ? Colors.grey[200] : Colors.white,
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      currentIndex == index && currentIndex != 0
          ? showInterestList(list, title)
          : Container(
              height: 0.0,
              width: 0.0,
            )
    ]);
  }

  InkWell interestItems(String title, int index, List<dynamic> list) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: HoverWidget(
              child: interestItemsWidget(false, title, index, list),
              hoverChild: interestItemsWidget(true, title, index, list),
              onHover: (onHover) {})
          .xShowPointerOnHover,
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    FilterProviderChangeState filter =
        Provider.of<FilterProviderChangeState>(context);

    generalInterestList = [
      interestItemsAll(S.of(context).interestAll, 0, alltopic),
      interestItems(S.of(context).interestWorld, 1, worldList),
      interestItems(S.of(context).interestBusiness, 2, businessList),
      interestItems(S.of(context).interestLifestyle, 3, lifeStyleList),
      interestItems(S.of(context).interestTechnology, 4, technologyList),
      interestItems(S.of(context).interestSport, 5, sportList),
      interestItems(S.of(context).interestHealth, 6, healthList),
      interestItems(S.of(context).interestScience, 7, scienceList),
      interestItems(S.of(context).interestEntertainment, 8, entertainmentList),
      interestItems(S.of(context).interestAgriculture, 9, agricultureList),
      interestItems(S.of(context).interestMechanical, 10, mechanicList),
      interestItems(S.of(context).interestOther, 11, otherList),
    ];

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.linearToEaseOut,
        width: filter.activeFilter ? w * .24 : 0.0,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          width: w * .24,
          height: h * .93,
          child: ListView(
            children: [
              Container(
                height: h * .06,
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S.of(context).filter,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        fontFamily: "SPProtext"),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              AnimationLimiter(
                child: ListView.builder(
                  itemCount: 12,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    right: 15.0,
                    top: 5.0,
                    left: 8.0,
                    bottom: 10.0,
                  ),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(seconds: 2),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: SlideAnimation(
                          child: generalInterestList[index] != null
                              ? generalInterestList[index]
                              : Container(
                                  height: 0.0,
                                  width: 0.0,
                                ).xShowPointerOnHover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterNestedItems extends StatefulWidget {
  final bool hover;
  final String title;

  const FilterNestedItems({Key key, this.title, this.hover}) : super(key: key);

  @override
  _FilterNestedItemsState createState() => _FilterNestedItemsState();
}

class _FilterNestedItemsState extends State<FilterNestedItems> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    int currentIndex = context.watch<HomePartIndexProvider>().currentIndex;
    return InkWell(
      onTap: () {
        print(Provider.of<WatchFilterProvider>(context, listen: false)
            .filterString);
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected && currentIndex == 0) {
          Provider.of<FilterProvider>(context, listen: false)
              .updateFilterString(widget.title);
        } else if (isSelected && currentIndex == 1) {
          Provider.of<WatchFilterProvider>(context, listen: false)
              .updateFilterString(widget.title);
        } else {
          Provider.of<FilterProvider>(context, listen: false)
              .removeFilterString(widget.title);
          Provider.of<WatchFilterProvider>(context, listen: false)
              .removeFilterString(widget.title);
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
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.grey[700] : Colors.blue,
              ),
            ),
          ),
          decoration: BoxDecoration(
            border:
                Border.all(color: !isSelected ? Colors.grey[300] : Colors.blue),
            borderRadius: BorderRadius.circular(15.0),
            color: !widget.hover ? Colors.white : Colors.grey[100],
          ),
        ),
      ),
    );
  }
}
