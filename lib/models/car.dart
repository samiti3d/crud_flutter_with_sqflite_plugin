import 'package:sqflite_flutter/helper/dbhelper.dart';

class Car {
  late int? id;
  late String name;
  late int miles;

  Car({
    required this.name,
    required this.miles,
  });

  Car.fromMap(Map<String, dynamic> item)
      : name = item["name"],
        miles = item["miles"];

  Car.fromMapDB(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        miles = item["miles"];

  Map<String, Object> toMap() {
    return {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnMiles: miles,
    };
  }
}
