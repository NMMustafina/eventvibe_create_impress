import 'package:hive/hive.dart';

part 'album_model.g.dart';

@HiveType(typeId: 0)
class Album extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> imagePaths;

  Album({required this.name, required this.imagePaths});
}
