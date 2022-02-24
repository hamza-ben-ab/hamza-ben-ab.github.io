import 'package:flutter/material.dart';
import 'package:uy/screens/subscribe_file/broadcast_kind.dart';

class TvContact extends StatefulWidget {
  @override
  _TvContactState createState() => _TvContactState();
}

class _TvContactState extends State<TvContact> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _fax = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

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
                          ? "Broadcast Contact"
                          : BroadCastKind.kind == "2"
                              ? "Radio Contact"
                              : "NewsPaper Contact",
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
                          ? "add Contact information \nof your Broadcast channel"
                          : BroadCastKind.kind == "2"
                              ? "add Contact information \nof your Radio Station"
                              : "add Contact information \nof your Print Press",
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
                height: h * .15,
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
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required field !';
                          }
                          return null;
                        },
                        controller: _email,
                        onSaved: (value) => _email.text = value.trim(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          filled: true,
                          fillColor: Color(0xFF4E586E),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: "E-mail",
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
                        controller: _phone,
                        onSaved: (value) => _phone.text = value.trim(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          filled: true,
                          fillColor: Color(0xFF4E586E),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: "Phone ",
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
                        controller: _fax,
                        onSaved: (value) => _fax.text = value.trim(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          filled: true,
                          fillColor: Color(0xFF4E586E),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: "Fax",
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
                height: h * 0.19,
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
                          Navigator.of(context).pushNamed("/TvSignUp");
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
                          Navigator.of(context).pushNamed("/AddChannelLogo");
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
}
