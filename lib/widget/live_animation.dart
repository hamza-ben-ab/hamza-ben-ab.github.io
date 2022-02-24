import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LiveAnimation extends StatefulWidget {
  final Color begin;
  final Color end;
  final String title;
  final bool icon;
  final double width;
  final double textWidth;
  final bool text;

  const LiveAnimation(
      {Key key,
      this.begin,
      this.end,
      this.title,
      @required this.icon,
      @required this.width,
      @required this.textWidth,
      @required this.text})
      : super(key: key);
  @override
  _LiveAnimationState createState() => _LiveAnimationState();
}

class _LiveAnimationState extends State<LiveAnimation>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..forward()
          ..repeat();
    animation =
        ColorTween(begin: widget.begin, end: widget.end).animate(controller)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w * widget.width,
      height: h * .05,
      child: Row(
        mainAxisAlignment: widget.text
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.start,
        children: [
          widget.icon
              ? Container(
                  height: h * .04,
                  width: w * .02,
                  child: Center(
                    child: SvgPicture.asset("./assets/icons/dot.svg",
                        height: 14.0, width: 14.0, color: animation.value),
                  ),
                )
              : Container(
                  height: 0.0,
                  width: 0.0,
                ),
          widget.text
              ? Container(
                  width: w * widget.textWidth,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: animation.value,
                        fontFamily: "SPProtext"),
                  ),
                )
              : Container(
                  height: 0.0,
                  width: 0.0,
                )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
