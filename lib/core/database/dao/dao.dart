import 'package:flutter/foundation.dart';

/// An abstract Data-Access Object.
///
/// Dao are used to interact with a table in the database.
abstract class Dao<T> {
  /// The description of the columns in the database that store the object.
  ///
  /// The description is stored as a list of column representation.
  /// These representations are encoded as a list of the column name and
  /// the SQL parameters needed for the table's creation.
  ///
  /// Example:
  /// ```dart
  /// [
  ///   ["foo", "INTEGER PRIMARY KEY"],
  ///   ["bar", "REAL"],
  ///   ["baz", "TEXT NOT NULL"]
  /// ]
  /// ```
  @protected
  List<List<String>> columnsDefinition;

  /// The SQLite creation query of the underlying table.
  String get creationQuery => """CREATE TABLE $tableName
      (${columnsDefinition.map((col) => col.join(" ")).toList().join(", ")})""";

  /// The name of the underlying table.
  String tableName;

  /// Converts a [Map<String, dynamic>] to a generic object.
  T fromMap(Map<String, dynamic> map);

  /// Converts a generic object to a [Map<String, dynamic>].
  Map<String, dynamic> toMap(T object);
}
