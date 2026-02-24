import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Widgets/youtube_widget.dart';
import '../Widgets/vk_player.dart';

class RoomScreen extends StatefulWidget {
  final String roomName;
  final String source;
  final ownerId;
  const RoomScreen({
    super.key,
    required this.ownerId,
    required this.roomName,
    required this.source,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  String? videoId;
  Widget widget_player = Text('');

  @override
  void initState() {
    super.initState();
    loadRoom();
  }

  void loadRoom() async {
    final snapshot = await FirebaseDatabase.instance
        .ref('rooms/${widget.roomName}/videoid')
        .get();
    setState(() {
      videoId = snapshot.value.toString();
      sourceType();
    });
  }

  void sourceType() {
    if (widget.source == 'yt') {
      widget_player = YoutubePlayerWidget(
        videoId: videoId!,
        roomName: widget.roomName,
      );
    } else if (widget.source == 'vk') {
      widget_player = VkVideoPlayer(
        roomName: widget.roomName,
        videoId: videoId!,
        ownerId: widget.ownerId,
        //roomname,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoId == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 10, 17),
      body: widget_player,
    );
  }
}
