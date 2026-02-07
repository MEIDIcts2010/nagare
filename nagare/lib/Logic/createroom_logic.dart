import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';

FirebaseDatabase inst = FirebaseDatabase.instance;

Future<String?> createroom_logic({
  required String source,
  required String videoid,
  required String roomName,
  required String host,
}) async {
  final existTest = await inst.ref('rooms/$roomName').get();
  if (existTest.value != null) {
    String random = roomName + Random().nextInt(1000000000).toString();
    await inst.ref('rooms/$random').set({
      'source': source,
      'videoid': videoid,
      'host': host,
      'users': {},
    });
    return random;
  } else {
    await inst.ref('rooms/$roomName').set({
      'source': source,
      'videoid': videoid,
      'host': host,
      'users': {},
    });
    return roomName;
  }
}

bool hostForCurrentuser = false;

Future<void> joinroom_logic({
  required String uid,
  required String roomName,
}) async {
  final roomTest = await inst.ref("rooms/$roomName").get();
  if (roomTest.value == null) {
    print("Комнаты не существует");
  } else {
    await inst.ref("rooms/$roomName/users").update({uid: true});
    final hostTest = await inst.ref("rooms/$roomName/host").get();
    print(hostTest.value);
    print(uid);
    if (hostTest.value == uid) {
      hostForCurrentuser = true;
    } else {
      hostForCurrentuser = false;
    }
    print(hostForCurrentuser);
  }
}
