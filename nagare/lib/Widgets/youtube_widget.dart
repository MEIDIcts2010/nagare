import 'package:nagare/Activity/youtube_search.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

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

  double _currentTime = 0;
  double _duration = 0;

  Timer? _timer;

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

    _startTimeUpdater();
  }

  void _startTimeUpdater() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;

      final currentTime = await _controller.currentTime;
      final duration = await _controller.duration;

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
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => YoutubeSearch(),
                            ),
                          );
                          dispose();
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 199, 14, 122),
                        width: 1.5,
                      ),
                    ),
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
                      onPressed: _controller.playVideo,
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white),
                      onPressed: _controller.pauseVideo,
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
              child: Row(
                children: [
                  Text(
                    widget.roomName,
                    style: TextStyle(color: Color.fromARGB(255, 0, 255, 55)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
