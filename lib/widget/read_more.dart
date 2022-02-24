import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;

class ReadMoreText extends StatefulWidget {
  final String text;
  ReadMoreText(this.text);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText>
    with TickerProviderStateMixin<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(
        text: widget.text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            fontFamily: "SPProtext"),
      );
      final tp = TextPainter(
        text: span,
        maxLines: 3,
        textDirection: intl.Bidi.detectRtlDirectionality(widget.text)
            ? TextDirection.rtl
            : TextDirection.ltr,
      );
      tp.layout(maxWidth: size.maxWidth);
      return Column(children: <Widget>[
        AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: h * .15),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              width: w,
              child: Text(
                widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
                textDirection: intl.Bidi.detectRtlDirectionality(widget.text)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: TextStyle(
                    color: Colors.white, fontSize: 14.0, fontFamily: "Avenir"),
              ),
            ),
          ),
        ),
        InkWell(
            child: Container(
              height: h * .055,
              width: w * .4,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Read",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontFamily: "SPProtext"),
                  ),
                  SizedBox(
                    width: 7.0,
                  ),
                  SvgPicture.asset(
                    "./assets/icons/book.svg",
                    color: Colors.white,
                    height: 20.0,
                    width: 20.0,
                  )
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF005ea3), Color(0xFF11A8fd)]),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onTap: () {}),
      ]);
    });
  }
}

class ReadMore extends StatefulWidget {
  final String text;
  final bool isBreak;
  ReadMore(this.text, this.isBreak);

  @override
  _ReadMoreState createState() => _ReadMoreState();
}

class _ReadMoreState extends State<ReadMore>
    with TickerProviderStateMixin<ReadMore> {
  bool isExpanded = false;
  void showBreakingNews() {}
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(
        text: widget.text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: isExpanded ? 16.0 : 14.0,
            fontFamily: "Roboto"),
      );
      final tp = TextPainter(
        text: span,
        maxLines: 6,
        textDirection: intl.Bidi.detectRtlDirectionality(widget.text)
            ? TextDirection.rtl
            : TextDirection.ltr,
      );
      tp.layout(maxWidth: size.maxWidth);

      if (tp.didExceedMaxLines) {
        return Column(children: <Widget>[
          AnimatedSize(
            vsync: this,
            duration: const Duration(milliseconds: 500),
            child: ConstrainedBox(
              constraints: isExpanded
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: h * .1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                width: w,
                child: Text(
                  widget.text,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: isExpanded ? 16.0 : 14.0,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ),
          GestureDetector(
              child: Container(
                height: h * .04,
                width: w * .27,
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      !isExpanded ? "Read more" : "Close",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SPProtext"),
                    ),
                    SizedBox(
                      width: 7.0,
                    ),
                    !isExpanded
                        ? SvgPicture.asset(
                            "./assets/icons/book.svg",
                            color: Colors.white,
                            height: 20.0,
                            width: 20.0,
                          )
                        : SvgPicture.asset(
                            "./assets/icons/023-book.svg",
                            color: Colors.white,
                            height: 20.0,
                            width: 20.0,
                          )
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.blueAccent),
              ),
              onTap: () {
                setState(() {
                  isExpanded = true;
                });
              })
        ]);
      } else {
        return Text(
          widget.text,
          softWrap: true,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: isExpanded ? 16.0 : 14.0,
              fontFamily: "Roboto"),
        );
      }
    });
  }
}
