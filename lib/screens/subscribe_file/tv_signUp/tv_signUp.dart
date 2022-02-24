import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:uy/screens/media_data.dart';
import 'package:uy/screens/subscribe_file/broadcast_kind.dart';

class TvSignUp extends StatefulWidget {
  static TextEditingController mediaName = TextEditingController();
  static TextEditingController headOffice = TextEditingController();
  static TextEditingController slogan = TextEditingController();
  @override
  _TvSignUpState createState() => _TvSignUpState();
}

class _TvSignUpState extends State<TvSignUp> {
  final TextEditingController _language = TextEditingController();
  final TextEditingController _country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    List<String> countryList = [
      "Andorra",
      "United Arab Emirates",
      "Afghanistan",
      "Antigua and Barbuda",
      "Anguilla",
      "Albania",
      "Armenia",
      "Angola",
      "Antarctica",
      "Argentina",
      "American Samoa",
      "Austria",
      "Australia",
      "Aruba",
      "Aland Islands",
      "Azerbaijan",
      "Bosnia and Herzegovina",
      "Barbados",
      "Bangladesh",
      "Belgium",
      "Burkina Faso",
      "Bulgaria",
      "Bahrain",
      "Burundi",
      "Benin",
      "Saint Barthelemy",
      "Bermuda",
      "Brunei",
      "Bolivia",
      "Bonaire, Saint Eustatius and Saba ",
      "Brazil",
      "Bahamas",
      "Bhutan",
      "Bouvet Island",
      "Botswana",
      "Belarus",
      "Belize",
      "Canada",
      "Cocos Islands",
      "Democratic Republic of the Congo",
      "Central African Republic",
      "Republic of the Congo",
      "Switzerland",
      "Ivory Coast",
      "Cook Islands",
      "Chile",
      "Cameroon",
      "China",
      "Colombia",
      "Costa Rica",
      "Cuba",
      "Cape Verde",
      "Curacao",
      "Christmas Island",
      "Cyprus",
      "Czech Republic",
      "Germany",
      "Djibouti",
      "Denmark",
      "Dominica",
      "Dominican Republic",
      "Algeria",
      "Ecuador",
      "Estonia",
      "Egypt",
      "Western Sahara",
      "Eritrea",
      "Spain",
      "Ethiopia",
      "Finland",
      "Fiji",
      "Falkland Islands",
      "Micronesia",
      "Faroe Islands",
      "France",
      "Gabon",
      "United Kingdom",
      "Grenada",
      "Georgia",
      "French Guiana",
      "Guernsey",
      "Ghana",
      "Gibraltar",
      "Greenland",
      "Gambia",
      "Guinea",
      "Guadeloupe",
      "Equatorial Guinea",
      "Greece",
      "South Georgia and the South Sandwich Islands",
      "Guatemala",
      "Guam",
      "Guinea-Bissau",
      "Guyana",
      "Hong Kong",
      "Heard Island and McDonald Islands",
      "Honduras",
      "Croatia",
      "Haiti",
      "Hungary",
      "Indonesia",
      "Ireland",
      "Israel",
      "Isle of Man",
      "India",
      "British Indian Ocean Territory",
      "Iraq",
      "Iran",
      "Iceland",
      "Italy",
      "Jersey",
      "Jamaica",
      "Jordan",
      "Japan",
      "Kenya",
      "Kyrgyzstan",
      "Cambodia",
      "Kiribati",
      "Comoros",
      "Saint Kitts and Nevis",
      "North Korea",
      "South Korea",
      "Kuwait",
      "Cayman Islands",
      "Kazakhstan",
      "Laos",
      "Lebanon",
      "Saint Lucia",
      "Liechtenstein",
      "Sri Lanka",
      "Liberia",
      "Lesotho",
      "Lithuania",
      "Luxembourg",
      "Latvia",
      "Libya",
      "Morocco",
      "Monaco",
      "Moldova",
      "Montenegro",
      "Saint Martin",
      "Madagascar",
      "Marshall Islands",
      "Macedonia",
      "Mali",
      "Myanmar",
      "Mongolia",
      "Macao",
      "Northern Mariana Islands",
      "Martinique",
      "Mauritania",
      "Montserrat",
      "Malta",
      "Mauritius",
      "Maldives",
      "Malawi",
      "Mexico",
      "Malaysia",
      "Mozambique",
      "Namibia",
      "New Caledonia",
      "Niger",
      "Norfolk Island",
      "Nigeria",
      "Nicaragua",
      "Netherlands",
      "Norway",
      "Nepal",
      "Nauru",
      "Niue",
      "New Zealand",
      "Oman",
      "Panama",
      "Peru",
      "French Polynesia",
      "Papua New Guinea",
      "Philippines",
      "Pakistan",
      "Poland",
      "Saint Pierre and Miquelon",
      "Pitcairn",
      "Puerto Rico",
      "Palestinian Territory",
      "Portugal",
      "Palau",
      "Paraguay",
      "Qatar",
      "Reunion",
      "Romania",
      "Serbia",
      "Russia",
      "Rwanda",
      "Saudi Arabia",
      "Solomon Islands",
      "Seychelles",
      "Sudan",
      "Sweden",
      "Singapore",
      "Saint Helena",
      "Slovenia",
      "Svalbard and Jan Mayen",
      "Slovakia",
      "Sierra Leone",
      "San Marino",
      "Senegal",
      "Somalia",
      "Suriname",
      "South Sudan",
      "Sao Tome and Principe",
      "El Salvador",
      "Sint Maarten",
      "Syria",
      "Swaziland",
      "Turks and Caicos Islands",
      "Chad",
      "French Southern Territories",
      "Togo",
      "Thailand",
      "Tajikistan",
      "Tokelau",
      "East Timor",
      "Turkmenistan",
      "Tunisia",
      "Tonga",
      "Turkey",
      "Trinidad and Tobago",
      "Tuvalu",
      "Taiwan",
      "Tanzania",
      "Ukraine",
      "Uganda",
      "United States Minor Outlying Islands",
      "United States",
      "Uruguay",
      "Uzbekistan",
      "Vatican",
      "Saint Vincent and the Grenadines",
      "Venezuela",
      "British Virgin Islands",
      "U.S. Virgin Islands",
      "Vietnam",
      "Vanuatu",
      "Wallis and Futuna",
      "Samoa",
      "Kosovo",
      "Yemen",
      "Mayotte",
      "South Africa",
      "Zambia",
      "Zimbabwe"
    ];
    Map<String, String> countryCode = {
      "AD": "Andorra",
      "AE": "Vereinigte Arabische Emirate",
      "AF": "Afghanistan",
      "AG": "Antigua und Barbuda",
      "AI": "Anguilla",
      "AL": "Albanien",
      "AM": "Armenien",
      "AO": "Angola",
      "AQ": "Antarktis",
      "AR": "Argentinien",
      "AS": "Samoa",
      "AT": "Österreich",
      "AU": "Australien",
      "AW": "Aruba",
      "AX": "Aland",
      "AZ": "Aserbaidschan",
      "BA": "Bosnien-Herzegowina",
      "BB": "Barbados",
      "BD": "Bangladesh",
      "BE": "Belgien",
      "BF": "Burkina Faso",
      "BG": "Bulgarien",
      "BH": "Bahrain",
      "BI": "Burundi",
      "BJ": "Benin",
      "BL": "Saint-Barthélemy",
      "BM": "Bermudas",
      "BN": "Brunei",
      "BO": "Bolivien",
      "BQ": " Bonaire, Saba, Sint Eustatius",
      "BR": "Brasilien",
      "BS": "Bahamas",
      "BT": "Bhutan",
      "BV": "Bouvet Inseln",
      "BW": "Botswana",
      "BY": "Weissrussland",
      "BZ": "Belize",
      "CA": "Kanada",
      "CC": "Kokosinseln",
      "CD": "Demokratische Republik Kongo",
      "CF": "Zentralafrikanische Republik",
      "CG": "Kongo",
      "CH": "Schweiz",
      "CI": "Elfenbeinküste",
      "CK": "Cook Inseln",
      "CL": "Chile",
      "CM": "Kamerun",
      "CN": "China",
      "CO": "Kolumbien",
      "CR": "Costa Rica",
      "CU": "Kuba",
      "CV": "Kap Verde",
      "CW": "Curacao",
      "CX": "Christmas Island",
      "CY": "Zypern",
      "CZ": "Tschechische Republik",
      "DE": "Deutschland",
      "DJ": "Djibuti",
      "DK": "Dänemark",
      "DM": "Dominika",
      "DO": "Dominikanische Republik",
      "DZ": "Algerien",
      "EC": "Ecuador",
      "EE": "Estland",
      "EG": "Ägypten",
      "EH": "Westsahara",
      "ER": "Eritrea",
      "ES": "Spanien",
      "ET": "Äthiopien",
      "FI": "Finnland",
      "FJ": "Fidschi",
      "FK": "Falkland Inseln",
      "FM": "Mikronesien",
      "FO": "Färöer Inseln",
      "FR": "Frankreich",
      "GA": "Gabun",
      "GB": "Großbritannien (UK)",
      "GD": "Grenada",
      "GE": "Georgien",
      "GF": "französisch Guyana",
      "GG": "Guernsey",
      "GH": "Ghana",
      "GI": "Gibraltar",
      "GL": "Grönland",
      "GM": "Gambia",
      "GN": "Guinea",
      "GP": "Guadeloupe",
      "GQ": "Äquatorial Guinea",
      "GR": "Griechenland",
      "GS": "Südgeorgien und die Südlichen Sandwichinseln",
      "GT": "Guatemala",
      "GU": "Guam",
      "GW": "Guinea Bissau",
      "GY": "Guyana",
      "HK": "Hong Kong",
      "HM": "Heard und McDonald Islands",
      "HN": "Honduras",
      "HR": "Kroatien",
      "HT": "Haiti",
      "HU": "Ungarn",
      "ID": "Indonesien",
      "IE": "Irland",
      "IL": "Israel",
      "IM": "Isle of Man",
      "IN": "Indien",
      "IO": "Britisch-Indischer Ozean",
      "IQ": "Irak",
      "IR": "Iran",
      "IS": "Island",
      "IT": "Italien",
      "JE": "Jersey",
      "JM": "Jamaika",
      "JO": "Jordanien",
      "JP": "Japan",
      "KE": "Kenia",
      "KG": "Kirgisistan",
      "KH": "Kambodscha",
      "KI": "Kiribati",
      "KM": "Komoren",
      "KN": "St. Kitts Nevis Anguilla",
      "KP": "Nord Korea",
      "KR": "Süd Korea",
      "KW": "Kuwait",
      "KY": "Kaiman Inseln",
      "KZ": "Kasachstan",
      "LA": "Laos",
      "LB": "Libanon",
      "LC": "Saint Lucia",
      "LI": "Liechtenstein",
      "LK": "Sri Lanka",
      "LR": "Liberia",
      "LS": "Lesotho",
      "LT": "Litauen",
      "LU": "Luxemburg",
      "LV": "Lettland",
      "LY": "Libyen",
      "MA": "Marokko",
      "MC": "Monaco",
      "MD": "Moldavien",
      "ME": "Montenegro",
      "MF": "Saint-Martin",
      "MG": "Madagaskar",
      "MH": "Marshall Inseln",
      "MK": "Mazedonien",
      "ML": "Mali",
      "MM": "Birma",
      "MN": "Mongolei",
      "MO": "Macao",
      "MP": "Marianen",
      "MQ": "Martinique",
      "MR": "Mauretanien",
      "MS": "Montserrat",
      "MT": "Malta",
      "MU": "Mauritius",
      "MV": "Malediven",
      "MW": "Malawi",
      "MX": "Mexiko",
      "MY": "Malaysia",
      "MZ": "Mocambique",
      "NA": "Namibia",
      "NC": "Neukaledonien",
      "NE": "Niger",
      "NF": "Norfolk Inseln",
      "NG": "Nigeria",
      "NI": "Nicaragua",
      "NL": "Niederlande",
      "NO": "Norwegen",
      "NP": "Nepal",
      "NR": "Nauru",
      "NU": "Niue",
      "NZ": "Neuseeland",
      "OM": "Oman",
      "PA": "Panama",
      "PE": "Peru",
      "PF": "Französisch Polynesien",
      "PG": "Papua Neuguinea",
      "PH": "Philippinen",
      "PK": "Pakistan",
      "PL": "Polen",
      "PM": "St. Pierre und Miquelon",
      "PN": "Pitcairn",
      "PR": "Puerto Rico",
      "PS": "Palästina",
      "PT": "Portugal",
      "PW": "Palau",
      "PY": "Paraguay",
      "QA": "Qatar",
      "RE": "Reunion",
      "RO": "Rumänien",
      "RS": "Serbien",
      "RU": "Russland",
      "RW": "Ruanda",
      "SA": "Saudi Arabien",
      "SB": "Solomon Inseln",
      "SC": "Seychellen",
      "SD": "Sudan",
      "SE": "Schweden",
      "SG": "Singapur",
      "SH": "St. Helena",
      "SI": "Slowenien",
      "SJ": "Svalbard und Jan Mayen Islands",
      "SK": "Slowakei",
      "SL": "Sierra Leone",
      "SM": "San Marino",
      "SN": "Senegal",
      "SO": "Somalia",
      "SR": "Surinam",
      "SS": "Südsudan",
      "ST": "Sao Tome",
      "SV": "El Salvador",
      "SX": "Sint Maarten",
      "SY": "Syrien",
      "SZ": "Swasiland",
      "TC": "Turks und Kaikos Inseln",
      "TD": "Tschad",
      "TF": "Französisches Süd-Territorium",
      "TG": "Togo",
      "TH": "Thailand",
      "TJ": "Tadschikistan",
      "TK": "Tokelau",
      "TL": "Osttimor",
      "TM": "Turkmenistan",
      "TN": "Tunesien",
      "TO": "Tonga",
      "TR": "Türkei",
      "TT": "Trinidad Tobago",
      "TV": "Tuvalu",
      "TW": "Taiwan",
      "TZ": "Tansania",
      "UA": "Ukraine",
      "UG": "Uganda",
      "UM": "United States Minor Outlying Islands",
      "US": "Vereinigte Staaten von Amerika",
      "UY": "Uruguay",
      "UZ": "Usbekistan",
      "VA": "Vatikan",
      "VC": "St. Vincent",
      "VE": "Venezuela",
      "VG": "Virgin Island (Brit.)",
      "VI": "Virgin Island (USA)",
      "VN": "Vietnam",
      "VU": "Vanuatu",
      "WF": "Wallis et Futuna",
      "WS": "Samoa",
      "XK": "Kosovo",
      "YE": "Jemen",
      "YT": "Mayotte",
      "ZA": "Südafrika",
      "ZM": "Sambia",
      "ZW": "Zimbabwe"
    };

