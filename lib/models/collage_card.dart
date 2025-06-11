import 'package:hive/hive.dart';

part 'collage_card.g.dart';

@HiveType(typeId: 2)
class CollageCard extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<String> imagePaths;

  @HiveField(2)
  String title;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isFavorite;

  CollageCard({
    required this.id,
    required this.imagePaths,
    required this.title,
    required this.createdAt,
    this.isFavorite = false,
  });
}
