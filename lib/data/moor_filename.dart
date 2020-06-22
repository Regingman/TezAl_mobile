import 'package:moor_flutter/moor_flutter.dart';

part 'moor_filename.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get containerId => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 50).nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false)).nullable()();
}

@UseMoor(tables: [Tasks])
class TezAlDb extends _$TezAlDb {
  TezAlDb()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  Future insertTask(Task _task) => into(tasks).insert(_task);
  Future updateTask(Task _task) => update(tasks).replace(_task);
  Future deleteTask(Task _task) => delete(tasks).delete(_task);
  
}