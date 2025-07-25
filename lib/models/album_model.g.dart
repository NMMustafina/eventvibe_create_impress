// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumAdapter extends TypeAdapter<Album> {
  @override
  final int typeId = 0;

  @override
  Album read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Album(
      name: fields[0] as String,
      imagePaths: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Album obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
