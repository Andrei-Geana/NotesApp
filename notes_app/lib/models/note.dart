import 'package:isar/isar.dart';

part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  String title = "";
  String data = "";
  DateTime createdAt = DateTime.now();
  String password = "";
}
