import 'package:isar/isar.dart';

part 'schedule.g.dart';

@collection
class Schedule {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int? casillero; //1 al 2

  late String medicamento;
  late int horaProxima; // 0-23
  late int minutoProxima; // 0-59
  late int intervaloMinutos;
  late int tomasRestantes;
  late DateTime fechaCreacion;
}
