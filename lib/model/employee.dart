import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '/api/gsheet_api.dart';

part 'employee.g.dart';

@HiveType(typeId: 1)
class Employee extends HiveObject{
  @HiveField(0)
  int? rowid = 0;

  @HiveField(1)
  int? id = 0;

  @HiveField(2)
  String? name = "";

  @HiveField(3)
  dynamic phoneNumber = "";

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  DateTime? updatedAt;

  @HiveField(6)
  DateTime? deletedAt;

  @HiveField(7)
  DateTime? lastSyncAt;

  Employee({
    this.id = 0,
    this.name = "",
    this.phoneNumber = "",
  });

  factory Employee.fromJson(dynamic json){
    return Employee(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String,dynamic> toJson() => {
    'name':name,
    'phone_number':phoneNumber,
  };

  @override
  String toString(){
    return "{ ${this.id} ${this.name} ${this.phoneNumber} }";
  }
}

class EmployeeGSheet extends Employee {
  GSheetAPI sheet = GSheetAPI(table: "Employees");
 
  Future<List<Employee>> fetchDataFromSheet() async {
    final response = await http.get(sheet.uri("read"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsed = jsonDecode(response.body);
      // print(parsed["data"]);
      return parsed["data"].map<Employee>( (json) => Employee.fromJson(json) ).toList();

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    } 
  }

  Future<Employee> insertDataToSheet(Employee employeeData) async {
    final response = await http.post(
      sheet.uri("insert"),
      body: employeeData.toJson()
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsed = jsonDecode(response.body);
      // print(parsed["data"]);
      return parsed["data"].map<Employee>( (json) => Employee.fromJson(json) ).toList();

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    } 
  }
}
