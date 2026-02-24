import 'package:flutter/material.dart';
import 'package:nagare/Activity/create_room.dart';
import 'package:nagare/Logic/youtube_search_logic.dart';

class YoutubeSearch extends StatefulWidget {
  @override
  State<YoutubeSearch> createState() => _YoutubeSearchState();
}

class _YoutubeSearchState extends State<YoutubeSearch> {
  List<YoutubeVideo> results = [];
  TextEditingController controller = TextEditingController();

  // Функция поиска
  Future<void> search() async {
    final searchResults = await Service().searchVideo(controller.text);

    // Обновляем состояние, чтобы список перерисовался
    setState(() {
      results = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Поиск YouTube")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле ввода
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Введите запрос",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            // Кнопка поиска
            TextButton(onPressed: search, child: Text('Искать')),

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
                          leading: video.imgUri != null
                              ? Image.network(video.imgUri!)
                              : SizedBox.shrink(),
                          title: Text(video.nameVideo ?? "Нет названия"),
                          subtitle: Text(video.channelName ?? "Нет канала"),
                          onTap: () {
                            // Проверяем, что videoId есть
                            if (video.videoId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Невозможно создать комнату: нет ID видео",
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateRoom(
                                  ownerId: '',
                                  video: video.videoId,
                                  source: 'yt',
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
