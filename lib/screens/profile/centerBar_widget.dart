import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/services/provider/profile_centerBar_provider.dart';
import 'package:uy/screens/search/hover.dart';

class ProfilCenterBar extends StatefulWidget {
  const ProfilCenterBar({Key key}) : super(key: key);

  @override
  _ProfilCenterBarState createState() => _ProfilCenterBarState();
}

class _ProfilCenterBarState extends State<ProfilCenterBar> {
  InkWell buildProfileItems(
    int index,
    String title,
    bool hover,
  ) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int currentindex =
        Provider.of<ProfileCenterBarProvider>(context).currentIndex;
    return InkWell(
        onTap: () {
          Provider.of<ProfileCenterBarProvider>(context, listen: false)
              .changeIndex(index);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          height: h * 0.06,
          width: w * .07,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: h * 0.07,
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: index == currentindex
                              ? Color(0xFF505072)
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "SPProtext"),
                    ),
                  ),
                ),
              ),
              Container(
                height: 3.0,
                width: w * .03,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: index == currentindex
                      ? Color(0xFF505072)
                      : Colors.grey[200],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: hover ? Colors.grey[300] : Colors.grey[50]),
        ).xShowPointerOnHover);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .08,
      width: w * .63,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HoverWidget(
              child: buildProfileItems(
                  0, S.of(context).profilePublications, false),
              hoverChild:
                  buildProfileItems(0, S.of(context).profilePublications, true),
              onHover: (onHover) {}),
          HoverWidget(
              child: buildProfileItems(1, S.of(context).profileAbout, false),
              hoverChild:
                  buildProfileItems(1, S.of(context).profileAbout, true),
              onHover: (onHover) {}),
          HoverWidget(
              child:
                  buildProfileItems(2, S.of(context).profilePicAndVid, false),
              hoverChild:
                  buildProfileItems(2, S.of(context).profilePicAndVid, true),
              onHover: (onHover) {}),
          HoverWidget(
              child: buildProfileItems(3, S.of(context).profileVideo, false),
              hoverChild:
                  buildProfileItems(3, S.of(context).profileVideo, true),
              onHover: (onHover) {}),
        ],
      ),
    );
  }
}
