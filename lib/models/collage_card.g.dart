// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collage_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollageCardAdapter extends TypeAdapter<CollageCard> {
  @override
  final int typeId = 2;

  @override
  CollageCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollageCard(
      id: fields[0] as String,
      imagePaths: (fields[1] as List).cast<String>(),
      title: fields[2] as String,
      createdAt: fields[3] as DateTime,
      isFavorite: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CollageCard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePaths)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollageCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
