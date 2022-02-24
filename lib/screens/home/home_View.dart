import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/home/home_widgets/center_box.dart';
import 'package:uy/screens/home/home_widgets/left_menu_bar.dart';
import 'package:uy/screens/home/home_widgets/right_Bn_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'home_widgets/navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Directionality(
        textDirection:
            intl.Bidi.detectRtlDirectionality(S.of(context).copyRight)
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Container(
          height: h,
          width: w,
          color: Colors.white,
          child: Column(
            children: [
              NavigationBar(),
              Expanded(
                child: Container(
                    color: Colors.grey[200],
                    width: w,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: h * .93,
                            child: Row(
                              children: [
                                LeftMenuBar(),
                                CenterBox(),
                              ],
                            ),
                          ),
                        ),
                        RightBreakingNewsBar(),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
