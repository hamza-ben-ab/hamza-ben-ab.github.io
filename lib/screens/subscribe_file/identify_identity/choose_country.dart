import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/home/home_widgets/navigation_bar.dart';
import 'package:uy/screens/login_page/bottom_bar.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:intl/intl.dart' as intl;

class IdentifyIdentityChooseCountry extends StatefulWidget {
  const IdentifyIdentityChooseCountry({Key key}) : super(key: key);

  @override
  _IdentifyIdentityChooseCountryState createState() =>
      _IdentifyIdentityChooseCountryState();
}

class _IdentifyIdentityChooseCountryState
    extends State<IdentifyIdentityChooseCountry> {
  String idFile;
  List<DropdownMenuItem> dropDownList1;
  List<DropdownMenuItem> dropDownList2;
  var _selectedTest;
  var _selectedTest2;
  List _testList1 = [
    for (int i = 1; i < countryData.length; i++)
      {'no': i, 'keyword': countryData[i]}
  ];
  List _testList2 = [
    {'no': 1, 'keyword': "Passport"},
    {'no': 2, 'keyword': "National Id"},
    {'no': 3, 'keyword': "Driver's license"}
  ];

  @override
  void initState() {
    dropDownList1 = buildDropdownTestItems(_testList1);
    dropDownList2 = buildDropdownTestItems(_testList2);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem> items = [];

    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text("${i["no"]}-${i['keyword']}"),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedTest) {
    setState(() {
      _selectedTest = selectedTest;
    });
  }

  onChangeDropdownTests2(selectedTest) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _selectedTest2 = selectedTest;
      sharedPreferences.setString("idKind", _selectedTest2["no"].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            color: Colors.white,
            height: h,
            width: w,
            child: Column(
              children: [
                TeltrueAppBar(
                  backRoute: "/SignUpWithEmail",
                  nextRouteTitle: S.of(context).nextButton,
                ),
                Expanded(
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          height: h * .7,
                          width: largeScreen ? w * .4 : w * .6,
                          decoration: centerBoxDecoration,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: largeScreen ? w * .4 : w * .6,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Center(
                                  child: Text(
                                    S.of(context).uploadAproofOfidendity,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: largeScreen ? w * .4 : w * .6,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Center(
                                  child: Text(
                                    S.of(context).chooseCountryDes,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[700],
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: h * .02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Directionality(
                                  textDirection:
                                      intl.Bidi.detectRtlDirectionality(
                                              S.of(context).nextButton)
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                  child: Text(
                                    S.of(context).countryDropDowntitle,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                              ),
                              DropdownBelow(
                                boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                itemWidth: w * .23,
                                itemTextstyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "SPProtext",
                                    color: Colors.black),
                                boxTextstyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: "SPProtext",
                                ),
                                boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                                boxHeight: h * .06,
                                boxWidth: w * .23,
                                hint: Text(S.of(context).selectCountry),
                                value: _selectedTest,
                                items: dropDownList1,
                                onChanged: onChangeDropdownTests,
                              ),
                              SizedBox(
                                height: h * .02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Directionality(
                                  textDirection:
                                      intl.Bidi.detectRtlDirectionality(
                                              S.of(context).nextButton)
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                  child: Text(
                                    S.of(context).documentType,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontFamily: "SPProtext",
                                    ),
                                  ),
                                ),
                              ),
                              DropdownBelow(
                                boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                itemWidth: w * .23,
                                itemTextstyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "SPProtext",
                                    color: Colors.black),
                                boxTextstyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: "SPProtext",
                                ),
                                boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                                boxHeight: h * .06,
                                boxWidth: w * .23,
                                hint: Text(S.of(context).selectDocType),
                                value: _selectedTest2,
                                items: dropDownList2,
                                onChanged: onChangeDropdownTests2,
                              ),
                              SizedBox(
                                height: h * .1,
                              ),
                              InkWell(
                                child: HoverWidget(
                                    child: continueButtonWidget(
                                        false, _selectedTest, _selectedTest2),
                                    hoverChild: continueButtonWidget(
                                        true, _selectedTest, _selectedTest2),
                                    onHover: (onHover) {}),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BottomBarLoginWidget()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget continueButtonWidget(bool hover, dynamic select1, dynamic select2) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return select1 != null && select2 != null
        ? InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("identify_country", _selectedTest["keyword"]);
              prefs.setString("identify_type", _selectedTest2["keyword"]);
              Navigator.of(context).pushNamed("/VerifyYourIdentity2");
            },
            child: Container(
              height: h * .06,
              width: largeScreen ? w * .2 : w * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: hover ? Colors.blue[800] : Colors.blue),
              child: Center(
                child: Text(
                  S.of(context).confirmButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SPProtext",
                    fontSize: largeScreen ? 18.0 : 14.0,
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: h * .06,
            width: largeScreen ? w * .2 : w * .4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[200]),
            child: Center(
              child: Text(
                S.of(context).confirmButton,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontFamily: "SPProtext",
                  fontSize: largeScreen ? 18.0 : 14.0,
                ),
              ),
            ),
          );
  }
}
