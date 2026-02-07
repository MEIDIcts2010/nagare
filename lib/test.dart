import 'dart:convert';
import 'package:xxh3/xxh3.dart';

void main() {
  final String data = "foobar";

  // Конвертируем строку в UTF-8 байты
  final bytes = utf8.encode(data);
  print('Bytes: $bytes');

  // Хэшируем с помощью XXH3
  final int hashInt = xxh3(bytes); // как число
  final String hashHex = xxh3String(seed: 0, bytes); // как hex-строка

  print('XXH3‑64 (int): $hashInt');
  print('XXH3‑64 (hex): $hashHex');
}
