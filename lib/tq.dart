import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WebViewPage());
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final WebviewController _controller = WebviewController();
  bool _loading = true;
  String currentUrl = "";
  @override
  void initState() {
    super.initState();
    initWebView();
  }

  Future<void> initWebView() async {
    await _controller.initialize();

    // Загружаем тестовый сайт
    await _controller.loadUrl('https://vkvideo.ru');

    setState(() {
      _loading = false;
    });
  }

  void GettingURL() {
    _controller.url.listen((url) {
      currentUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebView Windows")),
      body: Stack(
        children: [
          Webview(_controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
