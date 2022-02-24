import 'package:flutter/material.dart';
import 'package:uy/screens/message/conversations_widget.dart';
import 'package:uy/screens/message/messages_list.dart';

class ConversationChat extends StatefulWidget {
  const ConversationChat({Key key}) : super(key: key);
  @override
  _ConversationChatState createState() => _ConversationChatState();
}

class _ConversationChatState extends State<ConversationChat>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: w * .23,
            height: h * .85,
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: MessagesList(
              empty: false,
            ),
          ),
          ConversationWidget()
        ],
      ),
    );
  }
}
