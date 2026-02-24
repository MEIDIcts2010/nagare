import 'package:http/http.dart' as http;
import 'dart:convert';

class VkVideos {
  final String nameVideo;
  final String videoId;
  final String ownerId;
  final String channelName;
  final String imgUri;

  VkVideos({
    required this.nameVideo,
    required this.channelName,
    required this.imgUri,
    required this.ownerId,
    required this.videoId,
  });
}

class VkSearchLogic {
  Future<List<VkVideos>> searchVideos(String query) async {
    final uri = Uri.parse(
      'https://api.vk.com/method/video.search?q=$query&access_token=vk1.a.RVmQS4iDmIDg6edm5FpE5IJ6_y30C7qMTpF8vCpWVmEUzT9jlX7H40pC8EGxf74BDDoz7fdSRy9NO52RZtxS4rfnSTeDiXYEpTzneW-r6kCn5TL1eU_rqDxD7epcXbDxQFpPUURCCOJoUSx1pOZ1rQiiMH_woAuBteXvMpVHnTA9N1jVPbNtkAtUtgxtVJDlsVrNOuIfrc6nPEXC4SYNEA&v=5.199',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('HTTP Error: ${response.statusCode}');
    }

    final data = json.decode(response.body);

    if (data['error'] != null) {
      throw Exception('VK Error: ${data['error']['error_msg']}');
    }

    final items = data['response']['items'] as List<dynamic>;

    return items.map<VkVideos>((item) {
      String preview = "";

      if (item['image'] != null && item['image'] is List) {
        final images = List<Map<String, dynamic>>.from(item['image']);

        images.sort((a, b) => (b['width'] ?? 0).compareTo(a['width'] ?? 0));

        preview = images.isNotEmpty ? (images.first['url'] ?? "") : "";
      }

      return VkVideos(
        videoId: item['id'].toString(),
        ownerId: item['owner_id'].toString(),
        nameVideo: item['title'] ?? "Без названия",
        channelName: item['owner_id'].toString(),
        imgUri: preview,
      );
    }).toList();
  }
}
