import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'dart:js' as js;

class VkVideoPlayer extends StatefulWidget {
  final String videoId;
  final String ownerId;

  const VkVideoPlayer({required this.ownerId, required this.videoId});

  @override
  State<VkVideoPlayer> createState() => _VkVideoPlayerState();
}

class _VkVideoPlayerState extends State<VkVideoPlayer> {
  late html.IFrameElement _iframe;
  late String viewId;

  @override
  void initState() {
    super.initState();

    viewId = "vk-video-${DateTime.now().millisecondsSinceEpoch}";

    _iframe = html.IFrameElement()
      ..src =
          "https://vk.com/video_ext.php?oid=${widget.ownerId}&id=${widget.videoId}&hd=2&js_api=1"
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'autoplay; encrypted-media'
      ..allowFullscreen = false;

    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => _iframe,
    );

    _iframe.onLoad.listen((_) {
      _initPlayer();
    });
  }

  void _initPlayer() {
    js.context.callMethod('eval', [
      """
      window.vkPlayer = VK.VideoPlayer(document.getElementsByTagName('iframe')[0]);
      """,
    ]);
  }

  void play() {
    js.context.callMethod('eval', ["window.vkPlayer.play();"]);
  }

  void pause() {
    js.context.callMethod('eval', ["window.vkPlayer.pause();"]);
  }

  void seek(int seconds) {
    js.context.callMethod('eval', ["window.vkPlayer.seek($seconds);"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(child: HtmlElementView(viewType: viewId)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: play,
              ),
              IconButton(
                icon: const Icon(Icons.pause, color: Colors.white),
                onPressed: pause,
              ),
              IconButton(
                icon: const Icon(Icons.fast_forward, color: Colors.white),
                onPressed: () => seek(60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
