import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/screens/loading_widget/contact_loading.dart';
import 'package:uy/screens/loading_widget/profile_first_part_loading.dart';
import 'package:uy/screens/about_part/about_widget.dart';
import 'package:uy/screens/profile/add_button.dart';
import 'package:uy/screens/profile/profile_image_widget.dart';
import 'package:uy/screens/profile/subscriptions_widget.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:mailto/mailto.dart';
//import 'package:url_launcher/url_launcher.dart';

class FirstPart extends StatefulWidget {
  const FirstPart({Key key}) : super(key: key);

  @override
  _FirstPartState createState() => _FirstPartState();
}

class _FirstPartState extends State<FirstPart> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;

  String getUrl(String title, String url) {
    if (title == "Mail") {
      return url;
    }
    if (title == "Facebook") {
      return "https://www.facebook.com/$url";
    }

    if (title == "Twitter") {
      return "https://twitter.com/$url";
    }
    if (title == "LinkedIn") {
      return "https://www.linkedin.com/in/$url";
    }
    if (title == "Instagram") {
      return "https://www.instagram.com/$url";
    }
    if (title == "Youtube") {
      return "https://www.youtube.com/c/$url";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
              width: w * .6,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              margin: EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: w * .25,
                          margin: EdgeInsets.only(right: 10.0),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ProfileImageWidget(
                                profileImage: data["image"],
                                userId: userId,
                              ),
                              Container(
                                width: w * .25,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data["full_name"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SPProtext",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7.0,
                                    ),
                                    Container(
                                      height: h * .020,
                                      width: h * .020,
                                      child: Image.asset(
                                          "./assets/images/check (2).png"),
                                    )
                                  ],
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "./assets/icons/placeholder.svg",
                                  height: 15.0,
                                  width: 15.0,
                                  color: Colors.grey[800],
                                ),
                                label: Text(
                                  data["currentLocation"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "./assets/icons/placeholder.svg",
                                  height: 15.0,
                                  width: 15.0,
                                  color: Colors.grey[800],
                                ),
                                label: Text(
                                  data["homeTownLocation"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SPProtext",
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "./assets/icons/suitcase.svg",
                                      color: Colors.grey[800],
                                      height: 15.0,
                                      width: 15.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "${data["journalistKind"]} ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SPProtext"),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "./assets/icons/enterprise.svg",
                                      color: Colors.grey[800],
                                      height: 15.0,
                                      width: 15.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      " ${data["workspace"]}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SPProtext"),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: users
                                        .doc(userId)
                                        .collection("Contacts")
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return contactLoading(h, w);
                                      }
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: snapshot.data.docs
                                            .map<Widget>(
                                                (DocumentSnapshot document) {
                                          return contactItems(
                                            document.id,
                                            getUrl(
                                              document.id,
                                              document.data()["data"],
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: w * .34,
                          height: h * .48,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubscriptionsWidget(),
                              AboutWidget(),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: currentUser.uid != userId
                                      ? Container(
                                          height: h * .05,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              AddButton(userId: userId),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              HoverWidget(
                                                child: messageIconWidget(
                                                    false, userId),
                                                hoverChild: messageIconWidget(
                                                    true, userId),
                                                onHover: (onHover) {},
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0.0,
                                          width: 0.0,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
            );
          }
          return profilefirstPartLoading(h, w);
        });
  }

  Widget contactItems(String image, String url) {
    double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: InkWell(
        onTap: () {
          url.contains("@")
              ? launchMailto(url)
              : html.window.open(url, "_blank");
        },
        child: Container(
          height: h * .04,
          width: h * .04,
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blueGrey[300],
            image: DecorationImage(
                image: Image.asset("./assets/images/$image.png").image,
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  launchMailto(String mail) async {
    final mailtoLink = Mailto(
      to: [mail],
    );

    // await launch('$mailtoLink');
  }

  Widget messageIconWidget(bool hover, String userId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Tooltip(
      message: "message",
      child: InkWell(
        onTap: () {
          Provider.of<CenterBoxProvider>(context, listen: false)
              .changeCurrentIndex(5);
          Provider.of<MessageProvider>(context, listen: false)
              .changeMessageId(userId);
          Provider.of<MessageProvider>(context, listen: false).checkBlock();
        },
        child: Container(
          height: h * 0.06,
          width: w * 0.05,
          decoration: BoxDecoration(
            color: hover ? Colors.grey[400] : Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: SvgPicture.asset(
              "./assets/icons/msg.svg",
              height: 20.0,
              width: 20.0,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }
}
