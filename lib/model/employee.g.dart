// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 1;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employee(
      id: fields[1] as int?,
      name: fields[2] as String?,
      phoneNumber: fields[3] as dynamic,
    )
      ..rowid = fields[0] as int?
      ..createdAt = fields[4] as DateTime?
      ..updatedAt = fields[5] as DateTime?
      ..deletedAt = fields[6] as DateTime?
      ..lastSyncAt = fields[7] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.rowid)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.deletedAt)
      ..writeByte(7)
      ..write(obj.lastSyncAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
