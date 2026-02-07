import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:nagare/Activity/youtube_search.dart';
import 'dart:convert';

const API = "AIzaSyBu-cbX2-d7BrWVMM3wIcDHknTFmIYGCfY";
const String baseUrl = "https://www.googleapis.com/youtube/v3/search";

class YoutubeVideo {
  final String nameVideo;
  final String videoId;
  final String channelName;
  final String imgUri;

  YoutubeVideo({
    required this.nameVideo,
    required this.videoId,
    required this.channelName,
    required this.imgUri,
  });
}

class Service {
  Future<List<YoutubeVideo>> searchVideo(String query) async {
    final url = Uri.parse(
      "$baseUrl?part=snippet"
      "&maxResults=20"
      "&q=$query"
      "&type=video"
      "&key=$API",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var items = data['items'] as List<dynamic>;

      return items.map<YoutubeVideo>((item) {
        return YoutubeVideo(
          nameVideo: item['snippet']['title'] ?? "Без названия",
          videoId: item['id']['videoId'] ?? "",
          channelName: item['snippet']['channelTitle'] ?? "Unknown",
          imgUri: item['snippet']['thumbnails']?['high']?['url'] ?? "",
        );
      }).toList();
    } else {
      throw Exception('Ошибка ${response.statusCode}');
    }
  }
}
