// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 3;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      vehiclePlateNumber: fields[3] as String,
      vehicleOwnerName: fields[4] as String,
      vehicleOwnerPhoneNumber: fields[5] as String,
      transactionDate: fields[6] as DateTime?,
      mechanicName: fields[7] as String,
      transactionAmount: fields[8] as int,
    )
      ..rowid = fields[0] as int?
      ..id = fields[1] as int?
      ..transactionNumber = fields[2] as String?
      ..transactionDetails = (fields[9] as List).cast<dynamic>()
      ..transactionMechanics = (fields[10] as List).cast<dynamic>()
      ..createdAt = fields[11] as DateTime?
      ..updatedAt = fields[12] as DateTime?
      ..deletedAt = fields[13] as DateTime?
      ..lastSyncAt = fields[14] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.rowid)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.transactionNumber)
      ..writeByte(3)
      ..write(obj.vehiclePlateNumber)
      ..writeByte(4)
      ..write(obj.vehicleOwnerName)
      ..writeByte(5)
      ..write(obj.vehicleOwnerPhoneNumber)
      ..writeByte(6)
      ..write(obj.transactionDate)
      ..writeByte(7)
      ..write(obj.mechanicName)
      ..writeByte(8)
      ..write(obj.transactionAmount)
      ..writeByte(9)
      ..write(obj.transactionDetails)
      ..writeByte(10)
      ..write(obj.transactionMechanics)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.deletedAt)
      ..writeByte(14)
      ..write(obj.lastSyncAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionDetailAdapter extends TypeAdapter<TransactionDetail> {
  @override
  final int typeId = 4;

  @override
  TransactionDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionDetail(
      product: fields[0] as Product?,
      qty: fields[1] as int,
      subtotal: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionDetail obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.qty)
      ..writeByte(2)
      ..write(obj.subtotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
