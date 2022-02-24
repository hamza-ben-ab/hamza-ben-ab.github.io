import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/create_post_file/11_create_Stories.dart';
import 'package:uy/screens/create_post_file/12_create_Event.dart';
import 'package:uy/screens/create_post_file/3_create_Cp_Essay.dart';
import 'package:uy/screens/create_post_file/5_create_Poll.dart';
import 'package:uy/screens/create_post_file/6_create_Rarticle.dart';
import 'package:uy/screens/create_post_file/7_create_HowTo.dart';
import 'package:uy/screens/create_post_file/8_create_Pprofile.dart';
import 'package:uy/screens/create_post_file/9_create_AReview.dart';
import 'package:uy/screens/create_post_file/10_create_broadcasting.dart';
import 'package:uy/screens/create_post_file/1_create_Bn_Ln.dart';
import 'package:uy/services/provider/article_search_provider.dart';
import 'package:uy/services/provider/tag_post_provider.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        height: h * 1.6,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(20.0),
        child: StaggeredGridView.count(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          crossAxisCount: 4,
          scrollDirection: Axis.vertical,
          children: [
            //breaking_news
            PostKind(
              title: S.of(context).createPostBreakingNewsTitle,
              icon: "stopwatch",
              description: Center(
                child: Text(
                  S.of(context).createPostBreakingNewsDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.blue,
                    fontFamily: "SPProtext",
                  ),
                ),
              ),
              route: CreateBreakingNews(
                kind: "breaking_news",
              ),
              hD: .9,
              wD: .7,
            ),
            //lastest news
            PostKind(
              route: CreateBreakingNews(
                kind: "lastest_news",
              ),
              title: S.of(context).createPostLastestNewsTitle,
              icon: "news",
              description: Center(
                child: Text(
                  S.of(context).createPostLastestNewsDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.blue,
                    fontFamily: "SPProtext",
                  ),
                ),
              ),
              hD: .9,
              wD: .7,
            ),
            //commentary
            PostKind(
              title: S.of(context).createPostCommentary,
              icon: "message",
              description: Center(
                child: Text(
                  S.of(context).createPostCommentaryDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.blue,
                    fontFamily: "SPProtext",
                  ),
                ),
              ),
              route: CreateCommentaryAndPerspective(
                kind: "commentary",
              ),
              hD: .9,
              wD: .8,
            ),
            //essay
            PostKind(
              title: S.of(context).createPostEssay,
              icon: "note",
              description: Center(
                child: Text(
                  S.of(context).createPostEssayDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              route: CreateCommentaryAndPerspective(
                kind: "essay",
              ),
              hD: .9,
              wD: .8,
            ),
            //Poll
            PostKind(
              title: S.of(context).pollTitle,
              icon: "026-pie-chart",
              description: Center(
                child: Text(
                  S.of(context).createPostQuestionDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              route: CreateQuestion(),
              hD: .7,
              wD: .6,
            ),
            //Sc article
            PostKind(
              title: S.of(context).addPostArticle,
              route: CreateResearchArticle(),
              icon: "research",
              description: Center(
                child: Text(
                  S.of(context).createPostArticleDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              hD: .9,
              wD: .58,
            ),
            //How-to
            PostKind(
              title: S.of(context).createHowToTitle,
              icon: "guide",
              route: CreateHowTo(),
              description: Center(
                child: Text(
                  S.of(context).createPostHowToDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              hD: .9,
              wD: .45,
            ),
            //Personality Profile
            PostKind(
              title: S.of(context).createProfiletitle,
              icon: "businessman",
              route: CreatePersonalityProfile(),
              description: Center(
                child: Text(
                  S.of(context).createPostProfileDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              hD: .9,
              wD: .5,
            ),
            //analysis
            PostKind(
              title: S.of(context).createAnalysisTitle,
              icon: "survey",
              route: CreateAnalysisAndReview(
                create: "analysis",
              ),
              description: Center(
                child: Text(
                  S.of(context).createPostAnalysisDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              hD: .9,
              wD: .7,
            ),
            //investigation
            PostKind(
              route: CreateAnalysisAndReview(
                create: "investigation",
              ),
              title: S.of(context).createPostInvestigationTitle,
              icon: "detective",
              description: Center(
                child: Text(
                  S.of(context).createPostInvestigationDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              hD: .9,
              wD: .7,
            ),
            //Stories
            PostKind(
              title: S.of(context).createStoryTitle,
              icon: "reading",
              description: Center(
                child: Text(
                  S.of(context).createPostStoryDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              route: CreateStories(),
              hD: .9,
              wD: .8,
            ),
            //broadcasting
            PostKind(
              title: S.of(context).createPostBroadcastTitle,
              icon: "009-video camera",
              description: Center(
                child: Text(
                  S.of(context).createPostBroadCastDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              route: CreateBroadcasting(video: true),
              hD: .9,
              wD: .55,
            ),
            //inPic
            PostKind(
              route: CreateBroadcasting(video: false),
              hD: .9,
              wD: .6,
              title: S.of(context).createPostInpicTitle,
              icon: "pictures",
              description: Center(
                child: Text(
                  S.of(context).createPostInPicDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
            ),
            //event
            PostKind(
              route: CreateEvent(),
              title: S.of(context).tagEvent,
              icon: "calendar",
              description: Center(
                child: Text(
                  S.of(context).createPostEvent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
              hD: .9,
              wD: .5,
            ),
            //Sponsored
            PostKind(
              show: false,
              route: Container(
                height: 0.0,
                width: 0.0,
              ),
              title: S.of(context).createPostSponsored,
              icon: "advertisement",
              description: Center(
                child: Text(
                  S.of(context).createPostSponsoredDes,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blue,
                      fontFamily: "SPProtext"),
                ),
              ),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
            StaggeredTile.count(1, 1),
          ],
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      ),
    );
  }
}

class PostKind extends StatefulWidget {
  final String title;
  final String icon;
  final Widget description;
  final Widget route;
  final double hD;
  final double wD;
  final bool show;

  const PostKind(
      {Key key,
      this.title,
      this.icon,
      this.description,
      this.route,
      this.hD,
      this.wD,
      this.show = true})
      : super(key: key);
  @override
  _PostKindState createState() => _PostKindState();
}

class _PostKindState extends State<PostKind> {
  Widget postKind(bool hover) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        widget.show ? showPostKind(widget.hD, widget.wD) : print("no");
        Provider.of<TagPostProvider>(context, listen: false)
            .changeTagTopic(null);
        Provider.of<TagPostProvider>(context, listen: false)
            .changeTagPerson(null);
        Provider.of<TagPostProvider>(context, listen: false)
            .changeTagEvent(null);
        Provider.of<TagPostProvider>(context, listen: false)
            .changeTagPlace(null);
        Provider.of<SearchArticleProvider>(context, listen: false).emptyList();
      },
      child: Container(
        decoration: BoxDecoration(
          color: hover ? Colors.grey[300] : Colors.grey[50],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: h * .02,
            ),
            Container(
              height: h * .06,
              width: h * .06,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        Image.asset("./assets/images/${widget.icon}.png").image,
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: h * .01,
            ),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontFamily: "SPProtext",
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Container(
                width: w,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: widget.description,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPostKind(double hD, double wD) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                height: h * hD,
                width: w * wD,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: widget.route),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
        child: postKind(false),
        hoverChild: postKind(true),
        onHover: (onHover) {});
  }
}
