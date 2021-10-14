import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '/api/gsheet_api.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int? rowid = 0;

  @HiveField(1)
  int? id = 0;

  @HiveField(2)
  String workshopPhoneNumber;

  @HiveField(3)
  String workshopName;

  @HiveField(4)
  String workshopType;

  @HiveField(5)
  String workshopAddress;

  @HiveField(6)
  String workshopProvince;

  @HiveField(7)
  DateTime? createdAt;

  @HiveField(8)
  DateTime? updatedAt;

  @HiveField(9)
  DateTime? deletedAt;

  @HiveField(10)
  DateTime? lastSyncAt;

  User({
    this.id = 0,
    this.workshopPhoneNumber = "0",
    this.workshopName = "",
    this.workshopType = "",
    this.workshopAddress = "",
    this.workshopProvince = "",
  });

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'id': this.id,
      'workshop_phone_number': this.workshopPhoneNumber,
      'workshop_name': this.workshopName,
      'workshop_type': this.workshopType,
      'workshop_address': this.workshopAddress,
      'workshop_province': this.workshopProvince,
    };
  }

  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
        id: parsedJson['id'],
        workshopPhoneNumber : parsedJson['workshop_phone_number'],
        workshopName: parsedJson['workshop_name'],
        workshopType: parsedJson['workshop_type'],
        workshopAddress: parsedJson['workshop_address'],
        workshopProvince: parsedJson['workshop_province'],
    );
  }

  @override
  String toString(){
    return "{ ${this.workshopPhoneNumber} ${this.workshopName} ${this.workshopType} }";
  }
}
