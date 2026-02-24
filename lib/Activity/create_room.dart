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
  final String video;
  final String source;
  final String ownerId;
  CreateRoom({
    required this.ownerId,
    required this.video,
    required this.source,
  });
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
                source: source,
                videoid: video,
                roomName: controller.text,
                host: FirebaseAuth.instance.currentUser!.uid,
                ownerId: ownerId,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreen(
                    roomName: finalRoomName!,
                    source: source,
                    ownerId: ownerId,
                  ),
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
            onPressed: () async {
              joinroom_logic(
                roomName: controller.text,
                uid: FirebaseAuth.instance.currentUser!.uid,
              );
              final source = await FirebaseDatabase.instance
                  .ref("rooms/${controller.text}/source")
                  .get();
              final ownerId = await FirebaseDatabase.instance
                  .ref('rooms/${controller.text}/ownerId')
                  .get();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreen(
                    ownerId: ownerId.value.toString(),
                    roomName: controller.text,
                    source: source.value.toString(),
                  ),
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
