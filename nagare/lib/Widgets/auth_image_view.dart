import 'package:flutter/material.dart';
import 'dart:async';

class AuthImageViewList extends StatefulWidget {
  const AuthImageViewList({super.key});

  @override
  State<AuthImageViewList> createState() => _AuthImageViewListState();
}

class _AuthImageViewListState extends State<AuthImageViewList> {
  final ScrollController _scrollControler = ScrollController();

  Timer? timer;
  double position = 0.0;

  final List<String> images = [
    'https://art.pixilart.com/1605119e3b10d55.gif',
    'https://art.pixilart.com/3e385242f678.gif',
    'https://art.pixilart.com/sr28c76db86daaws3.gif',
    'https://art.pixilart.com/07390b357686c57.gif',
    'https://art.pixilart.com/original/sr2927699dd38aws3.gif',
    'https://art.pixilart.com/1bd692cb3b332f6.gif',
    'https://art.pixilart.com/sr2ed21fe9d2935.gif',
    'https://art.pixilart.com/sr2247c8c22f592.gif',
    'https://art.pixilart.com/0d6745ddd6b100d.gif',
    'https://art.pixilart.com/fbe5bf829c70.gif',
    'https://art.pixilart.com/sr5ze21896fe33aws3.gif',
    'https://art.pixilart.com/5d6b72be1b0192e.gif',
    'https://art.pixilart.com/4450f2bb3daad7f.gif',
    'https://art.pixilart.com/sr241f6a17785aws3.gif',
    'https://art.pixilart.com/original/sr2c37f758f50aws3.gif',
    'https://art.pixilart.com/1b279a302cf2f25.gif',
    'https://art.pixilart.com/original/sr28e83364055aws3.gif',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoScroll();
    });
  }

  void startAutoScroll() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      if (!_scrollControler.hasClients) return;

      position += 1;

      if (position >= _scrollControler.position.maxScrollExtent) {
        position = 0;
        _scrollControler.jumpTo(position);
      } else {
        _scrollControler.jumpTo(position);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _scrollControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fulllist = [...images, ...images, ...images, ...images];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 199, 14, 122)),
      ),
      child: SizedBox(
        height: 75,
        child: ListView.builder(
          controller: _scrollControler,
          scrollDirection: Axis.horizontal,
          itemCount: fulllist.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Image.network(fulllist[index]);
          },
        ),
      ),
    );
  }
}
