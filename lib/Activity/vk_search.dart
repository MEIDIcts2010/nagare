import 'package:flutter/material.dart';
import '../Logic/vk_search_logic.dart';
import 'create_room.dart';

class VkSearchPage extends StatefulWidget {
  const VkSearchPage({super.key});

  @override
  State<VkSearchPage> createState() => _VkSearchPageState();
}

class _VkSearchPageState extends State<VkSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String tokenState = 'Token not checked';
  List<VkVideos> results = [];

  // Поиск видео
  Future<void> search() async {
    // Если токен недействителен, авторизуем

    try {
      final searchResults = await VkSearchLogic().searchVideos(
        _controller.text,
      );

      setState(() {
        results = searchResults;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ошибка поиска: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Поиск VK Видео")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле ввода запроса
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Введите запрос",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            // Кнопка поиска
            TextButton(onPressed: search, child: Text('Search')),
            const SizedBox(height: 8),

            // Список результатов
            Expanded(
              child: results.isEmpty
                  ? Center(child: Text("Результаты появятся здесь"))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final video = results[index];
                        return ListTile(
                          leading: video.imgUri.isNotEmpty
                              ? Image.network(video.imgUri)
                              : SizedBox.shrink(),
                          title: Text(video.nameVideo),
                          subtitle: Text(video.channelName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateRoom(
                                  ownerId: video.ownerId,
                                  video: video.videoId,
                                  source: 'vk',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
