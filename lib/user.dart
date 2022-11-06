import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class UserData {
  UserData({
    required this.id,
    required this.name,
    required this.atype,
    required this.age,
    required this.gender,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String atype;

  @HiveField(3)
  String gender;

  @HiveField(4)
  String age;
}
