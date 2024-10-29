// The class is responsible to load the GoT characters from the GoTAPI (on https://anapioficeandfire.com/)
import 'dart:async';
import 'dart:convert';  // convert to JSON
import 'package:assignment_1_base_project/db/character.dart';
import 'package:http/http.dart' as http;

class API {
  // Note: the documentation for the API can be found here: https://anapioficeandfire.com/Documentation
  final String _charactersRoute =
      "https://anapioficeandfire.com/api/characters";

  // Loads the list of GoT characters
  Future<List<Character>> fetchRemoteGoTCharacters() async {
    // TODO: Load GoT characters from the _charactersRoute and return them.
    // For the API calls we recommend to use the 'http' package

    List<Character> characters = [];

    for (int i = 1; i <= 10; i++) {
      final response = await http.get(
        Uri.parse('$_charactersRoute?page=$i&pageSize=50'),
      );

      // HTTP 상태 코드 200: 요청이 성공적으로 처리됨
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        for (var item in data) {
          // 필드 비어 있지 않은지 확인
          if (item['name'] != null && item['name'].trim().isNotEmpty &&
              item['gender'] != null && item['gender'].trim().isNotEmpty &&
              (item['aliases'] as List).isNotEmpty) {
            // 중복 있는지 확인
            if (!characters.any((c) => c.name == item['name'])) {
              characters.add(Character.fromJson(item));
            }
          }
        }
      } else {
        throw Exception('Fail: cannot load characters');
      }
    }

    return characters;

    //*** Must be replaced
    /*return Future.delayed(
      Duration(seconds: 3),
      () => [
        Character(
          name: "Jon Snow",
          gender: "Male",
          aliases: [
            "Lord Snow",
            "Ned Stark's Bastard",
            "The Snow of Winterfell",
            "The Crow-Come-Over",
            "The 998th Lord Commander of the Night's Watch",
            "The Bastard of Winterfell",
            "The Black Bastard of the Wall",
            "Lord Crow"
          ],
        ),
        Character(
          name: "Brandon Stark",
          gender: "Male",
          aliases: ["Bran", "Bran the Broken", "The Winged Wolf"],
        ),
        Character(
          name: "Margaery Tyrell",
          gender: "Female",
          aliases: [
            "The Little Queen",
            "The Little Rose",
            "Maid Margaery",
          ],
        ),
      ],
    );*/
    //*** Replace up to here
  }
}