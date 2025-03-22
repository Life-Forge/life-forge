import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;


part 'app_database.g.dart';

class Userdata extends Table {
  IntColumn get id => integer()();//integer().autoIncrement()();
  TextColumn get personalData => text().withLength(min: 1, max: 500)();
  TextColumn get goalsDetails => text().withLength(min: 1, max: 5000)();
  IntColumn get userLevel => integer().withDefault(Constant(1))();
  IntColumn get userPoints => integer().withDefault(Constant(0))();
}

class Userdailydata extends Table {
  IntColumn get id => integer().autoIncrement()();
  //IntColumn get userId => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get dailyData => text().withLength(min: 1, max: 1000)();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Userdata, Userdailydata])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertUser(UserdataCompanion user) {
    return into(userdata).insert(user);  // ✅ Fixed `userdatas` → `userdata`
  }

  Future<List<UserdataData>> getAllUserData() {
    return select(userdata).get();  // ✅ Fixed return type `UserdataData`
  }

  Future<List<UserdailydataData>> getAllUserDailyData() {
    return select(userdailydata).get();  // ✅ Fixed return type `UserdailydataData`
  }

  Future<void> updateUserData(List<dynamic> newData) {
    return (update(userdata)..where((tbl) => tbl.id.equals(newData[0])))
        .write(UserdataCompanion(
      personalData: Value(newData[1]),
      goalsDetails: Value(newData[2]),
      userLevel: Value(newData[3]),
      userPoints: Value(newData[4]),
    ));
  }

  Future<void> insertUserDailyData(UserdailydataCompanion userDailyData) async {
    into(userdailydata).insert(userDailyData);    
  }

    //@override
  /*MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          if (details.wasCreated) {
            // Runs only when the DB is first created
            print("Database created!");
          } else {
            // Clear all data every time app starts
            await customStatement('DELETE FROM Userdata');
          }
        },
      );*/
}
