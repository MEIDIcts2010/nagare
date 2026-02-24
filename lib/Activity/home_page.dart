import 'package:flutter/material.dart';
import 'package:nagare/Activity/create_room.dart';
import 'package:nagare/Activity/vk_search.dart';
import 'package:nagare/Activity/youtube_search.dart';
import 'package:nagare/Logic/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html';

import 'package:nagare/Widgets/vk_player.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void uidGet() {
    window.localStorage['uid'] = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    uidGet();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              LogOut();
            },
            child: Text('log'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YoutubeSearch()),
              );
            },
            child: Text('watchYoutube'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JoinRoom()),
              );
            },
            child: Text('join'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VkSearchPage()),
              );
            },
            child: Text('vksearch'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VkVideoPlayer(
                    roomName: 'qwer',
                    ownerId: '-109800058',
                    videoId: '456240890',
                  ),
                ),
              );
            },
            child: Text('vksearch'),
          ),
        ],
      ),
    );
  }
}
