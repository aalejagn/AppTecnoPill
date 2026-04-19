import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

final db = AppDatabase();

// 🟢 TABLA PACIENTES
class Patients extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nombre => text()();
  TextColumn get apellidoPaterno => text()();
  TextColumn get apellidoMaterno => text()();

  DateTimeColumn get fechaNacimiento => dateTime()();

  TextColumn get telefono => text().nullable()();
}

// 🟣 TABLA SCHEDULES
class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get medicamento => text()();
  TextColumn get pacienteNombre => text()();

  IntColumn get casillero => integer()();

  IntColumn get horaProxima => integer()();
  IntColumn get minutoProxima => integer()();

  IntColumn get intervaloMinutos => integer()();
  IntColumn get tomasRestantes => integer()();

  DateTimeColumn get fechaCreacion => dateTime()();
}

@DriftDatabase(tables: [Patients, Schedules])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // =========================
  // 📌 PACIENTES
  // =========================

  Future<List<Patient>> getAllPatients() {
    return select(patients).get();
  }

  Future<int> insertPatient(PatientsCompanion data) {
    return into(patients).insert(data);
  }

  Future deletePatient(int id) {
    return (delete(patients)..where((t) => t.id.equals(id))).go();
  }

  Future updatePatient(int id, PatientsCompanion data) {
    return (update(patients)..where((t) => t.id.equals(id))).write(data);
  }

  // =========================
  // 📌 SCHEDULES
  // =========================

  Future<List<Schedule>> getAllSchedules() {
    return select(schedules).get();
  }

  Future<int> insertSchedule(SchedulesCompanion data) {
    return into(schedules).insert(data);
  }

  Future deleteSchedule(int id) {
    return (delete(schedules)..where((t) => t.id.equals(id))).go();
  }

  Future updateSchedule(int id, SchedulesCompanion data) {
    return (update(schedules)..where((t) => t.id.equals(id))).write(data);
  }

  Future<Schedule?> getScheduleByCasillero(int casillero) {
    return (select(
      schedules,
    )..where((t) => t.casillero.equals(casillero))).getSingleOrNull();
  }

  Future<Schedule?> getScheduleById(int id) {
    return (select(schedules)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}

// 🔌 CONEXIÓN SQLITE
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
