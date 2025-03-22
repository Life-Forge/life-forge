// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserdataTable extends Userdata
    with TableInfo<$UserdataTable, UserdataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserdataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personalDataMeta = const VerificationMeta(
    'personalData',
  );
  @override
  late final GeneratedColumn<String> personalData = GeneratedColumn<String>(
    'personal_data',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalsDetailsMeta = const VerificationMeta(
    'goalsDetails',
  );
  @override
  late final GeneratedColumn<String> goalsDetails = GeneratedColumn<String>(
    'goals_details',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 5000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userLevelMeta = const VerificationMeta(
    'userLevel',
  );
  @override
  late final GeneratedColumn<int> userLevel = GeneratedColumn<int>(
    'user_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(1),
  );
  static const VerificationMeta _userPointsMeta = const VerificationMeta(
    'userPoints',
  );
  @override
  late final GeneratedColumn<int> userPoints = GeneratedColumn<int>(
    'user_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personalData,
    goalsDetails,
    userLevel,
    userPoints,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'userdata';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserdataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('personal_data')) {
      context.handle(
        _personalDataMeta,
        personalData.isAcceptableOrUnknown(
          data['personal_data']!,
          _personalDataMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personalDataMeta);
    }
    if (data.containsKey('goals_details')) {
      context.handle(
        _goalsDetailsMeta,
        goalsDetails.isAcceptableOrUnknown(
          data['goals_details']!,
          _goalsDetailsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalsDetailsMeta);
    }
    if (data.containsKey('user_level')) {
      context.handle(
        _userLevelMeta,
        userLevel.isAcceptableOrUnknown(data['user_level']!, _userLevelMeta),
      );
    }
    if (data.containsKey('user_points')) {
      context.handle(
        _userPointsMeta,
        userPoints.isAcceptableOrUnknown(data['user_points']!, _userPointsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  UserdataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserdataData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      personalData:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}personal_data'],
          )!,
      goalsDetails:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goals_details'],
          )!,
      userLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}user_level'],
          )!,
      userPoints:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}user_points'],
          )!,
    );
  }

  @override
  $UserdataTable createAlias(String alias) {
    return $UserdataTable(attachedDatabase, alias);
  }
}

