import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/loading_widget/picturesloading.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/pictures_part/personal_picture.dart';
import 'package:uy/screens/pictures_part/picture_view.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uy/services/provider/profile_provider.dart';
import 'package:intl/intl.dart' as intl;

class ShowPictures extends StatefulWidget {
  static int currentindex;

  const ShowPictures({
    Key key,
  }) : super(key: key);
  @override
  _ShowPicturesState createState() => _ShowPicturesState();
}

class _ShowPicturesState extends State<ShowPictures> {
  AlertWidgets alertWidgets = AlertWidgets();

  int indexCurrent = 0;
  File imagee;
  String imageUrl;
  User currentUser = FirebaseAuth.instance.currentUser;
  double progress;
  bool loading = false;
  Uint8List uploadedImage;
  String postTime;
  double percentage;
  String mediaUrl;
  String time;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  InkWell buildProfileItems(bool hover, int index, String title) {
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          indexCurrent = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: h * .05,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              color: indexCurrent == index ? Colors.white : Colors.grey[800],
              fontWeight: FontWeight.w500,
              fontFamily: "SPProtext",
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: indexCurrent == index
              ? accentColor
              : hover
                  ? Colors.grey[400]
                  : Colors.grey[300],
        ),
      ),
    );
  }

  Widget addPicture(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        showPicker(context);
      },
      child: Tooltip(
        message: S.of(context).uploadButton,
        child: Container(
          height: h * .05,
          width: h * .05,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan[400]),
            borderRadius: BorderRadius.circular(15.0),
            // color: hover ? Colors.cyan[600] : Colors.cyan[400],
          ),
          child: Icon(
            Icons.add,
            color: Colors.cyan[600],
          ),
        ),
      ),
    );
  }

  Future showPicker(context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    postTime = "${DateTime.now()}".split('.').first;

    if (result != null) {
      Uint8List file = result.files.single.bytes;
      String filename = result.files.single.name;

      setState(() {
        time = postTime;
      });
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref("${currentUser.uid}/")
          .child("Pictures/$time")
          .child("$filename");
      final firebase_storage.UploadTask uploadTask = storageRef.putData(file);

      uploadTask.snapshotEvents.listen(
        (firebase_storage.TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.running) {
            setState(() {
              loading = true;
              uploadTask.snapshotEvents.listen((event) {
                percentage =
                    (event.bytesTransferred.toDouble() / event.totalBytes);
              });
            });
          } else if (snapshot.state == TaskState.success) {
            setState(() {
              loading = false;
            });
          }
        },
      );

      var dowurl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        mediaUrl = dowurl.toString();
      });
      await users.doc(currentUser.uid).collection("Pictures").doc(time).set(
          {"mediaUrl": mediaUrl, "timeAgo": DateTime.now()},
          SetOptions(merge: true));
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Directionality(
      textDirection:
          intl.Bidi.detectRtlDirectionality(S.of(context).profilePicturesOfYou)
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        width: w * .6,
        margin: EdgeInsets.only(left: 10.0, right: 20.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Column(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: FutureBuilder<DocumentSnapshot>(
                future: users.doc(userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Map<String, dynamic> data = snapshot.data.data();
                    String name = S.of(context).personalPicture;
                    String name2 = S.of(context).postPicture;
                    return Container(
                      height: h * .08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: h * .08,
                            child: Row(
                              children: [
                                HoverWidget(
                                  child: buildProfileItems(
                                      false,
                                      0,
                                      currentUser.uid == userId
                                          ? S.of(context).personalPicture
                                          : name),
                                  hoverChild: buildProfileItems(
                                      true,
                                      0,
                                      currentUser.uid == userId
                                          ? S.of(context).personalPicture
                                          : name),
                                  onHover: (onHover) {},
                                ),
                                SizedBox(
                                  width: w * .005,
                                ),
                                HoverWidget(
                                  child: buildProfileItems(
                                    false,
                                    1,
                                    currentUser.uid == userId
                                        ? S.of(context).profilePicturesOfYou
                                        : name2,
                                  ),
                                  hoverChild: buildProfileItems(
                                    true,
                                    1,
                                    currentUser.uid == userId
                                        ? S.of(context).profilePicturesOfYou
                                        : name2,
                                  ),
                                  onHover: (onHover) {},
                                )
                              ],
                            ),
                          ),
                          indexCurrent == 0 && userId == currentUser.uid
                              ? HoverWidget(
                                  child: addPicture(false),
                                  hoverChild: addPicture(true),
                                  onHover: (onHover) {},
                                )
                              : Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                        ],
                      ),
                    );
                  }
                  return Container(
                    height: h * .08,
                    width: w * .6,
                  );
                }),
          ),
          indexCurrent == 0
              ? PersonalPictures(
                  loading: loading,
                  percentage: percentage,
                )
              : Container(
                  width: w * .6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey[400],
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: users
                        .doc(userId)
                        .collection("Post Pictures")
                        .orderBy("timeAgo", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: w * .6,
                          height: h,
                          child: picturesloading(h, w),
                        );
                      }

                      if (snapshot.hasError) {
                        return alertWidgets.errorWidget(
                          h,
                          w,
                          S.of(context).noContentAvailable,
                        );
                      }

                      if (snapshot.data.docs.isEmpty) {
                        return alertWidgets.emptyWidget(
                            h, w, S.of(context).noPictureToshow);
                      }
                      return StaggeredGridView.countBuilder(
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) =>
                            PictureView(
                          video: false,
                          postKind: snapshot.data.docs[index]["postKind"],
                          edit: false,
                          imageUrl: snapshot.data.docs[index]["mediaUrl"],
                          id: snapshot.data.docs[index].id,
                          userId: userId,
                        ),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(1, index.isEven ? 1 : 1.5),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      );
                    },
                  ),
                ),
        ]),
      ),
    );
  }
}

class PicturePageItems extends StatefulWidget {
  final int index;
  final String title;
  const PicturePageItems({Key key, this.index, this.title}) : super(key: key);

  @override
  _PicturePageItemsState createState() => _PicturePageItemsState();
}

class _PicturePageItemsState extends State<PicturePageItems> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          ShowPictures.currentindex = widget.index;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: h * .05,
            width: w * .15,
            child: Center(
              child: Text(widget.title,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[800],
                      fontFamily: "SPProtext")),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: h * .003,
            width: widget.index == ShowPictures.currentindex ? w * .15 : 0.0,
            color: widget.index == ShowPictures.currentindex
                ? Colors.grey[800]
                : Colors.transparent,
          )
        ],
      ),
    );
  }
}
