// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$PatientsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
@override
late final GeneratedColumn<String> nombre = GeneratedColumn<String>('nombre', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _apellidoPaternoMeta = const VerificationMeta('apellidoPaterno');
@override
late final GeneratedColumn<String> apellidoPaterno = GeneratedColumn<String>('apellido_paterno', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _apellidoMaternoMeta = const VerificationMeta('apellidoMaterno');
@override
late final GeneratedColumn<String> apellidoMaterno = GeneratedColumn<String>('apellido_materno', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _fechaNacimientoMeta = const VerificationMeta('fechaNacimiento');
@override
late final GeneratedColumn<DateTime> fechaNacimiento = GeneratedColumn<DateTime>('fecha_nacimiento', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _telefonoMeta = const VerificationMeta('telefono');
@override
late final GeneratedColumn<String> telefono = GeneratedColumn<String>('telefono', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
@override
List<GeneratedColumn> get $columns => [id, nombre, apellidoPaterno, apellidoMaterno, fechaNacimiento, telefono];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'patients';
@override
VerificationContext validateIntegrity(Insertable<Patient> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('nombre')) {
context.handle(_nombreMeta, nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));} else if (isInserting) {
context.missing(_nombreMeta);
}
if (data.containsKey('apellido_paterno')) {
context.handle(_apellidoPaternoMeta, apellidoPaterno.isAcceptableOrUnknown(data['apellido_paterno']!, _apellidoPaternoMeta));} else if (isInserting) {
context.missing(_apellidoPaternoMeta);
}
if (data.containsKey('apellido_materno')) {
context.handle(_apellidoMaternoMeta, apellidoMaterno.isAcceptableOrUnknown(data['apellido_materno']!, _apellidoMaternoMeta));} else if (isInserting) {
context.missing(_apellidoMaternoMeta);
}
if (data.containsKey('fecha_nacimiento')) {
context.handle(_fechaNacimientoMeta, fechaNacimiento.isAcceptableOrUnknown(data['fecha_nacimiento']!, _fechaNacimientoMeta));} else if (isInserting) {
context.missing(_fechaNacimientoMeta);
}
if (data.containsKey('telefono')) {
context.handle(_telefonoMeta, telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Patient map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Patient(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, nombre: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nombre'])!, apellidoPaterno: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}apellido_paterno'])!, apellidoMaterno: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}apellido_materno'])!, fechaNacimiento: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_nacimiento'])!, telefono: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}telefono']), );
}
@override
$PatientsTable createAlias(String alias) {
return $PatientsTable(attachedDatabase, alias);}}class Patient extends DataClass implements Insertable<Patient> 
{
final int id;
final String nombre;
final String apellidoPaterno;
final String apellidoMaterno;
final DateTime fechaNacimiento;
final String? telefono;
const Patient({required this.id, required this.nombre, required this.apellidoPaterno, required this.apellidoMaterno, required this.fechaNacimiento, this.telefono});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['nombre'] = Variable<String>(nombre);
map['apellido_paterno'] = Variable<String>(apellidoPaterno);
map['apellido_materno'] = Variable<String>(apellidoMaterno);
map['fecha_nacimiento'] = Variable<DateTime>(fechaNacimiento);
if (!nullToAbsent || telefono != null){map['telefono'] = Variable<String>(telefono);
}return map; 
}
PatientsCompanion toCompanion(bool nullToAbsent) {
return PatientsCompanion(id: Value(id),nombre: Value(nombre),apellidoPaterno: Value(apellidoPaterno),apellidoMaterno: Value(apellidoMaterno),fechaNacimiento: Value(fechaNacimiento),telefono: telefono == null && nullToAbsent ? const Value.absent() : Value(telefono),);
}
factory Patient.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Patient(id: serializer.fromJson<int>(json['id']),nombre: serializer.fromJson<String>(json['nombre']),apellidoPaterno: serializer.fromJson<String>(json['apellidoPaterno']),apellidoMaterno: serializer.fromJson<String>(json['apellidoMaterno']),fechaNacimiento: serializer.fromJson<DateTime>(json['fechaNacimiento']),telefono: serializer.fromJson<String?>(json['telefono']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'nombre': serializer.toJson<String>(nombre),'apellidoPaterno': serializer.toJson<String>(apellidoPaterno),'apellidoMaterno': serializer.toJson<String>(apellidoMaterno),'fechaNacimiento': serializer.toJson<DateTime>(fechaNacimiento),'telefono': serializer.toJson<String?>(telefono),};}Patient copyWith({int? id,String? nombre,String? apellidoPaterno,String? apellidoMaterno,DateTime? fechaNacimiento,Value<String?> telefono = const Value.absent()}) => Patient(id: id ?? this.id,nombre: nombre ?? this.nombre,apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,telefono: telefono.present ? telefono.value : this.telefono,);Patient copyWithCompanion(PatientsCompanion data) {
return Patient(
id: data.id.present ? data.id.value : this.id,nombre: data.nombre.present ? data.nombre.value : this.nombre,apellidoPaterno: data.apellidoPaterno.present ? data.apellidoPaterno.value : this.apellidoPaterno,apellidoMaterno: data.apellidoMaterno.present ? data.apellidoMaterno.value : this.apellidoMaterno,fechaNacimiento: data.fechaNacimiento.present ? data.fechaNacimiento.value : this.fechaNacimiento,telefono: data.telefono.present ? data.telefono.value : this.telefono,);
}
@override
String toString() {return (StringBuffer('Patient(')..write('id: $id, ')..write('nombre: $nombre, ')..write('apellidoPaterno: $apellidoPaterno, ')..write('apellidoMaterno: $apellidoMaterno, ')..write('fechaNacimiento: $fechaNacimiento, ')..write('telefono: $telefono')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, nombre, apellidoPaterno, apellidoMaterno, fechaNacimiento, telefono);@override
bool operator ==(Object other) => identical(this, other) || (other is Patient && other.id == this.id && other.nombre == this.nombre && other.apellidoPaterno == this.apellidoPaterno && other.apellidoMaterno == this.apellidoMaterno && other.fechaNacimiento == this.fechaNacimiento && other.telefono == this.telefono);
}class PatientsCompanion extends UpdateCompanion<Patient> {
final Value<int> id;
final Value<String> nombre;
final Value<String> apellidoPaterno;
final Value<String> apellidoMaterno;
final Value<DateTime> fechaNacimiento;
final Value<String?> telefono;
const PatientsCompanion({this.id = const Value.absent(),this.nombre = const Value.absent(),this.apellidoPaterno = const Value.absent(),this.apellidoMaterno = const Value.absent(),this.fechaNacimiento = const Value.absent(),this.telefono = const Value.absent(),});
PatientsCompanion.insert({this.id = const Value.absent(),required String nombre,required String apellidoPaterno,required String apellidoMaterno,required DateTime fechaNacimiento,this.telefono = const Value.absent(),}): nombre = Value(nombre), apellidoPaterno = Value(apellidoPaterno), apellidoMaterno = Value(apellidoMaterno), fechaNacimiento = Value(fechaNacimiento);
static Insertable<Patient> custom({Expression<int>? id, 
Expression<String>? nombre, 
Expression<String>? apellidoPaterno, 
Expression<String>? apellidoMaterno, 
Expression<DateTime>? fechaNacimiento, 
Expression<String>? telefono, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (nombre != null)'nombre': nombre,if (apellidoPaterno != null)'apellido_paterno': apellidoPaterno,if (apellidoMaterno != null)'apellido_materno': apellidoMaterno,if (fechaNacimiento != null)'fecha_nacimiento': fechaNacimiento,if (telefono != null)'telefono': telefono,});
}PatientsCompanion copyWith({Value<int>? id, Value<String>? nombre, Value<String>? apellidoPaterno, Value<String>? apellidoMaterno, Value<DateTime>? fechaNacimiento, Value<String?>? telefono}) {
return PatientsCompanion(id: id ?? this.id,nombre: nombre ?? this.nombre,apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,telefono: telefono ?? this.telefono,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (nombre.present) {
map['nombre'] = Variable<String>(nombre.value);}
if (apellidoPaterno.present) {
map['apellido_paterno'] = Variable<String>(apellidoPaterno.value);}
if (apellidoMaterno.present) {
map['apellido_materno'] = Variable<String>(apellidoMaterno.value);}
if (fechaNacimiento.present) {
map['fecha_nacimiento'] = Variable<DateTime>(fechaNacimiento.value);}
if (telefono.present) {
map['telefono'] = Variable<String>(telefono.value);}
return map; 
}
@override
String toString() {return (StringBuffer('PatientsCompanion(')..write('id: $id, ')..write('nombre: $nombre, ')..write('apellidoPaterno: $apellidoPaterno, ')..write('apellidoMaterno: $apellidoMaterno, ')..write('fechaNacimiento: $fechaNacimiento, ')..write('telefono: $telefono')..write(')')).toString();}
}
class $SchedulesTable extends Schedules with TableInfo<$SchedulesTable, Schedule>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$SchedulesTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _medicamentoMeta = const VerificationMeta('medicamento');
@override
late final GeneratedColumn<String> medicamento = GeneratedColumn<String>('medicamento', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _pacienteNombreMeta = const VerificationMeta('pacienteNombre');
@override
late final GeneratedColumn<String> pacienteNombre = GeneratedColumn<String>('paciente_nombre', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _casilleroMeta = const VerificationMeta('casillero');
@override
late final GeneratedColumn<int> casillero = GeneratedColumn<int>('casillero', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _horaProximaMeta = const VerificationMeta('horaProxima');
@override
late final GeneratedColumn<int> horaProxima = GeneratedColumn<int>('hora_proxima', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _minutoProximaMeta = const VerificationMeta('minutoProxima');
@override
late final GeneratedColumn<int> minutoProxima = GeneratedColumn<int>('minuto_proxima', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _intervaloMinutosMeta = const VerificationMeta('intervaloMinutos');
@override
late final GeneratedColumn<int> intervaloMinutos = GeneratedColumn<int>('intervalo_minutos', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _tomasRestantesMeta = const VerificationMeta('tomasRestantes');
@override
late final GeneratedColumn<int> tomasRestantes = GeneratedColumn<int>('tomas_restantes', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _fechaCreacionMeta = const VerificationMeta('fechaCreacion');
@override
late final GeneratedColumn<DateTime> fechaCreacion = GeneratedColumn<DateTime>('fecha_creacion', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [id, medicamento, pacienteNombre, casillero, horaProxima, minutoProxima, intervaloMinutos, tomasRestantes, fechaCreacion];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'schedules';
@override
VerificationContext validateIntegrity(Insertable<Schedule> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('medicamento')) {
context.handle(_medicamentoMeta, medicamento.isAcceptableOrUnknown(data['medicamento']!, _medicamentoMeta));} else if (isInserting) {
context.missing(_medicamentoMeta);
}
if (data.containsKey('paciente_nombre')) {
context.handle(_pacienteNombreMeta, pacienteNombre.isAcceptableOrUnknown(data['paciente_nombre']!, _pacienteNombreMeta));} else if (isInserting) {
context.missing(_pacienteNombreMeta);
}
if (data.containsKey('casillero')) {
context.handle(_casilleroMeta, casillero.isAcceptableOrUnknown(data['casillero']!, _casilleroMeta));} else if (isInserting) {
context.missing(_casilleroMeta);
}
if (data.containsKey('hora_proxima')) {
context.handle(_horaProximaMeta, horaProxima.isAcceptableOrUnknown(data['hora_proxima']!, _horaProximaMeta));} else if (isInserting) {
context.missing(_horaProximaMeta);
}
if (data.containsKey('minuto_proxima')) {
context.handle(_minutoProximaMeta, minutoProxima.isAcceptableOrUnknown(data['minuto_proxima']!, _minutoProximaMeta));} else if (isInserting) {
context.missing(_minutoProximaMeta);
}
if (data.containsKey('intervalo_minutos')) {
context.handle(_intervaloMinutosMeta, intervaloMinutos.isAcceptableOrUnknown(data['intervalo_minutos']!, _intervaloMinutosMeta));} else if (isInserting) {
context.missing(_intervaloMinutosMeta);
}
if (data.containsKey('tomas_restantes')) {
context.handle(_tomasRestantesMeta, tomasRestantes.isAcceptableOrUnknown(data['tomas_restantes']!, _tomasRestantesMeta));} else if (isInserting) {
context.missing(_tomasRestantesMeta);
}
if (data.containsKey('fecha_creacion')) {
context.handle(_fechaCreacionMeta, fechaCreacion.isAcceptableOrUnknown(data['fecha_creacion']!, _fechaCreacionMeta));} else if (isInserting) {
context.missing(_fechaCreacionMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Schedule map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Schedule(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, medicamento: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}medicamento'])!, pacienteNombre: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}paciente_nombre'])!, casillero: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}casillero'])!, horaProxima: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}hora_proxima'])!, minutoProxima: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}minuto_proxima'])!, intervaloMinutos: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}intervalo_minutos'])!, tomasRestantes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}tomas_restantes'])!, fechaCreacion: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_creacion'])!, );
}
@override
$SchedulesTable createAlias(String alias) {
return $SchedulesTable(attachedDatabase, alias);}}class Schedule extends DataClass implements Insertable<Schedule> 
{
final int id;
final String medicamento;
final String pacienteNombre;
final int casillero;
final int horaProxima;
final int minutoProxima;
final int intervaloMinutos;
final int tomasRestantes;
final DateTime fechaCreacion;
const Schedule({required this.id, required this.medicamento, required this.pacienteNombre, required this.casillero, required this.horaProxima, required this.minutoProxima, required this.intervaloMinutos, required this.tomasRestantes, required this.fechaCreacion});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['medicamento'] = Variable<String>(medicamento);
map['paciente_nombre'] = Variable<String>(pacienteNombre);
map['casillero'] = Variable<int>(casillero);
map['hora_proxima'] = Variable<int>(horaProxima);
map['minuto_proxima'] = Variable<int>(minutoProxima);
map['intervalo_minutos'] = Variable<int>(intervaloMinutos);
map['tomas_restantes'] = Variable<int>(tomasRestantes);
map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
return map; 
}
SchedulesCompanion toCompanion(bool nullToAbsent) {
return SchedulesCompanion(id: Value(id),medicamento: Value(medicamento),pacienteNombre: Value(pacienteNombre),casillero: Value(casillero),horaProxima: Value(horaProxima),minutoProxima: Value(minutoProxima),intervaloMinutos: Value(intervaloMinutos),tomasRestantes: Value(tomasRestantes),fechaCreacion: Value(fechaCreacion),);
}
factory Schedule.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Schedule(id: serializer.fromJson<int>(json['id']),medicamento: serializer.fromJson<String>(json['medicamento']),pacienteNombre: serializer.fromJson<String>(json['pacienteNombre']),casillero: serializer.fromJson<int>(json['casillero']),horaProxima: serializer.fromJson<int>(json['horaProxima']),minutoProxima: serializer.fromJson<int>(json['minutoProxima']),intervaloMinutos: serializer.fromJson<int>(json['intervaloMinutos']),tomasRestantes: serializer.fromJson<int>(json['tomasRestantes']),fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'medicamento': serializer.toJson<String>(medicamento),'pacienteNombre': serializer.toJson<String>(pacienteNombre),'casillero': serializer.toJson<int>(casillero),'horaProxima': serializer.toJson<int>(horaProxima),'minutoProxima': serializer.toJson<int>(minutoProxima),'intervaloMinutos': serializer.toJson<int>(intervaloMinutos),'tomasRestantes': serializer.toJson<int>(tomasRestantes),'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),};}Schedule copyWith({int? id,String? medicamento,String? pacienteNombre,int? casillero,int? horaProxima,int? minutoProxima,int? intervaloMinutos,int? tomasRestantes,DateTime? fechaCreacion}) => Schedule(id: id ?? this.id,medicamento: medicamento ?? this.medicamento,pacienteNombre: pacienteNombre ?? this.pacienteNombre,casillero: casillero ?? this.casillero,horaProxima: horaProxima ?? this.horaProxima,minutoProxima: minutoProxima ?? this.minutoProxima,intervaloMinutos: intervaloMinutos ?? this.intervaloMinutos,tomasRestantes: tomasRestantes ?? this.tomasRestantes,fechaCreacion: fechaCreacion ?? this.fechaCreacion,);Schedule copyWithCompanion(SchedulesCompanion data) {
return Schedule(
id: data.id.present ? data.id.value : this.id,medicamento: data.medicamento.present ? data.medicamento.value : this.medicamento,pacienteNombre: data.pacienteNombre.present ? data.pacienteNombre.value : this.pacienteNombre,casillero: data.casillero.present ? data.casillero.value : this.casillero,horaProxima: data.horaProxima.present ? data.horaProxima.value : this.horaProxima,minutoProxima: data.minutoProxima.present ? data.minutoProxima.value : this.minutoProxima,intervaloMinutos: data.intervaloMinutos.present ? data.intervaloMinutos.value : this.intervaloMinutos,tomasRestantes: data.tomasRestantes.present ? data.tomasRestantes.value : this.tomasRestantes,fechaCreacion: data.fechaCreacion.present ? data.fechaCreacion.value : this.fechaCreacion,);
}
@override
String toString() {return (StringBuffer('Schedule(')..write('id: $id, ')..write('medicamento: $medicamento, ')..write('pacienteNombre: $pacienteNombre, ')..write('casillero: $casillero, ')..write('horaProxima: $horaProxima, ')..write('minutoProxima: $minutoProxima, ')..write('intervaloMinutos: $intervaloMinutos, ')..write('tomasRestantes: $tomasRestantes, ')..write('fechaCreacion: $fechaCreacion')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, medicamento, pacienteNombre, casillero, horaProxima, minutoProxima, intervaloMinutos, tomasRestantes, fechaCreacion);@override
bool operator ==(Object other) => identical(this, other) || (other is Schedule && other.id == this.id && other.medicamento == this.medicamento && other.pacienteNombre == this.pacienteNombre && other.casillero == this.casillero && other.horaProxima == this.horaProxima && other.minutoProxima == this.minutoProxima && other.intervaloMinutos == this.intervaloMinutos && other.tomasRestantes == this.tomasRestantes && other.fechaCreacion == this.fechaCreacion);
}class SchedulesCompanion extends UpdateCompanion<Schedule> {
final Value<int> id;
final Value<String> medicamento;
final Value<String> pacienteNombre;
final Value<int> casillero;
final Value<int> horaProxima;
final Value<int> minutoProxima;
final Value<int> intervaloMinutos;
final Value<int> tomasRestantes;
final Value<DateTime> fechaCreacion;
const SchedulesCompanion({this.id = const Value.absent(),this.medicamento = const Value.absent(),this.pacienteNombre = const Value.absent(),this.casillero = const Value.absent(),this.horaProxima = const Value.absent(),this.minutoProxima = const Value.absent(),this.intervaloMinutos = const Value.absent(),this.tomasRestantes = const Value.absent(),this.fechaCreacion = const Value.absent(),});
SchedulesCompanion.insert({this.id = const Value.absent(),required String medicamento,required String pacienteNombre,required int casillero,required int horaProxima,required int minutoProxima,required int intervaloMinutos,required int tomasRestantes,required DateTime fechaCreacion,}): medicamento = Value(medicamento), pacienteNombre = Value(pacienteNombre), casillero = Value(casillero), horaProxima = Value(horaProxima), minutoProxima = Value(minutoProxima), intervaloMinutos = Value(intervaloMinutos), tomasRestantes = Value(tomasRestantes), fechaCreacion = Value(fechaCreacion);
static Insertable<Schedule> custom({Expression<int>? id, 
Expression<String>? medicamento, 
Expression<String>? pacienteNombre, 
Expression<int>? casillero, 
Expression<int>? horaProxima, 
Expression<int>? minutoProxima, 
Expression<int>? intervaloMinutos, 
Expression<int>? tomasRestantes, 
Expression<DateTime>? fechaCreacion, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (medicamento != null)'medicamento': medicamento,if (pacienteNombre != null)'paciente_nombre': pacienteNombre,if (casillero != null)'casillero': casillero,if (horaProxima != null)'hora_proxima': horaProxima,if (minutoProxima != null)'minuto_proxima': minutoProxima,if (intervaloMinutos != null)'intervalo_minutos': intervaloMinutos,if (tomasRestantes != null)'tomas_restantes': tomasRestantes,if (fechaCreacion != null)'fecha_creacion': fechaCreacion,});
}SchedulesCompanion copyWith({Value<int>? id, Value<String>? medicamento, Value<String>? pacienteNombre, Value<int>? casillero, Value<int>? horaProxima, Value<int>? minutoProxima, Value<int>? intervaloMinutos, Value<int>? tomasRestantes, Value<DateTime>? fechaCreacion}) {
return SchedulesCompanion(id: id ?? this.id,medicamento: medicamento ?? this.medicamento,pacienteNombre: pacienteNombre ?? this.pacienteNombre,casillero: casillero ?? this.casillero,horaProxima: horaProxima ?? this.horaProxima,minutoProxima: minutoProxima ?? this.minutoProxima,intervaloMinutos: intervaloMinutos ?? this.intervaloMinutos,tomasRestantes: tomasRestantes ?? this.tomasRestantes,fechaCreacion: fechaCreacion ?? this.fechaCreacion,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (medicamento.present) {
map['medicamento'] = Variable<String>(medicamento.value);}
if (pacienteNombre.present) {
map['paciente_nombre'] = Variable<String>(pacienteNombre.value);}
if (casillero.present) {
map['casillero'] = Variable<int>(casillero.value);}
if (horaProxima.present) {
map['hora_proxima'] = Variable<int>(horaProxima.value);}
if (minutoProxima.present) {
map['minuto_proxima'] = Variable<int>(minutoProxima.value);}
if (intervaloMinutos.present) {
map['intervalo_minutos'] = Variable<int>(intervaloMinutos.value);}
if (tomasRestantes.present) {
map['tomas_restantes'] = Variable<int>(tomasRestantes.value);}
if (fechaCreacion.present) {
map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);}
return map; 
}
@override
String toString() {return (StringBuffer('SchedulesCompanion(')..write('id: $id, ')..write('medicamento: $medicamento, ')..write('pacienteNombre: $pacienteNombre, ')..write('casillero: $casillero, ')..write('horaProxima: $horaProxima, ')..write('minutoProxima: $minutoProxima, ')..write('intervaloMinutos: $intervaloMinutos, ')..write('tomasRestantes: $tomasRestantes, ')..write('fechaCreacion: $fechaCreacion')..write(')')).toString();}
}
abstract class _$AppDatabase extends GeneratedDatabase{
_$AppDatabase(QueryExecutor e): super(e);
$AppDatabaseManager get managers => $AppDatabaseManager(this);
late final $PatientsTable patients = $PatientsTable(this);
late final $SchedulesTable schedules = $SchedulesTable(this);
@override
Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
@override
List<DatabaseSchemaEntity> get allSchemaEntities => [patients, schedules];
}
typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({Value<int> id,required String nombre,required String apellidoPaterno,required String apellidoMaterno,required DateTime fechaNacimiento,Value<String?> telefono,});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({Value<int> id,Value<String> nombre,Value<String> apellidoPaterno,Value<String> apellidoMaterno,Value<DateTime> fechaNacimiento,Value<String?> telefono,});
class $$PatientsTableFilterComposer extends Composer<
        _$AppDatabase,
        $PatientsTable> {
        $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get apellidoPaterno => $composableBuilder(
      column: $table.apellidoPaterno,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get apellidoMaterno => $composableBuilder(
      column: $table.apellidoMaterno,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get fechaNacimiento => $composableBuilder(
      column: $table.fechaNacimiento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$PatientsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $PatientsTable> {
        $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get apellidoPaterno => $composableBuilder(
      column: $table.apellidoPaterno,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get apellidoMaterno => $composableBuilder(
      column: $table.apellidoMaterno,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get fechaNacimiento => $composableBuilder(
      column: $table.fechaNacimiento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$PatientsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $PatientsTable> {
        $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get nombre => $composableBuilder(
      column: $table.nombre,
      builder: (column) => column);
      
GeneratedColumn<String> get apellidoPaterno => $composableBuilder(
      column: $table.apellidoPaterno,
      builder: (column) => column);
      
GeneratedColumn<String> get apellidoMaterno => $composableBuilder(
      column: $table.apellidoMaterno,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get fechaNacimiento => $composableBuilder(
      column: $table.fechaNacimiento,
      builder: (column) => column);
      
GeneratedColumn<String> get telefono => $composableBuilder(
      column: $table.telefono,
      builder: (column) => column);
      
        }
      class $$PatientsTableTableManager extends RootTableManager    <_$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient,BaseReferences<_$AppDatabase,$PatientsTable,Patient>),
    Patient,
    PrefetchHooks Function()
    > {
    $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$PatientsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$PatientsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$PatientsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> nombre = const Value.absent(),Value<String> apellidoPaterno = const Value.absent(),Value<String> apellidoMaterno = const Value.absent(),Value<DateTime> fechaNacimiento = const Value.absent(),Value<String?> telefono = const Value.absent(),})=> PatientsCompanion(id: id,nombre: nombre,apellidoPaterno: apellidoPaterno,apellidoMaterno: apellidoMaterno,fechaNacimiento: fechaNacimiento,telefono: telefono,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String nombre,required String apellidoPaterno,required String apellidoMaterno,required DateTime fechaNacimiento,Value<String?> telefono = const Value.absent(),})=> PatientsCompanion.insert(id: id,nombre: nombre,apellidoPaterno: apellidoPaterno,apellidoMaterno: apellidoMaterno,fechaNacimiento: fechaNacimiento,telefono: telefono,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$PatientsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient,BaseReferences<_$AppDatabase,$PatientsTable,Patient>),
    Patient,
    PrefetchHooks Function()
    >;typedef $$SchedulesTableCreateCompanionBuilder = SchedulesCompanion Function({Value<int> id,required String medicamento,required String pacienteNombre,required int casillero,required int horaProxima,required int minutoProxima,required int intervaloMinutos,required int tomasRestantes,required DateTime fechaCreacion,});
typedef $$SchedulesTableUpdateCompanionBuilder = SchedulesCompanion Function({Value<int> id,Value<String> medicamento,Value<String> pacienteNombre,Value<int> casillero,Value<int> horaProxima,Value<int> minutoProxima,Value<int> intervaloMinutos,Value<int> tomasRestantes,Value<DateTime> fechaCreacion,});
class $$SchedulesTableFilterComposer extends Composer<
        _$AppDatabase,
        $SchedulesTable> {
        $$SchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get medicamento => $composableBuilder(
      column: $table.medicamento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get pacienteNombre => $composableBuilder(
      column: $table.pacienteNombre,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get casillero => $composableBuilder(
      column: $table.casillero,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get horaProxima => $composableBuilder(
      column: $table.horaProxima,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get minutoProxima => $composableBuilder(
      column: $table.minutoProxima,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get intervaloMinutos => $composableBuilder(
      column: $table.intervaloMinutos,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get tomasRestantes => $composableBuilder(
      column: $table.tomasRestantes,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$SchedulesTableOrderingComposer extends Composer<
        _$AppDatabase,
        $SchedulesTable> {
        $$SchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get medicamento => $composableBuilder(
      column: $table.medicamento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get pacienteNombre => $composableBuilder(
      column: $table.pacienteNombre,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get casillero => $composableBuilder(
      column: $table.casillero,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get horaProxima => $composableBuilder(
      column: $table.horaProxima,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get minutoProxima => $composableBuilder(
      column: $table.minutoProxima,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get intervaloMinutos => $composableBuilder(
      column: $table.intervaloMinutos,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get tomasRestantes => $composableBuilder(
      column: $table.tomasRestantes,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$SchedulesTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $SchedulesTable> {
        $$SchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get medicamento => $composableBuilder(
      column: $table.medicamento,
      builder: (column) => column);
      
GeneratedColumn<String> get pacienteNombre => $composableBuilder(
      column: $table.pacienteNombre,
      builder: (column) => column);
      
GeneratedColumn<int> get casillero => $composableBuilder(
      column: $table.casillero,
      builder: (column) => column);
      
GeneratedColumn<int> get horaProxima => $composableBuilder(
      column: $table.horaProxima,
      builder: (column) => column);
      
GeneratedColumn<int> get minutoProxima => $composableBuilder(
      column: $table.minutoProxima,
      builder: (column) => column);
      
GeneratedColumn<int> get intervaloMinutos => $composableBuilder(
      column: $table.intervaloMinutos,
      builder: (column) => column);
      
GeneratedColumn<int> get tomasRestantes => $composableBuilder(
      column: $table.tomasRestantes,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => column);
      
        }
      class $$SchedulesTableTableManager extends RootTableManager    <_$AppDatabase,
    $SchedulesTable,
    Schedule,
    $$SchedulesTableFilterComposer,
    $$SchedulesTableOrderingComposer,
    $$SchedulesTableAnnotationComposer,
    $$SchedulesTableCreateCompanionBuilder,
    $$SchedulesTableUpdateCompanionBuilder,
    (Schedule,BaseReferences<_$AppDatabase,$SchedulesTable,Schedule>),
    Schedule,
    PrefetchHooks Function()
    > {
    $$SchedulesTableTableManager(_$AppDatabase db, $SchedulesTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$SchedulesTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$SchedulesTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$SchedulesTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> medicamento = const Value.absent(),Value<String> pacienteNombre = const Value.absent(),Value<int> casillero = const Value.absent(),Value<int> horaProxima = const Value.absent(),Value<int> minutoProxima = const Value.absent(),Value<int> intervaloMinutos = const Value.absent(),Value<int> tomasRestantes = const Value.absent(),Value<DateTime> fechaCreacion = const Value.absent(),})=> SchedulesCompanion(id: id,medicamento: medicamento,pacienteNombre: pacienteNombre,casillero: casillero,horaProxima: horaProxima,minutoProxima: minutoProxima,intervaloMinutos: intervaloMinutos,tomasRestantes: tomasRestantes,fechaCreacion: fechaCreacion,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String medicamento,required String pacienteNombre,required int casillero,required int horaProxima,required int minutoProxima,required int intervaloMinutos,required int tomasRestantes,required DateTime fechaCreacion,})=> SchedulesCompanion.insert(id: id,medicamento: medicamento,pacienteNombre: pacienteNombre,casillero: casillero,horaProxima: horaProxima,minutoProxima: minutoProxima,intervaloMinutos: intervaloMinutos,tomasRestantes: tomasRestantes,fechaCreacion: fechaCreacion,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$SchedulesTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $SchedulesTable,
    Schedule,
    $$SchedulesTableFilterComposer,
    $$SchedulesTableOrderingComposer,
    $$SchedulesTableAnnotationComposer,
    $$SchedulesTableCreateCompanionBuilder,
    $$SchedulesTableUpdateCompanionBuilder,
    (Schedule,BaseReferences<_$AppDatabase,$SchedulesTable,Schedule>),
    Schedule,
    PrefetchHooks Function()
    >;class $AppDatabaseManager {
final _$AppDatabase _db;
$AppDatabaseManager(this._db);
$$PatientsTableTableManager get patients => $$PatientsTableTableManager(_db, _db.patients);
$$SchedulesTableTableManager get schedules => $$SchedulesTableTableManager(_db, _db.schedules);
}
