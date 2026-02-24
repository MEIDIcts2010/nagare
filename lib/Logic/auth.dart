import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html' as html;

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential> createAcoount(String email, String password) async {
  final session = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  return session;
}

Future<UserCredential> loginAcoount(String email, String password) async {
  final session = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  return session;
}

Future<void> LogOut() async {
  html.window.localStorage.removeWhere((key, value) => key == 'uid');
  await FirebaseAuth.instance.signOut();
}