    List<String> listCode = [];

    countryCode.forEach((k, v) => listCode.add((k)));

    List<String> _getSuggestions(String query) {
      List<String> matches = [];

      matches.addAll(countryList);

      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    }

    List<String> _mediaSuggestions(String query) {
      List<String> matches = [];

      matches.addAll(BroadCastKind.kind == "1"
          ? channelNewsList
          : BroadCastKind.kind == "2"
              ? radioList
              : newsPaperList);

      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: h * .07,
              ),
              Container(
                //color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: h * .05,
                    ),
                    Text(
                      BroadCastKind.kind == "1"
                          ? "Broadcast Channel\n information"
                          : BroadCastKind.kind == "2"
                              ? "Radio Station\n information"
                              : "Print Press\n information",
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.white,
                        fontFamily: "SPProtext",
                      ),
                    ),
                    SizedBox(
                      height: h * .02,
                    ),
                    Text(
                      BroadCastKind.kind == "1"
                          ? "add required information \nof your Broadcast channel"
                          : BroadCastKind.kind == "2"
                              ? "add required information \nof your Radio Station"
                              : "add required information \nof your Print Press",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                        fontFamily: "SPProtext",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * .03,
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h * .02,
                    ),
                    Container(
                      height: h * .06,
                      width: w * .9,
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          textAlign: TextAlign.center,
                          controller: TvSignUp.mediaName,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: "SPProtext",
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            filled: true,
                            hintText: BroadCastKind.kind == "1"
                                ? "Broadcast Channel name"
                                : BroadCastKind.kind == "2"
                                    ? "Radio Station name"
                                    : "NewsPaper name",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontFamily: "SPProtext",
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return _mediaSuggestions(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Center(
                                child: Text("T"),
                              ),
                            ),
                            title: Text(
                              suggestion,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (suggestion) {
                          TvSignUp.mediaName.text = suggestion;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please select a city';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    Container(
                      height: h * .06,
                      width: w * .9,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required field !';
                          }
                          return null;
                        },
                        controller: TvSignUp.headOffice,
                        onSaved: (value) =>
                            TvSignUp.headOffice.text = value.trim(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          filled: true,
                          fillColor: Color(0xFF4E586E),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: "The head office",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    Container(
                      height: h * .06,
                      width: w * .9,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required field !';
                          }
                          return null;
                        },
                        controller: _language,
                        onSaved: (value) => _language.text = value.trim(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          filled: true,
                          fillColor: Color(0xFF4E586E),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: BroadCastKind.kind == "1"
                              ? "Broadcast Channel Language"
                              : BroadCastKind.kind == "2"
                                  ? "Radio Station Language"
                                  : "Print press Language",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    Container(
                      height: h * .06,
                      width: w * .9,
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          textAlign: TextAlign.center,
                          controller: _country,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: "SPProtext",
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            filled: true,
                            hintText: "Country",
                            hintStyle: TextStyle(
                              letterSpacing: 1.2,
                              fontSize: 16.0,
                              color: Colors.white,
                              fontFamily: "SPProtext",
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return _getSuggestions(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(
                              suggestion,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (suggestion) {
                          _country.text = suggestion;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required field !';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    Container(
                      height: h * .06,
                      width: w * .9,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required field !';
                          }
                          return null;
                        },
                        controller: TvSignUp.slogan,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          filled: true,
                          fillColor: Color(0xFF4E586E),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: BroadCastKind.kind == "1" ||
                                  BroadCastKind.kind == "3"
                              ? "Slogan"
                              : "Frequency",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.04,
              ),
              Container(
                height: h * .1,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        child: Container(
                          height: h * 0.05,
                          width: w * 0.30,
                          child: Center(
                            child: Text(
                              "Back",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.white),
                        ),
                        onTap: () async {
                          Navigator.of(context).pushNamed("/BroadcastKind");
                        }),
                    InkWell(
                        child: Container(
                          height: h * 0.05,
                          width: w * 0.30,
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFF54B64),
                                Color(0xFFF78361)
                              ])),
                        ),
                        onTap: () async {
                          Navigator.of(context).pushNamed("/TvContact");
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
/*
  @override
  void initState() {
    TvSignUp.mediaName.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    TvSignUp.mediaName.dispose();
    super.dispose();
  }*/
}
