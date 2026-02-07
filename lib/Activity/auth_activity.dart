import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nagare/Widgets/auth_image_view.dart';

class AuthActivity extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  AuthActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 10, 17),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'nagare-watch',
                    style: GoogleFonts.pressStart2p(
                      color: const Color.fromARGB(255, 199, 14, 122),
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: AuthImageViewList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 199, 14, 122),
                  ),
                ),
                child: Text(
                  'Pls login in account',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: TextField(
                cursorColor: const Color.fromARGB(255, 190, 72, 141),
                cursorWidth: 4,
                cursorHeight: 19,
                showCursor: true,
                controller: _controller,
                style: GoogleFonts.pressStart2p(
                  color: const Color.fromARGB(255, 199, 14, 122),
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: ">> Enter your email",
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 199, 14, 122),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 190, 72, 141),
                    ),
                  ),
                  hintStyle: GoogleFonts.pressStart2p(
                    color: const Color.fromARGB(255, 250, 123, 155),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: TextField(
                obscureText: true,
                cursorColor: const Color.fromARGB(255, 190, 72, 141),
                cursorWidth: 4,
                cursorHeight: 19,
                showCursor: true,
                controller: _controller2,
                style: GoogleFonts.pressStart2p(
                  color: const Color.fromARGB(255, 199, 14, 122),
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: ">> Enter your password",
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 199, 14, 122),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 190, 72, 141),
                    ),
                  ),
                  hintStyle: GoogleFonts.pressStart2p(
                    color: const Color.fromARGB(255, 250, 123, 155),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Color.fromARGB(255, 199, 14, 122),
                  ),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: const Color.fromARGB(255, 8, 10, 17),
                ),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _controller.text,
                      password: _controller2.text,
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'login',
                  style: GoogleFonts.pressStart2p(
                    color: const Color.fromARGB(255, 199, 14, 122),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Color.fromARGB(255, 199, 14, 122),
                  ),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: const Color.fromARGB(255, 8, 10, 17),
                ),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _controller.text,
                      password: _controller2.text,
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'registrate',
                  style: GoogleFonts.pressStart2p(
                    color: const Color.fromARGB(255, 199, 14, 122),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
