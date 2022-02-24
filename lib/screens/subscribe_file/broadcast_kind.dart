import 'package:flutter/material.dart';

class BroadCastKind extends StatefulWidget {
  static String kind;
  @override
  _BroadCastKindState createState() => _BroadCastKindState();
}

class _BroadCastKindState extends State<BroadCastKind> {
  bool broadcast = false;
  bool radio = false;
  bool print = false;
  bool photo = false;
  bool caricature = false;
  bool online = false;
  String result = "";
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
        ),
        body: Container(
          height: h,
          width: w,
          child: Column(
            children: [
              Container(
                height: h * .77,
                width: w,
                padding: EdgeInsets.all(10.0),
                child: GridView.count(
                  children: [
                    // Broadcast
                    InkWell(
                      onTap: () {
                        setState(() {
                          broadcast = !broadcast;
                          print = false;
                          radio = false;
                          if (broadcast) {
                            result = "1";
                          }
                        });
                      },
                      child: Container(
                        height: h * .1,
                        width: h * .1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: h * .08,
                              width: h * 0.08,
                              child: Image.asset(
                                "./assets/images/001-television.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Text(
                              "Broadcast Channel",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    !broadcast ? Colors.white : Colors.white)),
                      ),
                    ),
                    // Free lance
                    InkWell(
                      onTap: () {
                        setState(() {
                          radio = !radio;
                          broadcast = false;
                          print = false;
                          if (radio) {
                            result = "2";
                          }
                        });
                      },
                      child: Container(
                        height: h * .1,
                        width: h * .1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: h * .08,
                              width: h * 0.08,
                              child: Image.asset(
                                "./assets/images/029-radio.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Text(
                              "Radio Station",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: !radio ? Colors.white : Colors.white)),
                      ),
                    ),
                    // Print
                    InkWell(
                      onTap: () {
                        setState(() {
                          print = !print;
                          broadcast = false;
                          radio = false;

                          if (print) {
                            result = "3";
                          }
                        });
                      },
                      child: Container(
                        height: h * .1,
                        width: h * .1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: h * .08,
                              width: h * 0.08,
                              child: Image.asset(
                                "./assets/images/019-news.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Text(
                              "Print Press",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: !print ? Colors.white : Colors.white)),
                      ),
                    ),
                    // Photo
                    /* InkWell(
                      onTap: () {
                        setState(() {
                          photo = !photo;

                          if (photo) {
                            result = "4";
                          }
                        });
                      },
                      child: Container(
                        height: h * .1,
                        width: h * .1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: h * .08,
                              width: h * 0.08,
                              child: Image.asset(
                                "./assets/images/026-website.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Text(
                              "Web Site News",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: !photo ? GreyBlackColor : Colors.white)),
                      ),
                    ),*/
                    // Caricature
                  ],
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
              ),
              SizedBox(
                height: h * .01,
              ),
              Container(
                padding: EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        child: Container(
                          height: h * 0.05,
                          width: w * 0.30,
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              gradient: LinearGradient(colors: [
                                Color(0xFFF54B64),
                                Color(0xFFF78361)
                              ])),
                        ),
                        onTap: () {
                          BroadCastKind.kind = result;
                          Navigator.of(context).pushNamed("/TvSignUp");
                        }),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class PostKind extends StatefulWidget {
  final String text;
  final String image;

  const PostKind({Key key, this.text, this.image}) : super(key: key);
  @override
  _PostKindState createState() => _PostKindState();
}

class _PostKindState extends State<PostKind> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Container(
        height: h * .1,
        width: h * .1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: h * .08,
              width: h * 0.08,
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: "SPProtext",
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(color: !selected ? Colors.white : Colors.white)),
      ),
    );
  }
}
