import 'package:flutter/material.dart';
import 'package:nagare/Activity/create_room.dart';
import 'package:nagare/Activity/youtube_search.dart';
import 'package:nagare/Logic/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
