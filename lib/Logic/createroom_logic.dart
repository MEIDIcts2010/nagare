import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Activity/home_page.dart';

FirebaseDatabase inst = FirebaseDatabase.instance;

Future<String?> createroom_logic({
  required String source,
  required String videoid,
  required String roomName,
  required String host,
  required String ownerId,
}) async {
  final existTest = await inst.ref('rooms/$roomName').get();
  if (existTest.value != null) {
    String random = roomName + Random().nextInt(1000000000).toString();
    await inst.ref('rooms/$random').set({
      'source': source,
      'videoid': videoid,
      'host': host,
      'ownerId': ownerId,
      'users': {},
    });
    return random;
  } else {
    await inst.ref('rooms/$roomName').set({
      'source': source,
      'videoid': videoid,
      'host': host,
      'ownerId': ownerId,
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
    var a = 0;
  } else {
    await inst.ref("rooms/$roomName/users").update({uid: true});
    final hostTest = await inst.ref("rooms/$roomName/host").get();
    if (hostTest.value == uid) {
      hostForCurrentuser = true;
    } else {
      hostForCurrentuser = false;
    }
  }
}

Future<void> deleteRoom({
  required String roomName,
  required String uid,
  required BuildContext context,
}) async {
  final hostTest = await inst.ref("rooms/$roomName/host").get();
  if (hostTest.value == uid) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    inst.ref("rooms/$roomName").remove();
  } else {
    await inst.ref("rooms/$roomName/users/$uid").remove();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
