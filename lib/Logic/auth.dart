import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential> createAcoount(String email, String password) {
  return _auth.createUserWithEmailAndPassword(email: email, password: password);
}

Future<UserCredential> loginAcoount(String email, String password) {
  return _auth.signInWithEmailAndPassword(email: email, password: password);
}

Future<void> LogOut() async {
  await FirebaseAuth.instance.signOut();
}
