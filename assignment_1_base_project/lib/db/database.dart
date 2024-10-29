import 'package:hive_flutter/hive_flutter.dart';

import 'character.dart';

class Database {
  // Box: Hive에서 데이터 저장 container or storage 단위
  final String _box = 'charactersBox';
  late Box<Character> box;

  Database() {
    //_init();
    box = Hive.box<Character>(_box);
  }

  /*Future<void> _init() async {
    await Hive.initFlutter();
    //Hive.registerAdapter(CharacterAdapter());
    await Hive.openBox<Character>(_box);
  }*/

  //The method is to store a list of GoT characters in a database
  Future<void> save({required List<Character> characters}) async{
    for(var c in characters){
      if (!box.containsKey(c.name)) { // 중복 확인
        await box.put(c.name, c);
      }
      print('Success to save: ${c.name}');
    }
  }

  //The method shall load all stored GoT characters and return them as array
  List<Character> get storedCharacters {
    //TODO: load the characters from a real database.
    final List<Character> dbCharacters = box.values.toList();

    return dbCharacters;
  }
}