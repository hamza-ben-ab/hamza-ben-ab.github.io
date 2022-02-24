import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final bool isExpanded = false;
  final TextStyle style;
  final double maxHeight;
  const ExpandableText({Key key, this.text, this.style, this.maxHeight})
      : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new ConstrainedBox(
        constraints: widget.isExpanded
            ? new BoxConstraints()
            : new BoxConstraints(maxHeight: widget.maxHeight),
        child: new Text(
          widget.text,
          softWrap: true,
          overflow: TextOverflow.fade,
          style: widget.style,
        ),
      ),
      widget.isExpanded
          ? new Container()
          : new Text(
              '...',
              style: widget.style,
            ),
      //onPressed: () => setState(() => widget.isExpanded == true),
    ]);
  }
}
