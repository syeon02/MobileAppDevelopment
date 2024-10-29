import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject{ // Hive 사용을 위해 상속
  Character({
    required this.name,
    required this.gender,
    required this.aliases,
  });

  @HiveField(0) // 필드 순서
  final String name;

  @HiveField(1)
  final String gender;

  @HiveField(2)
  final List<String> aliases;

  // 팩토리 fromJson 생성자
  // 키-값 쌍으로 구성된 JSON 객체: String 타입의 키 & 어떤 타입이어도 상관 없는 데이터
  factory Character.fromJson(Map<String, dynamic> json){
    return Character(
      name: json['name']?? 'Unknown', // 존재하지 않는 경우 Unknown
      gender: json['gender']?? 'Unknown',
      aliases: List<String>.from(json['aliases']?? []), // 존재하지 않는 경우 빈 리스트
    );
  }

}