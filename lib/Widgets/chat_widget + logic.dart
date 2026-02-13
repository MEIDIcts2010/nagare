import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:core';

Future<void> sendMessage(String text, String roomName) async {
  final name = FirebaseAuth.instance.currentUser!.email!.split('@')[0];
  final request = FirebaseDatabase.instance
      .ref('rooms/${roomName}/chat')
      .push();

  await request.set({
    'text': text,
    'user': name,
    'timestamp': DateTime.now().microsecondsSinceEpoch,
  });
}

class ChatWidget extends StatefulWidget {
  final String roomName;
  ChatWidget({required this.roomName});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ChatRef = FirebaseDatabase.instance.ref(
      'rooms/${widget.roomName}/chat',
    );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 34, 51),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatRef.orderByChild("timestamp").onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text("Нет сообщений"));
                }
                final data =
                    snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                final messages = data.entries.toList()
                  ..sort(
                    (a, b) =>
                        a.value["timestamp"].compareTo(b.value["timestamp"]),
                  );

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].value;
                    return ListTile(
                      title: Text(
                        msg['user'],
                        style: TextStyle(
                          color: Color.fromARGB(255, 199, 14, 122),
                        ),
                      ),
                      subtitle: Text(
                        msg['text'],
                        style: TextStyle(
                          color: Color.fromARGB(255, 196, 68, 142),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Сообщение...",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    sendMessage(controller.text, widget.roomName);
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
