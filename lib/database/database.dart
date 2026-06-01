import 'package:drift/drift.dart';

part 'database.g.dart';
part 'tables/settings.dart';

@DriftDatabase(tables: <Type>[ExampleSettings])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;
}
