import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nagare/Activity/youtube_search.dart';
import 'package:nagare/Logic/createroom_logic.dart';
import 'package:nagare/Logic/youtube_search_logic.dart';
import 'room.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref("test/test1");

class CreateRoom extends StatelessWidget {
  final YoutubeVideo video;
  CreateRoom({required this.video});
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('create room'),
          TextField(controller: controller),
          TextField(controller: controller1),
          TextField(controller: controller2),
          TextButton(
            onPressed: () async {
              String? finalRoomName = await createroom_logic(
                source: 'youtube',
                videoid: video.videoId,
                roomName: controller.text,
                host: FirebaseAuth.instance.currentUser!.uid,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreen(roomName: finalRoomName!),
                ),
              );
            },
            child: Text('create Youtube room'),
          ),
        ],
      ),
    );
  }
}

class JoinRoom extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: controller),
          TextButton(
            onPressed: () {
              joinroom_logic(
                roomName: controller.text,
                uid: FirebaseAuth.instance.currentUser!.uid,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreen(roomName: controller.text),
                ),
              );
            },
            child: Text('submit'),
          ),
        ],
      ),
    );
  }
}
