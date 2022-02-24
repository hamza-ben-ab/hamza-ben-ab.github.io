import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/screens/loading_widget/trending_loading.dart';
import 'package:uy/screens/about_part/contact_widget.dart';
import 'package:uy/screens/about_part/experience_widget.dart';
import 'package:uy/screens/about_part/interest_part.dart';
import 'package:uy/screens/pictures_part/pictures.dart';
import 'package:uy/screens/profile/profile_post_widget.dart';
import 'package:uy/screens/about_part/skills_part_widget.dart';
import 'package:uy/screens/profile/videos.dart';
import 'package:uy/services/provider/profile_centerBar_provider.dart';
import 'package:uy/screens/search/hover.dart';

class ProfileSecondPart extends StatefulWidget {
  final String userId;
  const ProfileSecondPart({Key key, this.userId}) : super(key: key);

  @override
  _ProfileSecondPartState createState() => _ProfileSecondPartState();
}

class _ProfileSecondPartState extends State<ProfileSecondPart> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController universityController = TextEditingController();
  TextEditingController diplomaController = TextEditingController();
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

  Widget showAbout(String userId) {
    return Column(
      children: [
        //skills
        SkillsPart(),
        //Experiences
        ExperienceWidget(),
        //Interest
        InterestPart(),
        //Contact
        ContactWidget()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    int currentindex =
        Provider.of<ProfileCenterBarProvider>(context).currentIndex;
    return currentindex == 0
        ? Container(
            width: w * .63,
            margin: EdgeInsets.only(left: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: users
                  .doc(widget.userId)
                  .collection("Pub")
                  .orderBy("timeAgo", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: w * .63,
                    height: h * .5,
                    child: GridView.builder(
                        padding: EdgeInsets.only(left: 10, right: 15.0),
                        itemCount: 9,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemBuilder: (BuildContext ctx, index) {
                          return trendingLoading(h, w);
                        }),
                  );
                }

                return AnimationLimiter(
                  child: GridView.count(
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: List.generate(
                      snapshot.data.docs.length,
                      (int index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 3,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: ProfilePostWidget(
                                document: snapshot.data.docs[index],
                                userId: widget.userId,
                                id: snapshot.data.docs[index].id,
                              ).xShowPointerOnHover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        : currentindex == 1
            ? Container(
                width: w * .6,
                child: showAbout(widget.userId),
              )
            : currentindex == 2
                ? ShowPictures()
                : ShowAllVideos(
                    userId: widget.userId,
                  );
  }
}
