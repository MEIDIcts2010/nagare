import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Widgets/youtube_widget.dart';

class RoomScreen extends StatefulWidget {
  final String roomName;
  RoomScreen({required this.roomName});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  String? videoId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRoom();
  }

  void loadRoom() async {
    String suffix = widget.roomName;
    final snapshot = await FirebaseDatabase.instance
        .ref('rooms/${widget.roomName}/videoid')
        .get();
    setState(() {
      videoId = snapshot.value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoId == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 10, 17),
      body: YoutubePlayerWidget(videoId: videoId!, roomName: widget.roomName),
    );
  }
}
