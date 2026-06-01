import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_drift/sentry_drift.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../database/database.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
Database database(Ref ref) {
  final ISentrySpan tr = Sentry.startTransaction(
    'drift',
    'database',
    bindToScope: true,
  );

  final QueryExecutor executor = driftDatabase(
    name: 'db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  ).interceptWith(SentryQueryInterceptor(databaseName: 'db'));

  final Database db = Database(executor);
  ref.onDispose(() async {
    await db.close();
    await tr.finish(status: const SpanStatus.ok());
  });
  return db;
}
