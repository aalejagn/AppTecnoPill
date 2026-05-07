import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// final db = AppDatabase();

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
  TextColumn get dosis => text()(); // nuevo

  TextColumn get pacienteNombre => text()();

  IntColumn get casillero => integer()();

  IntColumn get horaProxima => integer()();
  IntColumn get minutoProxima => integer()();

  IntColumn get intervaloMinutos => integer()();
  IntColumn get tomasRestantes => integer()();
  IntColumn get tomadas => integer().withDefault(const Constant(0))();
  IntColumn get omitidas => integer().withDefault(const Constant(0))();

  DateTimeColumn get ultimaOmitida => dateTime().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
}

@DriftDatabase(tables: [Patients, Schedules])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4; // ← Cambiado de 1 a 2

  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(schedules, schedules.dosis);
          print("✅ Columna 'dosis' agregada");
        }

        if (from < 3) {
          await m.addColumn(schedules, schedules.tomadas);
          await m.addColumn(schedules, schedules.omitidas);
          print("✅ Columnas 'tomadas' y 'omitidas' agregadas");
        }

        if (from < 4) {
          await m.addColumn(schedules, schedules.ultimaOmitida);
          print("✅ Columna 'ultimaOmitida' agregada");
        }
      },
    );
  }

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

  Future actualizarTomaDesdeESP32(int casillero, bool tomada) async {
    final schedule = await (select(
      schedules,
    )..where((t) => t.casillero.equals(casillero))).getSingleOrNull();

    if (schedule == null) return;

    int nuevasTomadas = schedule.tomadas;
    int nuevasOmitidas = schedule.omitidas;
    int nuevasRestantes = schedule.tomasRestantes;
    DateTime? nuevaUltimaOmitida = schedule.ultimaOmitida;

    if (tomada) {
      nuevasTomadas++;
      nuevaUltimaOmitida = null; //
    } else {
      nuevasOmitidas++;
      nuevaUltimaOmitida = DateTime.now();
    }

    if (nuevasRestantes > 0) {
      nuevasRestantes--;
    }

    await (update(schedules)..where((t) => t.id.equals(schedule.id))).write(
      SchedulesCompanion(
        tomadas: Value(nuevasTomadas),
        omitidas: Value(nuevasOmitidas),
        tomasRestantes: Value(nuevasRestantes),
        ultimaOmitida: Value(nuevaUltimaOmitida),
      ),
    );
  }

  Future confirmarTomaManual(int casillero) async {
    final schedule = await (select(
      schedules,
    )..where((t) => t.casillero.equals(casillero))).getSingleOrNull();

    if (schedule == null) return;

    // 🔍 Validar tiempo (ej: máximo 2 horas después)
    final ahora = DateTime.now();

    if (schedule.ultimaOmitida == null) return;

    final diferencia = ahora.difference(schedule.ultimaOmitida!).inMinutes;

    if (diferencia > 120) {
      print("⛔ Ya pasó mucho tiempo para corregir");
      return;
    }

    int nuevasTomadas = schedule.tomadas + 1;
    int nuevasOmitidas = schedule.omitidas > 0 ? schedule.omitidas - 1 : 0;

    await (update(schedules)..where((t) => t.id.equals(schedule.id))).write(
      SchedulesCompanion(
        tomadas: Value(nuevasTomadas),
        omitidas: Value(nuevasOmitidas),
        ultimaOmitida: const Value(null), // 🔥 limpiamos
      ),
    );
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
