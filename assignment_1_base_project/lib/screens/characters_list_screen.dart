import 'package:assignment_1_base_project/screens/character_detail_screen.dart';
import 'package:assignment_1_base_project/db/character.dart';
import 'package:assignment_1_base_project/db/database.dart';
import 'package:assignment_1_base_project/networking/api.dart';
import 'package:flutter/material.dart';

class CharactersListScreen extends StatefulWidget {
  @override
  _CharactersListScreenState createState() => _CharactersListScreenState();
}

class _CharactersListScreenState extends State<CharactersListScreen> {
  List<Character> characters = [];
  final API api = API(); // API 객체
  final Database db = Database(); // Database 객체

  List<Character> searchedCharacters = [];
  // 텍스트 검색 필드 컨트롤러
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      characters = [
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
      ];
      searchedCharacters = characters;
    });

    // 기존 캐릭터 확인
    print('default characters: ${characters.map((c) => c.name).toList()}');

    _loadStoredCharacters();
    _search.addListener(_searchCharacters);
  }

  Future<void> _loadStoredCharacters() async {

    await Future.delayed(
        Duration(seconds: 3),
            () async {
          List<Character> newCharacters = await api.fetchRemoteGoTCharacters();

          newCharacters.forEach((char) {
            if(!characters.any((character) => character.name == char.name)) {
              //db.save(characters: [char]); // DB에 저장
              setState(() {
                characters.add(char);
                searchedCharacters = characters;
              });
            }
          });
          print('characters: ${characters.map((c) => c.name).toList()}');

          // DB에 최종 캐릭터 리스트 저장
          db.save(characters: characters);
          print('characters saved in db: ${db.storedCharacters.map((c) => c.name).toList()}');
        }

    );
  }

  void _searchCharacters() {
    final s = _search.text.toLowerCase();
    setState(() {
      searchedCharacters = characters.where((character) {
        return character.name.toLowerCase().contains(s);
      }).toList();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game of Thrones Characters'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding:const EdgeInsets.all(8.0),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  labelText: 'Search Characters',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => _buildCharacterListTile(index),
                separatorBuilder: (_, __) => Divider(),
                itemCount: searchedCharacters.length, // 필터링된 캐릭터 수
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterListTile(int index) {
    final Character character = searchedCharacters![index];
    return ListTile(
      title: Text(
        '${index + 1}. ${character.name}',
        style: TextStyle(fontSize: 17),
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: () {
        //TODO: open the CharacterDetailScreen with the character.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CharacterDetailScreen(character: character),
          ),
        );
      },
    );
  }
}