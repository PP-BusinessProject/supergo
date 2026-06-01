// not needed in database
// ignore_for_file: recursive_getters

part of '../database.dart';

/// Persistent application settings table.
///
/// This table stores global user preferences such as UI language,
/// theme configuration, and reader-related settings.
///
/// Only a single row is expected to exist in this table.
class ExampleSettings extends Table {
  @override
  String get tableName => 'settings';
  @override
  bool get isStrict => true;
  @override
  bool get withoutRowId => true;

  /// Primary key definition.
  ///
  /// This table is designed as a singleton table, so the primary key
  /// ensures only one logical row exists (`id = true`).
  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  /// Singleton row identifier.
  ///
  /// Always `true`. Used to enforce a single-row settings table.
  BoolColumn get id => boolean()
      .check(id.equals(true))
      .withDefault(const Constant<bool>(true))();
}
