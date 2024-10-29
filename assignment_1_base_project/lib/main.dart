import 'package:assignment_1_base_project/screens/characters_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:assignment_1_base_project/db/character.dart'; // Character 클래스와 어댑터 등록을 위해 필요
import 'package:hive_flutter/hive_flutter.dart'; // Hive 초기화에 필요

void main() async {
  // 비동기적 실행
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // Hive 초기화
  Hive.registerAdapter(CharacterAdapter()); // Character 어댑터 등록

  // Box 열기
  await Hive.openBox<Character>('charactersBox');

  runApp(
    MaterialApp(
      title: 'GoT Characters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CharactersListScreen(),
    ),
  );
}