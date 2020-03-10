import 'package:flutter/foundation.dart';

/// Abstract Data-Access Object Class
abstract class Dao<T> {
  /// Getter for the table columns
  @protected
  String get columns =>
      columnsDefinition.map((col) => col.join(" ")).toList().join(", ");

  /// Description of the columns in the database that store the object
  @protected
  List<List<String>> get columnsDefinition;

  /// Getter for the create table query
  String get createTableQuery => """CREATE TABLE $tableName ($columns)""";

  /// Getter for the table name
  String get tableName;

  /// Converts a [Map<String, dynamic>] to a generic object
  T fromMap(Map<String, dynamic> map);

  /// Converts a generic object to a [Map<String, dynamic>]
  Map<String, dynamic> toMap(T object);
}
