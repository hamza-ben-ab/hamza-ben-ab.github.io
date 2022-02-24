import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/login_page/lang_items.dart';
import 'package:uy/services/responsiveLayout.dart';

class LoginPageAppBar extends StatefulWidget {
  final Widget child;
  const LoginPageAppBar({Key key, this.child}) : super(key: key);

  @override
  _LoginPageAppBarState createState() => _LoginPageAppBarState();
}

class _LoginPageAppBarState extends State<LoginPageAppBar> {
  bool hoverClick = false;
  String stringValue;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringValue = Locale(prefs.getString('langkey')).toString();
    });
  }

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      padding: EdgeInsets.only(left: w * .02, right: w * .01),
      height: h * .07,
      width: w,
      color: Colors.blue,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: h * .07,
            child: Center(
              child: Text(
                "Telltrue",
                style: TextStyle(
                  fontFamily: "MarckScript",
                  fontSize: largeScreen ? 40.0 : 30,
                  color: Color(0xFF388087),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              height: h * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //language
                  InkWell(
                    onTap: () {
                      showLang();
                    },
                    child: HoverWidget(
                      child: languageitemAppBar(false),
                      hoverChild: languageitemAppBar(true),
                      onHover: (onHover) {},
                    ),
                  ),
                  SizedBox(
                    width: w * .02,
                  ),
                  //about Us
                  InkWell(
                    onTap: () {},
                    child: HoverWidget(
                        child: aboutUsWidget(false),
                        hoverChild: aboutUsWidget(true),
                        onHover: (onHover) {}),
                  ),
                  SizedBox(
                    width: w * .02,
                  ),
                  //contact Us
                  InkWell(
                    onTap: () {},
                    child: HoverWidget(
                        child: contactUs(false),
                        hoverChild: contactUs(true),
                        onHover: (onHover) {}),
                  ),
                  SizedBox(
                    width: w * .02,
                  ),
                  //signUp
                  HoverWidget(
                      child: signUpButton(false),
                      hoverChild: signUpButton(true),
                      onHover: (onHover) {}),
                  SizedBox(
                    width: w * .02,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLang() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: h * .6,
              width: w * .5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Container(
                  width: largeScreen ? w * .5 : w * .7,
                  height: h * .5,
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        runSpacing: 10.0,
                        spacing: 10.0,
                        children: [
                          languageItemHover("Arabic", 0),
                          languageItemHover("Bengali-বাংলা", 1),
                          languageItemHover("German-Deutsche", 2),
                          languageItemHover("Greek-Ελληνικά", 3),
                          languageItemHover("English", 4),
                          languageItemHover("Spanish", 5),
                          languageItemHover("French", 6),
                          languageItemHover("Hindi-हिंदी", 7),
                          languageItemHover("Indonesian-bahasa Indonesia", 8),
                          languageItemHover("Italian", 9),
                          languageItemHover("Japanese-日本語", 10),
                          languageItemHover("Korean-한국어", 11),
                          languageItemHover("Panjabi-ਪੰਜਾਬੀ", 12),
                          languageItemHover("Portuguese", 13),
                          languageItemHover("Russian", 14),
                          languageItemHover("Turkish", 15),
                          languageItemHover("Chinese-中国人", 16),
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget contactUs(bool hover) {
    double h = MediaQuery.of(context).size.height;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: h * .08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: hover ? Colors.blue : Colors.grey[400],
        ),
      ),
      //  width: largeScreen ? w * .05 : w * .08,
      child: Center(
        child: Text(
          S.of(context).contactUs,
          style: TextStyle(
            fontFamily: "SPProtext",
            fontSize: largeScreen ? 14.0 : 12.0,
            color: hover ? Colors.blue : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget aboutUsWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: hover ? Colors.blue : Colors.grey[400],
        ),
      ),
      height: h * .08,
      child: Center(
        child: Text(
          S.of(context).aboutUs,
          style: TextStyle(
            fontFamily: "SPProtext",
            fontSize: largeScreen ? 14.0 : 12.0,
            color: hover ? Colors.blue : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget languageitemAppBar(bool hover) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: hover ? Colors.blue : Colors.grey[400],
        ),
      ),
      height: h * .08,
      //width: largeScreen ? w * .05 : w * .08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.language_rounded,
            color: hover ? Colors.blue : Colors.grey[700],
            size: largeScreen ? 25.0 : 15.0,
          ),
          Text(
            stringValue ?? "en",
            style: TextStyle(
              fontFamily: "SPProtext",
              fontSize: largeScreen ? 14.0 : 12.0,
              color: hover ? Colors.blue : Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }

  Widget languageItemHover(String title, int index) {
    return HoverWidget(
        child: LangItem(
          index: index,
          width: .15,
          title: title,
          hover: false,
        ),
        hoverChild: LangItem(
          index: index,
          width: .15,
          title: title,
          hover: true,
        ),
        onHover: (onHover) {});
  }

  Widget signUpButton(bool hover) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/Sign_Up_choice");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: hover ? Colors.blue : Colors.grey[400],
          ),
        ),
        height: h * .08,
        child: Center(
          child: Text(
            S.of(context).signUpFlatButtonLoginPage,
            style: TextStyle(
              color: hover ? Colors.blue : Colors.grey[700],
              fontFamily: "SPProtext",
              fontSize: largeScreen ? 14.0 : 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
