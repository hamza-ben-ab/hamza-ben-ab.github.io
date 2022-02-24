import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoViewChat extends StatefulWidget {
  final String videoUrl;
  final bool isFile;
  final File file;
  final bool auto;
  final Function onVideoEnd;
  final String userId;
  final String id;
  const VideoViewChat(
      {Key key,
      this.videoUrl,
      this.isFile,
      this.file,
      this.auto,
      this.onVideoEnd,
      this.userId,
      this.id})
      : super(key: key);
  @override
  _VideoViewChatState createState() => _VideoViewChatState();
}

class _VideoViewChatState extends State<VideoViewChat> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  VideoPlayerController videoPlayerController;
  FlickManager flickManager;
  @override
  void initState() {
    flickManager = widget.isFile
        ? FlickManager(
            videoPlayerController: VideoPlayerController.file(widget.file),
            autoPlay: widget.auto)
        : FlickManager(
            videoPlayerController: VideoPlayerController.network(
              "${widget.videoUrl}",
            ),
            autoPlay: widget.auto,
            onVideoEnd: widget.onVideoEnd,
          );
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickManager: flickManager,
    );
  }
}
