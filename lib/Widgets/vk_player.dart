// ignore_for_file: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class VkVideoPlayer extends StatefulWidget {
  final ownerId;
  final videoId;
  final roomName;
  const VkVideoPlayer({
    required this.roomName,
    required this.ownerId,
    required this.videoId,
  });

  @override
  State<VkVideoPlayer> createState() => _VkVideoPlayerState();
}

class _VkVideoPlayerState extends State<VkVideoPlayer> {
  late html.IFrameElement _iframe;
  late String viewId;

  late js.JsObject vkPlayer;

  bool hostTest = false;
  double currentTime = 0;
  double duration = 0;
  String state = '';
  Timer? _timer;

  Future<void> _checkHost() async {
    final id = html.window.localStorage['uid'];
    final hostSnapshot = await FirebaseDatabase.instance
        .ref('rooms/${widget.roomName}/host')
        .get();

    if (id == hostSnapshot.value.toString()) {
      setState(() {
        hostTest = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    viewId = 'vk-video-${DateTime.now().millisecondsSinceEpoch}';

    _iframe = html.IFrameElement()
      ..src =
          'https://vk.com/video_ext.php?oid=${widget.ownerId}&id=${widget.videoId}&hd=2&js_api=1'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'autoplay; encrypted-media';

    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => _iframe,
    );

    _iframe.onLoad.listen((_) {
      print('iframe loaded');
      _initPlayer();
    });

    _checkHost();
  }

  void playerSync() {
    print('hello');
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      currentTime = getCurrentTime();
      state = getState();
      print('object');
      if (hostTest) {
        FirebaseDatabase.instance
            .ref('rooms/${widget.roomName}/currentTimeWatch')
            .set(currentTime.toString());
        FirebaseDatabase.instance
            .ref('rooms/${widget.roomName}/playerState')
            .set(state);
      } else {
        var hostTimeSnapshot = await FirebaseDatabase.instance
            .ref('rooms/${widget.roomName}/currentTimeWatch')
            .get();
        var hostStateSnapshot = await FirebaseDatabase.instance
            .ref('rooms/${widget.roomName}/playerState')
            .get();

        var hostState = hostStateSnapshot.value.toString();
        var hostTime = double.tryParse(hostTimeSnapshot.value.toString());

        var razn = hostTime! - currentTime;

        if (razn.abs() >= 1) {
          _seekTo(hostTime.toInt());
        }

        if (hostState == 'paused' && state != 'paused') {
          _pause();
        } else if (hostState == 'playing' && state != 'playing') {
          _play();
        }
      }
    });
  }

  void _initPlayer() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (js.context.hasProperty('VK')) {
        vkPlayer = js.JsObject(js.context['VK']['VideoPlayer'], [_iframe]);

        print('VK Player created');

        // Вместо передачи Dart callback используем JS функцию через eval
        js.context.callMethod('eval', [
          """
        window.vkPlayer = window.VK.VideoPlayer(document.getElementsByTagName('iframe')[0]);
        window.vkPlayer.on('playerReady', function(_) {
          console.log('PLAYER READY 🔥');
        });
        """,
        ]);

        // Можно потом синхронизацию запускать вручную после паузы
        playerSync();
      } else {
        print('VK not loaded');
      }
    });
  }

  void _play() {
    vkPlayer.callMethod('play');
  }

  void _pause() {
    vkPlayer.callMethod('pause');
  }

  void _seekTo(int seconds) {
    vkPlayer.callMethod('seek', [seconds]);
  }

  double getCurrentTime() {
    print(vkPlayer.callMethod('getCurrentTime'));
    return vkPlayer.callMethod('getCurrentTime');
  }

  double getDuration() {
    print(vkPlayer.callMethod('getDuration'));
    return vkPlayer.callMethod('getDuration');
  }

  String getState() {
    print(vkPlayer.callMethod('getState'));
    return vkPlayer.callMethod('getState');
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
                onPressed: _play,
              ),
              IconButton(
                icon: const Icon(Icons.pause, color: Colors.white),
                onPressed: _pause,
              ),
              IconButton(
                icon: const Icon(Icons.fast_forward, color: Colors.white),
                onPressed: () => _seekTo(60),
              ),
              TextButton(
                onPressed: () {
                  getCurrentTime();
                  getDuration();
                  getState();
                },
                child: Text('data'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
