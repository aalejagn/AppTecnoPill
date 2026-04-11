import 'package:isar/isar.dart';

part 'patient.g.dart';

@collection
class Patient {
  Id id = Isar.autoIncrement;

  late String nombre;
  late String apellidoPaterno;
  late String apellidoMaterno;

  // Usamos DateTime para la fecha de nacimiento
  late DateTime fechaNacimiento;

  // Campo opcional por si quieres guardar contacto o notas
  String? telefono;

  // Un getter útil para obtener el nombre completo sin esfuerzo
  String get nombreCompleto => '$nombre $apellidoPaterno $apellidoMaterno';

  // Getter para calcular la edad automáticamente
  int get edad {
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }
}
