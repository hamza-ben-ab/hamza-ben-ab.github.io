import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/search/event_key.dart';
import 'package:uy/screens/search/pub/pub_extent.dart';
import 'package:uy/screens/search/pub/pub_in_all.dart';
import 'package:uy/screens/search/pubtag_key.dart';
import 'package:uy/screens/search/user_key.dart';
import 'package:uy/services/provider/search_details_provider.dart';

class SearchDetailsPage extends StatefulWidget {
  const SearchDetailsPage({Key key}) : super(key: key);

  @override
  _SearchDetailsPageState createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);

  Widget searchFilterItemWidget(bool hover, int index, String title) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int currentIndex = Provider.of<SearchDetailsProvider>(context).currentIndex;
    return Container(
      height: h * .07,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800],
                  fontFamily: "SPProtext",
                ),
              ),
            ),
          ),
          Container(
            height: 3.0,
            width: w * .02,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: index == currentIndex ? accentColor : Colors.white,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: hover ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey[400]),
      ),
    );
  }

  InkWell searchFilterItems(int index, String title) {
    return InkWell(
        child: HoverWidget(
          child: searchFilterItemWidget(false, index, title),
          hoverChild: searchFilterItemWidget(true, index, title),
          onHover: (onHover) {},
        ),
        onTap: () {
          Provider.of<SearchDetailsProvider>(context, listen: false)
              .changeIndex(index);
        });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int currentIndex = Provider.of<SearchDetailsProvider>(context).currentIndex;
    return Container(
      width: w * .63,
      height: h * .91,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: h * .07,
            width: w * .63,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                searchFilterItems(0, S.of(context).all),
                searchFilterItems(1, S.of(context).telltrueUser),
                searchFilterItems(
                  2,
                  S.of(context).profilePublications,
                ),
                searchFilterItems(3, S.of(context).famousPersonIdentified),
                searchFilterItems(4, S.of(context).eventIdentified),
                searchFilterItems(5, S.of(context).placeIdentified),
                searchFilterItems(6, S.of(context).tagEvent),
              ],
            ),
          ),
          Container(
            width: w * .63,
            height: h * .84,
            child: currentIndex == 0
                ? Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: true,
                    radius: Radius.circular(20.0),
                    child: ListView(
                      cacheExtent: h * 4,
                      controller: scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        SearchUsersKey(
                          whereString: 'full_name',
                          title: S.of(context).telltrueUser,
                        ),
                        SearchPublicationKey(),
                        SearchPublicFigureKey(
                          title: S.of(context).famousPersonIdentified,
                          whereField: "person",
                        ),
                        SearchPublicFigureKey(
                          searchItem: S.of(context).tagEvent,
                          title: S.of(context).eventIdentified,
                          whereField: "event",
                        ),
                        SearchPublicFigureKey(
                          searchItem: S.of(context).tagPlace,
                          title: S.of(context).placeIdentified,
                          whereField: "place",
                        ),
                        SearchEventsKey(),
                      ],
                    ),
                  )
                : currentIndex == 1
                    ? SearchUsersKeyExtent(
                        whereString: 'full_name',
                        title: S.of(context).telltrueUser)
                    : currentIndex == 2
                        ? SearchPublicationKeyExtent()
                        : currentIndex == 3
                            ? SearchPublicFigureKeyExtent(
                                whereField: "person",
                              )
                            : currentIndex == 4
                                ? SearchPublicFigureKeyExtent(
                                    searchItem: S.of(context).tagEvent,
                                    whereField: "event",
                                  )
                                : currentIndex == 5
                                    ? SearchPublicFigureKeyExtent(
                                        searchItem: S.of(context).tagPlace,
                                        whereField: "place",
                                      )
                                    : currentIndex == 6
                                        ? SearchEventsKeyExtent()
                                        : Container(),
          )
        ],
      ),
    );
  }
}
