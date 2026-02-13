import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

void main() {
  runApp(test());
}

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    initStating();
  }

  Future<void> initStating() async {
    await _controller.initialize();
    await _controller.loadUrl("https://vkvideo.ru");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Webview(_controller)));
  }
}
