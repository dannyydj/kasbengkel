// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[1] as int?,
      workshopPhoneNumber: fields[2] as String,
      workshopName: fields[3] as String,
      workshopType: fields[4] as String,
      workshopAddress: fields[5] as String,
      workshopProvince: fields[6] as String,
    )
      ..rowid = fields[0] as int?
      ..createdAt = fields[7] as DateTime?
      ..updatedAt = fields[8] as DateTime?
      ..deletedAt = fields[9] as DateTime?
      ..lastSyncAt = fields[10] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.rowid)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.workshopPhoneNumber)
      ..writeByte(3)
      ..write(obj.workshopName)
      ..writeByte(4)
      ..write(obj.workshopType)
      ..writeByte(5)
      ..write(obj.workshopAddress)
      ..writeByte(6)
      ..write(obj.workshopProvince)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.deletedAt)
      ..writeByte(10)
      ..write(obj.lastSyncAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
