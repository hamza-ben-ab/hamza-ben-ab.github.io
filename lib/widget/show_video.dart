import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  final String videoUrl;

  const ShowVideo({Key key, this.videoUrl}) : super(key: key);
  @override
  _ShowVideoState createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  VideoPlayerController controller;
  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: VideoPlayer(controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
