import 'package:isar/isar.dart';

part 'schedule.g.dart';

@collection
class Schedule {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int? casillero;

  late String medicamento;
  String? pacienteNombre; // <--- Nuevo campo para el nombre del paciente
  late int horaProxima;
  late int minutoProxima;
  late int intervaloMinutos;
  late int tomasRestantes;
  late DateTime fechaCreacion;
}
