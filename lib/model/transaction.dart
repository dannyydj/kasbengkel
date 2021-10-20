//pkg
import 'package:hive/hive.dart';
//model
import 'product.dart';
import 'employee.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction extends HiveObject{
  @HiveField(0)
  int? rowid = 0;

  @HiveField(1)
  int? id = 0;

  @HiveField(2)
  String? transactionNumber = "";

  @HiveField(3)
  String vehiclePlateNumber = "";

  @HiveField(4)
  String vehicleOwnerName = "";

  @HiveField(5)
  String vehicleOwnerPhoneNumber = "";

  @HiveField(6)
  DateTime transactionDate = DateTime.now();

  @HiveField(7)
  String mechanicName = "";

  @HiveField(8)
  int transactionAmount = 0;

  @HiveField(9)
  List transactionDetails = [];

  @HiveField(10)
  List transactionMechanics = [];

  @HiveField(11)
  DateTime? createdAt;

  @HiveField(12)
  DateTime? updatedAt;

  @HiveField(13)
  DateTime? deletedAt;

  @HiveField(14)
  DateTime? lastSyncAt;

  Transaction({
    this.vehiclePlateNumber = "",
    this.vehicleOwnerName = "",
    this.vehicleOwnerPhoneNumber = "",
    DateTime? transactionDate,
    this.mechanicName = "",
    this.transactionAmount = 0,
  }) : this.transactionDate = transactionDate ?? DateTime.now();

  @override
  String toString(){
    return "{ ${this.vehiclePlateNumber} ${this.vehicleOwnerName} ${this.vehicleOwnerPhoneNumber} ${this.transactionDate} ${this.transactionAmount} }";
  }
}

@HiveType(typeId: 4)
class TransactionDetail extends HiveObject {
  @HiveField(0)
  Product product = Product();

  @HiveField(1)
  int qty = 0;

  @HiveField(2)
  int subtotal = 0;

  TransactionDetail({
    Product? product,
    this.qty = 0,
    this.subtotal = 0
  }) : this.product = product ?? Product();

  @override
  String toString() {
    return "{ ${this.product.name} ${this.qty} ${this.subtotal} }";
  }

}

// class TransactionMechanic {
//   Employee employee = Employee();
// }