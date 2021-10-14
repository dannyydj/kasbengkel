import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject{
  @HiveField(0)
  int? rowid = 0;

  @HiveField(1)
  int? id = 0;

  @HiveField(2)
  String? productCode = "";

  @HiveField(3)
  String? name = "";

  @HiveField(4)
  int? price = 0;

  @HiveField(5)
  DateTime? createdAt;

  @HiveField(6)
  DateTime? updatedAt;

  @HiveField(7)
  DateTime? deletedAt;

  @HiveField(8)
  DateTime? lastSyncAt;

  Product({
    this.name = "",
    this.price = 0,
    this.productCode = "",
  });

  @override
  String toString(){
    return "{ ${this.productCode} ${this.name} ${this.price} }";
  }
}