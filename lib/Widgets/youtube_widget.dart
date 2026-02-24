import 'package:nagare/Activity/youtube_search.dart';
import 'package:nagare/Widgets/chat_widget%20+%20logic.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Activity/home_page.dart';
import '../Logic/createroom_logic.dart';
import '../Activity/404.dart';
import 'dart:html';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoId;
  final roomName;
  const YoutubePlayerWidget({
    super.key,
    required this.videoId,
    required this.roomName,
  });

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool _hostTest = false;
  double _currentTime = 0;
  double _duration = 0;
  bool _isActuallyPlaying = false;

  Timer? _timer;

  Future<void> _checkHost() async {
    final id = window.localStorage['uid'];
    final hostSnapshot = await FirebaseDatabase.instance
        .ref('rooms/${widget.roomName}/host')
        .get();

    if (id == hostSnapshot.value.toString()) {
      setState(() {
        _hostTest = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      params: YoutubePlayerParams(
        showControls: false,
        enableJavaScript: true,
        interfaceLanguage: 'ru',
      ),
    );

    _controller.listen((event) {
      if (event.playerState == PlayerState.playing) {
        _isActuallyPlaying = true;
      } else if (event.playerState == PlayerState.paused) {
        _isActuallyPlaying = false;
      }
    });

    _checkHost().then((_) {
      _startTimeUpdater();
      _startPlayerStateSync(); // 👈 ВОТ ГЛАВНОЕ
    });
  }

  //
  void _startPlayerStateSync() {
    FirebaseDatabase.instance
        .ref('rooms/${widget.roomName}/playerState')
        .onValue
        .listen((event) async {
          if (_hostTest) return;

          final value = event.snapshot.value;
          if (value == null) return;

          final shouldPlay = value == true || value.toString() == "true";

          if (shouldPlay) {
            _controller.playVideo();
          } else {
            _controller.pauseVideo();
          }
        });
  }

  void _startTimeUpdater() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;

      final currentTime = await _controller.currentTime;
      final duration = await _controller.duration;

      if (_hostTest) {
        FirebaseDatabase.instance
            .ref('rooms/${widget.roomName}/currentTimeWatch')
            .set(currentTime.toString()); // синхронизация с базой
      } else {
        final snapshot = await FirebaseDatabase.instance
            .ref('rooms/${widget.roomName}/currentTimeWatch')
            .get();
        var hostTime = double.tryParse(snapshot.value.toString());
        var razn = hostTime! - currentTime;

        if (razn.abs() > 1) {
          _controller.seekTo(seconds: hostTime, allowSeekAhead: true);
        }
      }

      var existTest = await FirebaseDatabase.instance
          .ref('rooms/${widget.roomName}')
          .get();

      if (!existTest.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Error404()),
        );
      }

      setState(() {
        _duration = duration;
        _currentTime = currentTime > duration ? duration : currentTime;
      });
    });
  }

  double get safeMax => (_duration > 0) ? _duration : 1;

  double get safeValue {
    if (_duration <= 0) return 0;
    if (_currentTime > _duration) return _duration;
    if (_currentTime < 0) return 0;
    return _currentTime;
  }

  void _seekVideo(double value) {
    _controller.seekTo(seconds: value, allowSeekAhead: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 10, 17),
      body: Row(
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () async {
                          await deleteRoom(
                            roomName: widget.roomName,
                            uid: window.localStorage['uid']!,
                            context: context,
                          );
                          dispose();
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: _controller,
                      aspectRatio: 16 / 9,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Slider(
                    value: safeValue,
                    min: 0,
                    max: safeMax,

                    onChanged: _duration > 0
                        ? (value) {
                            setState(() {
                              _currentTime = value;
                            });
                          }
                        : null,

                    onChangeEnd: _duration > 0
                        ? (value) {
                            _seekVideo(value);
                          }
                        : null,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () {
                        _controller.playVideo();
                        if (_hostTest) {
                          FirebaseDatabase.instance
                              .ref('rooms/${widget.roomName}/playerState')
                              .set(true);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white),
                      onPressed: () {
                        _controller.pauseVideo();
                        if (_hostTest) {
                          FirebaseDatabase.instance
                              .ref('rooms/${widget.roomName}/playerState')
                              .set(false);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 30, 30, 30),
              child: ChatWidget(roomName: widget.roomName),
            ),
          ),
        ],
      ),
    );
  }
}
