import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/loading_widget/picturesloading.dart';
import 'package:uy/screens/posts/post_widgets/alert_widget.dart';
import 'package:uy/screens/pictures_part/picture_view.dart';
import 'package:uy/services/provider/profile_provider.dart';

class PersonalPictures extends StatefulWidget {
  final bool loading;
  final double percentage;

  const PersonalPictures({
    Key key,
    this.loading,
    this.percentage,
  }) : super(key: key);

  @override
  _PersonalPicturesState createState() => _PersonalPicturesState();
}

class _PersonalPicturesState extends State<PersonalPictures> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  AlertWidgets alertWidgets = AlertWidgets();
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String userId = Provider.of<ProfileProvider>(context).userId;
    return Container(
      width: w * .6,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: widget.loading ? h * .05 : 0.0,
            width: w * .6,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: widget.percentage,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xFF33CC33)),
                  backgroundColor: Color(0xffD6D6D6),
                ),
              ),
            ),
          ),
          Container(
            width: w * .6,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: Colors.grey[400],
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: users
                  .doc(userId)
                  .collection("Pictures")
                  .orderBy("timeAgo", descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: w * .6,
                    height: h,
                    child: picturesloading(h, w),
                  );
                }

                if (snapshot.hasError) {
                  return alertWidgets.errorWidget(
                      h, w, S.of(context).noContentAvailable);
                }

                if (snapshot.data.docs.isEmpty) {
                  return alertWidgets.emptyWidget(
                      h, w, S.of(context).noPictureToshow);
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) => PictureView(
                    video: false,
                    edit: true,
                    imageUrl: snapshot.data.docs[index]["mediaUrl"],
                    id: snapshot.data.docs[index].id,
                    userId: userId,
                    current: index,
                    refresh: refresh,
                  ),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(1, index.isEven ? 1.5 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
