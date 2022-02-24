import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/data.dart';
import 'package:uy/screens/message/show_media_file.dart';
import 'package:uy/services/provider/media_message_provider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uy/services/time_ago.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:uy/widget/show_video.dart';

class MessageItem extends StatefulWidget {
  final QueryDocumentSnapshot document;
  const MessageItem({Key key, this.document}) : super(key: key);

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  User currentUser = FirebaseAuth.instance.currentUser;
  QueryDocumentSnapshot document;
  Time timeCal = new Time();

  Future<void> downloadFile(String filePath) async {
    // 1) set url
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(filePath)
        .getDownloadURL();
    // 2) request
    html.AnchorElement anchorElement =
        new html.AnchorElement(href: downloadURL);
    anchorElement.download = downloadURL;
    anchorElement.click();
  }

  void showVideoChat(Widget videoChat, String filePath, String storageId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Color(0xFF11202D),
        builder: (BuildContext bc) {
          return Stack(
            children: [
              Container(
                  width: w,
                  height: h,
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(height: h * .6, width: w, child: videoChat)),
              Positioned(
                top: h * .05,
                right: h * .05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // downloadFileExample(filePath, storageId);
                  },
                  child: Container(
                    height: h * .03,
                    width: h * .03,
                    child: Center(
                      child: SvgPicture.asset(
                        "./assets/icons/down-arrow.svg",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget messageImageWidget(String url, String mediaExtension, int index) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<MediaMessageProvider>(context, listen: false)
            .changeIndexImage(index);
        showDialog(
          context: (context),
          builder: (context) {
            return ShowMediaWidget(
              index: index,
              image: url,
              mediaExtension: mediaExtension,
            );
          },
        );
      },
      child: Container(
        height: h * .3,
        width: w * .1,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.network(url).image, fit: BoxFit.contain),
          borderRadius: BorderRadius.circular(15.0),
          color: document["messageType"] == "Receiver"
              ? Colors.grey[300]
              : Colors.blue[600],
        ),
      ),
    );
  }

  Widget messageVideoWidget(String url, String mediaExtension, int index) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {
          Provider.of<MediaMessageProvider>(context, listen: false)
              .changeIndexImage(index);
          showDialog(
            context: (context),
            builder: (context) {
              return ShowMediaWidget(
                index: index,
                image: url,
                mediaExtension: mediaExtension,
              );
            },
          );
        },
        child: Stack(
          children: [
            Container(
              height: h * .3,
              width: w * .1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: document["messageType"] == "Receiver"
                    ? Colors.grey[300]
                    : Colors.blue[600],
              ),
              child: ShowVideo(
                videoUrl: url,
              ),
            ),
            Container(
              height: h * .3,
              width: w * .1,
              child: Center(
                child: Icon(
                  LineAwesomeIcons.play,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    document = widget.document;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<MessageProvider>(context).userId;
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: document["messageType"] == "Sender"
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            document["messageType"] == "Receiver"
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 10.0,
                        right: 5.0,
                        left: 5.0,
                      ),
                      height: h * .05,
                      width: h * .05,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.network(document["image"]).image,
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  ),
            Align(
              alignment: (document["messageType"] == "Receiver"
                  ? Alignment.topLeft
                  : Alignment.topRight),
              child: Container(
                width: w * .3,
                child: Column(
                  crossAxisAlignment: document["messageType"] == "Receiver"
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        document["messageKind"] == "text" ||
                                document["messageKind"] == "file"
                            ? 8
                            : 0.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: document["messageType"] == "Receiver"
                            ? BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )
                            : BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                        color: document["messageType"] == "Receiver"
                            ? Colors.grey[300]
                            : Colors.blue[600],
                      ),
                      child: document["messageKind"] == "text"
                          ? Text(
                              document["message"],
                              textDirection: intl.Bidi.detectRtlDirectionality(
                                      document["message"])
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: document["messageType"] == "Receiver"
                                    ? Colors.black
                                    : Colors.white,
                                fontFamily: "SPProtext",
                              ),
                            )
                          : document["messageKind"] == "file"
                              ? InkWell(
                                  onTap: () async {
                                    downloadFile(
                                        "${currentUser.uid}/Chat/${currentUser.uid}$userId/${document["storageId"]}/${document["fileName"]}");
                                  },
                                  child: Container(
                                    height: h * .15,
                                    width: w * .1,
                                    decoration: BoxDecoration(
                                      color:
                                          document["messageType"] == "Receiver"
                                              ? Colors.grey[300]
                                              : Colors.blue[600],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: h * .1,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              document["fileName"]
                                                      .toString()
                                                      .trim()
                                                      .endsWith(".docx")
                                                  ? "./assets/icons/file_format/doc.svg"
                                                  : document["fileName"]
                                                          .toString()
                                                          .trim()
                                                          .endsWith(".pdf")
                                                      ? "./assets/icons/file_format/pdf.svg"
                                                      : document["fileName"]
                                                              .toString()
                                                              .trim()
                                                              .endsWith(".cad")
                                                          ? "./assets/icons/file_format/cad.svg"
                                                          : document["fileName"]
                                                                  .toString()
                                                                  .trim()
                                                                  .endsWith(
                                                                      ".mp3")
                                                              ? "./assets/icons/file_format/mp3.svg"
                                                              : document["fileName"]
                                                                      .toString()
                                                                      .trim()
                                                                      .endsWith(
                                                                          ".cad")
                                                                  ? "./assets/icons/file_format/cad.svg"
                                                                  : document["fileName"]
                                                                          .toString()
                                                                          .trim()
                                                                          .endsWith(
                                                                              ".css")
                                                                      ? "./assets/icons/file_format/css.svg"
                                                                      : document["fileName"]
                                                                              .toString()
                                                                              .trim()
                                                                              .endsWith(".dmg")
                                                                          ? "./assets/icons/file_format/dmg.svg"
                                                                          : document["fileName"].toString().trim().endsWith(".html")
                                                                              ? "./assets/icons/file_format/html.svg"
                                                                              : document["fileName"].toString().trim().endsWith(".iso")
                                                                                  ? "./assets/icons/file_format/iso.svg"
                                                                                  : document["fileName"].toString().trim().endsWith(".js")
                                                                                      ? "./assets/icons/file_format/js.svg"
                                                                                      : document["fileName"].toString().trim().endsWith(".php")
                                                                                          ? "./assets/icons/file_format/php.svg"
                                                                                          : document["fileName"].toString().trim().endsWith(".ppt")
                                                                                              ? "./assets/icons/file_format/ppt.svg"
                                                                                              : document["fileName"].toString().trim().endsWith(".ps")
                                                                                                  ? "./assets/icons/file_format/ps.svg"
                                                                                                  : document["fileName"].toString().trim().endsWith(".psd")
                                                                                                      ? "./assets/icons/file_format/psd.svg"
                                                                                                      : document["fileName"].toString().trim().endsWith(".sql")
                                                                                                          ? "./assets/icons/file_format/sql.svg"
                                                                                                          : document["fileName"].toString().trim().endsWith(".svg")
                                                                                                              ? "./assets/icons/file_format/svg.svg"
                                                                                                              : document["fileName"].toString().trim().endsWith(".txt")
                                                                                                                  ? "./assets/icons/file_format/txt.svg"
                                                                                                                  : document["fileName"].toString().trim().endsWith(".xls")
                                                                                                                      ? "./assets/icons/file_format/xls.svg"
                                                                                                                      : document["fileName"].toString().trim().endsWith(".xml")
                                                                                                                          ? "./assets/icons/file_format/xml.svg"
                                                                                                                          : document["fileName"].toString().trim().endsWith(".zip")
                                                                                                                              ? "./assets/icons/file_format/zip.svg"
                                                                                                                              : "./assets/icons/file_format/file.svg",
                                              height: 45.0,
                                              width: 45.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: h * .05,
                                          child: Text(
                                            document["fileName"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.black,
                                              fontFamily: "SPProtext",
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : document["messageKind"] == "media" &&
                                      imagesFormat.contains(
                                        document["extension"],
                                      )
                                  ? messageImageWidget(
                                      document["message"],
                                      document["extension"],
                                      document["index"],
                                    )
                                  : document["messageKind"] == "media" &&
                                          videoFormat.contains(
                                            document["extension"],
                                          )
                                      ? messageVideoWidget(
                                          document["message"],
                                          document["extension"],
                                          document["index"],
                                        )
                                      : Container(
                                          height: 0.0,
                                          width: 0.0,
                                        ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Row(
                      mainAxisAlignment: document["messageType"] == "Sender"
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          height: h * .02,
                          child: Text(
                            timeCal
                                .timeAgo(document["timeAgo"].toDate())
                                .toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                                fontFamily: "SPProtext"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            document["messageType"] == "Sender"
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 10.0,
                        right: 5.0,
                        left: 5.0,
                      ),
                      height: h * .05,
                      width: h * .05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                Image.network(document.data()["image"]).image),
                      ),
                    ),
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  ),
          ],
        ),
      ),
    );
  }
}