class UserdataData extends DataClass implements Insertable<UserdataData> {
  final int id;
  final String personalData;
  final String goalsDetails;
  final int userLevel;
  final int userPoints;
  const UserdataData({
    required this.id,
    required this.personalData,
    required this.goalsDetails,
    required this.userLevel,
    required this.userPoints,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['personal_data'] = Variable<String>(personalData);
    map['goals_details'] = Variable<String>(goalsDetails);
    map['user_level'] = Variable<int>(userLevel);
    map['user_points'] = Variable<int>(userPoints);
    return map;
  }

  UserdataCompanion toCompanion(bool nullToAbsent) {
    return UserdataCompanion(
      id: Value(id),
      personalData: Value(personalData),
      goalsDetails: Value(goalsDetails),
      userLevel: Value(userLevel),
      userPoints: Value(userPoints),
    );
  }

  factory UserdataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserdataData(
      id: serializer.fromJson<int>(json['id']),
      personalData: serializer.fromJson<String>(json['personalData']),
      goalsDetails: serializer.fromJson<String>(json['goalsDetails']),
      userLevel: serializer.fromJson<int>(json['userLevel']),
      userPoints: serializer.fromJson<int>(json['userPoints']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personalData': serializer.toJson<String>(personalData),
      'goalsDetails': serializer.toJson<String>(goalsDetails),
      'userLevel': serializer.toJson<int>(userLevel),
      'userPoints': serializer.toJson<int>(userPoints),
    };
  }

  UserdataData copyWith({
    int? id,
    String? personalData,
    String? goalsDetails,
    int? userLevel,
    int? userPoints,
  }) => UserdataData(
    id: id ?? this.id,
    personalData: personalData ?? this.personalData,
    goalsDetails: goalsDetails ?? this.goalsDetails,
    userLevel: userLevel ?? this.userLevel,
    userPoints: userPoints ?? this.userPoints,
  );
  UserdataData copyWithCompanion(UserdataCompanion data) {
    return UserdataData(
      id: data.id.present ? data.id.value : this.id,
      personalData:
          data.personalData.present
              ? data.personalData.value
              : this.personalData,
      goalsDetails:
          data.goalsDetails.present
              ? data.goalsDetails.value
              : this.goalsDetails,
      userLevel: data.userLevel.present ? data.userLevel.value : this.userLevel,
      userPoints:
          data.userPoints.present ? data.userPoints.value : this.userPoints,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserdataData(')
          ..write('id: $id, ')
          ..write('personalData: $personalData, ')
          ..write('goalsDetails: $goalsDetails, ')
          ..write('userLevel: $userLevel, ')
          ..write('userPoints: $userPoints')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personalData, goalsDetails, userLevel, userPoints);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserdataData &&
          other.id == this.id &&
          other.personalData == this.personalData &&
          other.goalsDetails == this.goalsDetails &&
          other.userLevel == this.userLevel &&
          other.userPoints == this.userPoints);
}

class UserdataCompanion extends UpdateCompanion<UserdataData> {
  final Value<int> id;
  final Value<String> personalData;
  final Value<String> goalsDetails;
  final Value<int> userLevel;
  final Value<int> userPoints;
  final Value<int> rowid;
  const UserdataCompanion({
    this.id = const Value.absent(),
    this.personalData = const Value.absent(),
    this.goalsDetails = const Value.absent(),
    this.userLevel = const Value.absent(),
    this.userPoints = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserdataCompanion.insert({
    required int id,
    required String personalData,
    required String goalsDetails,
    this.userLevel = const Value.absent(),
    this.userPoints = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personalData = Value(personalData),
       goalsDetails = Value(goalsDetails);
  static Insertable<UserdataData> custom({
    Expression<int>? id,
    Expression<String>? personalData,
    Expression<String>? goalsDetails,
    Expression<int>? userLevel,
    Expression<int>? userPoints,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personalData != null) 'personal_data': personalData,
      if (goalsDetails != null) 'goals_details': goalsDetails,
      if (userLevel != null) 'user_level': userLevel,
      if (userPoints != null) 'user_points': userPoints,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserdataCompanion copyWith({
    Value<int>? id,
    Value<String>? personalData,
    Value<String>? goalsDetails,
    Value<int>? userLevel,
    Value<int>? userPoints,
    Value<int>? rowid,
  }) {
    return UserdataCompanion(
      id: id ?? this.id,
      personalData: personalData ?? this.personalData,
      goalsDetails: goalsDetails ?? this.goalsDetails,
      userLevel: userLevel ?? this.userLevel,
      userPoints: userPoints ?? this.userPoints,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personalData.present) {
      map['personal_data'] = Variable<String>(personalData.value);
    }
    if (goalsDetails.present) {
      map['goals_details'] = Variable<String>(goalsDetails.value);
    }
    if (userLevel.present) {
      map['user_level'] = Variable<int>(userLevel.value);
    }
    if (userPoints.present) {
      map['user_points'] = Variable<int>(userPoints.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserdataCompanion(')
          ..write('id: $id, ')
          ..write('personalData: $personalData, ')
          ..write('goalsDetails: $goalsDetails, ')
          ..write('userLevel: $userLevel, ')
          ..write('userPoints: $userPoints, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserdailydataTable extends Userdailydata
    with TableInfo<$UserdailydataTable, UserdailydataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserdailydataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyDataMeta = const VerificationMeta(
    'dailyData',
  );
  @override
  late final GeneratedColumn<String> dailyData = GeneratedColumn<String>(
    'daily_data',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 1000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, dailyData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'userdailydata';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserdailydataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('daily_data')) {
      context.handle(
        _dailyDataMeta,
        dailyData.isAcceptableOrUnknown(data['daily_data']!, _dailyDataMeta),
      );
    } else if (isInserting) {
      context.missing(_dailyDataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserdailydataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserdailydataData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      dailyData:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}daily_data'],
          )!,
    );
  }

  @override
  $UserdailydataTable createAlias(String alias) {
    return $UserdailydataTable(attachedDatabase, alias);
  }
}

class UserdailydataData extends DataClass
    implements Insertable<UserdailydataData> {
  final int id;
  final DateTime date;
  final String dailyData;
  const UserdailydataData({
    required this.id,
    required this.date,
    required this.dailyData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['daily_data'] = Variable<String>(dailyData);
    return map;
  }

  UserdailydataCompanion toCompanion(bool nullToAbsent) {
    return UserdailydataCompanion(
      id: Value(id),
      date: Value(date),
      dailyData: Value(dailyData),
    );
  }

  factory UserdailydataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserdailydataData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      dailyData: serializer.fromJson<String>(json['dailyData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'dailyData': serializer.toJson<String>(dailyData),
    };
  }

  UserdailydataData copyWith({int? id, DateTime? date, String? dailyData}) =>
      UserdailydataData(
        id: id ?? this.id,
        date: date ?? this.date,
        dailyData: dailyData ?? this.dailyData,
      );
  UserdailydataData copyWithCompanion(UserdailydataCompanion data) {
    return UserdailydataData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      dailyData: data.dailyData.present ? data.dailyData.value : this.dailyData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserdailydataData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('dailyData: $dailyData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, dailyData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserdailydataData &&
          other.id == this.id &&
          other.date == this.date &&
          other.dailyData == this.dailyData);
}

class UserdailydataCompanion extends UpdateCompanion<UserdailydataData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> dailyData;
  const UserdailydataCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.dailyData = const Value.absent(),
  });
  UserdailydataCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String dailyData,
  }) : date = Value(date),
       dailyData = Value(dailyData);
  static Insertable<UserdailydataData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? dailyData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (dailyData != null) 'daily_data': dailyData,
    });
  }

  UserdailydataCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? dailyData,
  }) {
    return UserdailydataCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      dailyData: dailyData ?? this.dailyData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dailyData.present) {
      map['daily_data'] = Variable<String>(dailyData.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserdailydataCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('dailyData: $dailyData')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserdataTable userdata = $UserdataTable(this);
  late final $UserdailydataTable userdailydata = $UserdailydataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userdata, userdailydata];
}

typedef $$UserdataTableCreateCompanionBuilder =
    UserdataCompanion Function({
      required int id,
      required String personalData,
      required String goalsDetails,
      Value<int> userLevel,
      Value<int> userPoints,
      Value<int> rowid,
    });
typedef $$UserdataTableUpdateCompanionBuilder =
    UserdataCompanion Function({
      Value<int> id,
      Value<String> personalData,
      Value<String> goalsDetails,
      Value<int> userLevel,
      Value<int> userPoints,
      Value<int> rowid,
    });

class $$UserdataTableFilterComposer
    extends Composer<_$AppDatabase, $UserdataTable> {
  $$UserdataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalData => $composableBuilder(
    column: $table.personalData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalsDetails => $composableBuilder(
    column: $table.goalsDetails,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userLevel => $composableBuilder(
    column: $table.userLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userPoints => $composableBuilder(
    column: $table.userPoints,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserdataTableOrderingComposer
    extends Composer<_$AppDatabase, $UserdataTable> {
  $$UserdataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalData => $composableBuilder(
    column: $table.personalData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalsDetails => $composableBuilder(
    column: $table.goalsDetails,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userLevel => $composableBuilder(
    column: $table.userLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userPoints => $composableBuilder(
    column: $table.userPoints,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserdataTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserdataTable> {
  $$UserdataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get personalData => $composableBuilder(
    column: $table.personalData,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalsDetails => $composableBuilder(
    column: $table.goalsDetails,
    builder: (column) => column,
  );

  GeneratedColumn<int> get userLevel =>
      $composableBuilder(column: $table.userLevel, builder: (column) => column);

  GeneratedColumn<int> get userPoints => $composableBuilder(
    column: $table.userPoints,
    builder: (column) => column,
  );
}

class $$UserdataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserdataTable,
          UserdataData,
          $$UserdataTableFilterComposer,
          $$UserdataTableOrderingComposer,
          $$UserdataTableAnnotationComposer,
          $$UserdataTableCreateCompanionBuilder,
          $$UserdataTableUpdateCompanionBuilder,
          (
            UserdataData,
            BaseReferences<_$AppDatabase, $UserdataTable, UserdataData>,
          ),
          UserdataData,
          PrefetchHooks Function()
        > {
  $$UserdataTableTableManager(_$AppDatabase db, $UserdataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserdataTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserdataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UserdataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> personalData = const Value.absent(),
                Value<String> goalsDetails = const Value.absent(),
                Value<int> userLevel = const Value.absent(),
                Value<int> userPoints = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserdataCompanion(
                id: id,
                personalData: personalData,
                goalsDetails: goalsDetails,
                userLevel: userLevel,
                userPoints: userPoints,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String personalData,
                required String goalsDetails,
                Value<int> userLevel = const Value.absent(),
                Value<int> userPoints = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserdataCompanion.insert(
                id: id,
                personalData: personalData,
                goalsDetails: goalsDetails,
                userLevel: userLevel,
                userPoints: userPoints,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserdataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserdataTable,
      UserdataData,
      $$UserdataTableFilterComposer,
      $$UserdataTableOrderingComposer,
      $$UserdataTableAnnotationComposer,
      $$UserdataTableCreateCompanionBuilder,
      $$UserdataTableUpdateCompanionBuilder,
      (
        UserdataData,
        BaseReferences<_$AppDatabase, $UserdataTable, UserdataData>,
      ),
      UserdataData,
      PrefetchHooks Function()
    >;
typedef $$UserdailydataTableCreateCompanionBuilder =
    UserdailydataCompanion Function({
      Value<int> id,
      required DateTime date,
      required String dailyData,
    });
typedef $$UserdailydataTableUpdateCompanionBuilder =
    UserdailydataCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> dailyData,
    });

class $$UserdailydataTableFilterComposer
    extends Composer<_$AppDatabase, $UserdailydataTable> {
  $$UserdailydataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dailyData => $composableBuilder(
    column: $table.dailyData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserdailydataTableOrderingComposer
    extends Composer<_$AppDatabase, $UserdailydataTable> {
  $$UserdailydataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyData => $composableBuilder(
    column: $table.dailyData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserdailydataTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserdailydataTable> {
  $$UserdailydataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get dailyData =>
      $composableBuilder(column: $table.dailyData, builder: (column) => column);
}

class $$UserdailydataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserdailydataTable,
          UserdailydataData,
          $$UserdailydataTableFilterComposer,
          $$UserdailydataTableOrderingComposer,
          $$UserdailydataTableAnnotationComposer,
          $$UserdailydataTableCreateCompanionBuilder,
          $$UserdailydataTableUpdateCompanionBuilder,
          (
            UserdailydataData,
            BaseReferences<
              _$AppDatabase,
              $UserdailydataTable,
              UserdailydataData
            >,
          ),
          UserdailydataData,
          PrefetchHooks Function()
        > {
  $$UserdailydataTableTableManager(_$AppDatabase db, $UserdailydataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserdailydataTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$UserdailydataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UserdailydataTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> dailyData = const Value.absent(),
              }) => UserdailydataCompanion(
                id: id,
                date: date,
                dailyData: dailyData,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String dailyData,
              }) => UserdailydataCompanion.insert(
                id: id,
                date: date,
                dailyData: dailyData,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserdailydataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserdailydataTable,
      UserdailydataData,
      $$UserdailydataTableFilterComposer,
      $$UserdailydataTableOrderingComposer,
      $$UserdailydataTableAnnotationComposer,
      $$UserdailydataTableCreateCompanionBuilder,
      $$UserdailydataTableUpdateCompanionBuilder,
      (
        UserdailydataData,
        BaseReferences<_$AppDatabase, $UserdailydataTable, UserdailydataData>,
      ),
      UserdailydataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserdataTableTableManager get userdata =>
      $$UserdataTableTableManager(_db, _db.userdata);
  $$UserdailydataTableTableManager get userdailydata =>
      $$UserdailydataTableTableManager(_db, _db.userdailydata);
}
