// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_filename.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class Task extends DataClass implements Insertable<Task> {
  final int id;
  final int containerId;
  final String name;
  final bool completed;
  Task({@required this.id, this.containerId, this.name, this.completed});
  factory Task.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Task(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      containerId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}container_id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      completed:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}completed']),
    );
  }
  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Task(
      id: serializer.fromJson<int>(json['id']),
      containerId: serializer.fromJson<int>(json['containerId']),
      name: serializer.fromJson<String>(json['name']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'containerId': serializer.toJson<int>(containerId),
      'name': serializer.toJson<String>(name),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<Task>>(bool nullToAbsent) {
    return TasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      containerId: containerId == null && nullToAbsent
          ? const Value.absent()
          : Value(containerId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      completed: completed == null && nullToAbsent
          ? const Value.absent()
          : Value(completed),
    ) as T;
  }

  Task copyWith({int id, int containerId, String name, bool completed}) => Task(
        id: id ?? this.id,
        containerId: containerId ?? this.containerId,
        name: name ?? this.name,
        completed: completed ?? this.completed,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('containerId: $containerId, ')
          ..write('name: $name, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(containerId.hashCode, $mrjc(name.hashCode, completed.hashCode))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == id &&
          other.containerId == containerId &&
          other.name == name &&
          other.completed == completed);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<int> containerId;
  final Value<String> name;
  final Value<bool> completed;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.containerId = const Value.absent(),
    this.name = const Value.absent(),
    this.completed = const Value.absent(),
  });
  TasksCompanion copyWith(
      {Value<int> id,
      Value<int> containerId,
      Value<String> name,
      Value<bool> completed}) {
    return TasksCompanion(
      id: id ?? this.id,
      containerId: containerId ?? this.containerId,
      name: name ?? this.name,
      completed: completed ?? this.completed,
    );
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  final GeneratedDatabase _db;
  final String _alias;
  $TasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _containerIdMeta =
      const VerificationMeta('containerId');
  GeneratedIntColumn _containerId;
  @override
  GeneratedIntColumn get containerId =>
      _containerId ??= _constructContainerId();
  GeneratedIntColumn _constructContainerId() {
    return GeneratedIntColumn(
      'container_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, true,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _completedMeta = const VerificationMeta('completed');
  GeneratedBoolColumn _completed;
  @override
  GeneratedBoolColumn get completed => _completed ??= _constructCompleted();
  GeneratedBoolColumn _constructCompleted() {
    return GeneratedBoolColumn('completed', $tableName, true,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, containerId, name, completed];
  @override
  $TasksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tasks';
  @override
  final String actualTableName = 'tasks';
  @override
  VerificationContext validateIntegrity(TasksCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.containerId.present) {
      context.handle(_containerIdMeta,
          containerId.isAcceptableValue(d.containerId.value, _containerIdMeta));
    } else if (containerId.isRequired && isInserting) {
      context.missing(_containerIdMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.completed.present) {
      context.handle(_completedMeta,
          completed.isAcceptableValue(d.completed.value, _completedMeta));
    } else if (completed.isRequired && isInserting) {
      context.missing(_completedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Task.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(TasksCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.containerId.present) {
      map['container_id'] = Variable<int, IntType>(d.containerId.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.completed.present) {
      map['completed'] = Variable<bool, BoolType>(d.completed.value);
    }
    return map;
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(_db, alias);
  }
}

abstract class _$TezAlDb extends GeneratedDatabase {
  _$TezAlDb(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $TasksTable _tasks;
  $TasksTable get tasks => _tasks ??= $TasksTable(this);
  @override
  List<TableInfo> get allTables => [tasks];
}
