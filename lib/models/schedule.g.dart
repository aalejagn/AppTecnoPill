// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScheduleCollection on Isar {
  IsarCollection<Schedule> get schedules => this.collection();
}

const ScheduleSchema = CollectionSchema(
  name: r'Schedule',
  id: 6369058706800408146,
  properties: {
    r'casillero': PropertySchema(
      id: 0,
      name: r'casillero',
      type: IsarType.long,
    ),
    r'fechaCreacion': PropertySchema(
      id: 1,
      name: r'fechaCreacion',
      type: IsarType.dateTime,
    ),
    r'horaProxima': PropertySchema(
      id: 2,
      name: r'horaProxima',
      type: IsarType.long,
    ),
    r'intervaloMinutos': PropertySchema(
      id: 3,
      name: r'intervaloMinutos',
      type: IsarType.long,
    ),
    r'medicamento': PropertySchema(
      id: 4,
      name: r'medicamento',
      type: IsarType.string,
    ),
    r'minutoProxima': PropertySchema(
      id: 5,
      name: r'minutoProxima',
      type: IsarType.long,
    ),
    r'tomasRestantes': PropertySchema(
      id: 6,
      name: r'tomasRestantes',
      type: IsarType.long,
    )
  },
  estimateSize: _scheduleEstimateSize,
  serialize: _scheduleSerialize,
  deserialize: _scheduleDeserialize,
  deserializeProp: _scheduleDeserializeProp,
  idName: r'id',
  indexes: {
    r'casillero': IndexSchema(
      id: 7365224650497832294,
      name: r'casillero',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'casillero',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _scheduleGetId,
  getLinks: _scheduleGetLinks,
  attach: _scheduleAttach,
  version: '3.1.0+1',
);

int _scheduleEstimateSize(
  Schedule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.medicamento.length * 3;
  return bytesCount;
}

void _scheduleSerialize(
  Schedule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.casillero);
  writer.writeDateTime(offsets[1], object.fechaCreacion);
  writer.writeLong(offsets[2], object.horaProxima);
  writer.writeLong(offsets[3], object.intervaloMinutos);
  writer.writeString(offsets[4], object.medicamento);
  writer.writeLong(offsets[5], object.minutoProxima);
  writer.writeLong(offsets[6], object.tomasRestantes);
}

Schedule _scheduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Schedule();
  object.casillero = reader.readLongOrNull(offsets[0]);
  object.fechaCreacion = reader.readDateTime(offsets[1]);
  object.horaProxima = reader.readLong(offsets[2]);
  object.id = id;
  object.intervaloMinutos = reader.readLong(offsets[3]);
  object.medicamento = reader.readString(offsets[4]);
  object.minutoProxima = reader.readLong(offsets[5]);
  object.tomasRestantes = reader.readLong(offsets[6]);
  return object;
}

P _scheduleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scheduleGetId(Schedule object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scheduleGetLinks(Schedule object) {
  return [];
}

void _scheduleAttach(IsarCollection<dynamic> col, Id id, Schedule object) {
  object.id = id;
}

extension ScheduleByIndex on IsarCollection<Schedule> {
  Future<Schedule?> getByCasillero(int? casillero) {
    return getByIndex(r'casillero', [casillero]);
  }

  Schedule? getByCasilleroSync(int? casillero) {
    return getByIndexSync(r'casillero', [casillero]);
  }

  Future<bool> deleteByCasillero(int? casillero) {
    return deleteByIndex(r'casillero', [casillero]);
  }

  bool deleteByCasilleroSync(int? casillero) {
    return deleteByIndexSync(r'casillero', [casillero]);
  }

  Future<List<Schedule?>> getAllByCasillero(List<int?> casilleroValues) {
    final values = casilleroValues.map((e) => [e]).toList();
    return getAllByIndex(r'casillero', values);
  }

  List<Schedule?> getAllByCasilleroSync(List<int?> casilleroValues) {
    final values = casilleroValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'casillero', values);
  }

  Future<int> deleteAllByCasillero(List<int?> casilleroValues) {
    final values = casilleroValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'casillero', values);
  }

  int deleteAllByCasilleroSync(List<int?> casilleroValues) {
    final values = casilleroValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'casillero', values);
  }

  Future<Id> putByCasillero(Schedule object) {
    return putByIndex(r'casillero', object);
  }

  Id putByCasilleroSync(Schedule object, {bool saveLinks = true}) {
    return putByIndexSync(r'casillero', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCasillero(List<Schedule> objects) {
    return putAllByIndex(r'casillero', objects);
  }

  List<Id> putAllByCasilleroSync(List<Schedule> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'casillero', objects, saveLinks: saveLinks);
  }
}

extension ScheduleQueryWhereSort on QueryBuilder<Schedule, Schedule, QWhere> {
  QueryBuilder<Schedule, Schedule, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhere> anyCasillero() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'casillero'),
      );
    });
  }
}

extension ScheduleQueryWhere on QueryBuilder<Schedule, Schedule, QWhereClause> {
  QueryBuilder<Schedule, Schedule, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> casilleroIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'casillero',
        value: [null],
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> casilleroIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'casillero',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> casilleroEqualTo(
      int? casillero) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'casillero',
        value: [casillero],
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> casilleroNotEqualTo(
      int? casillero) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casillero',
              lower: [],
              upper: [casillero],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casillero',
              lower: [casillero],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casillero',
              lower: [casillero],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casillero',
              lower: [],
              upper: [casillero],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> casilleroGreaterThan(
    int? casillero, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'casillero',
        lower: [casillero],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> casilleroLessThan(
    int? casillero, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'casillero',
        lower: [],
        upper: [casillero],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterWhereClause> casilleroBetween(
    int? lowerCasillero,
    int? upperCasillero, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'casillero',
        lower: [lowerCasillero],
        includeLower: includeLower,
        upper: [upperCasillero],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScheduleQueryFilter
    on QueryBuilder<Schedule, Schedule, QFilterCondition> {
  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> casilleroIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'casillero',
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> casilleroIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'casillero',
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> casilleroEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'casillero',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> casilleroGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'casillero',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> casilleroLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'casillero',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> casilleroBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'casillero',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> fechaCreacionEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaCreacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      fechaCreacionGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fechaCreacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> fechaCreacionLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fechaCreacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> fechaCreacionBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fechaCreacion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> horaProximaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'horaProxima',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      horaProximaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'horaProxima',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> horaProximaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'horaProxima',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> horaProximaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'horaProxima',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      intervaloMinutosEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervaloMinutos',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      intervaloMinutosGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervaloMinutos',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      intervaloMinutosLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervaloMinutos',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      intervaloMinutosBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervaloMinutos',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      medicamentoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicamento',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medicamento',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> medicamentoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicamento',
        value: '',
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      medicamentoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medicamento',
        value: '',
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> minutoProximaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutoProxima',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      minutoProximaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutoProxima',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> minutoProximaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutoProxima',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> minutoProximaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutoProxima',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> tomasRestantesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tomasRestantes',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      tomasRestantesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tomasRestantes',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition>
      tomasRestantesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tomasRestantes',
        value: value,
      ));
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterFilterCondition> tomasRestantesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tomasRestantes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScheduleQueryObject
    on QueryBuilder<Schedule, Schedule, QFilterCondition> {}

extension ScheduleQueryLinks
    on QueryBuilder<Schedule, Schedule, QFilterCondition> {}

extension ScheduleQuerySortBy on QueryBuilder<Schedule, Schedule, QSortBy> {
  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByCasillero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casillero', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByCasilleroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casillero', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByFechaCreacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByHoraProxima() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'horaProxima', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByHoraProximaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'horaProxima', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByIntervaloMinutos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloMinutos', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByIntervaloMinutosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloMinutos', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByMedicamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByMedicamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByMinutoProxima() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutoProxima', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByMinutoProximaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutoProxima', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByTomasRestantes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tomasRestantes', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> sortByTomasRestantesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tomasRestantes', Sort.desc);
    });
  }
}

extension ScheduleQuerySortThenBy
    on QueryBuilder<Schedule, Schedule, QSortThenBy> {
  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByCasillero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casillero', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByCasilleroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casillero', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByFechaCreacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByHoraProxima() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'horaProxima', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByHoraProximaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'horaProxima', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByIntervaloMinutos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloMinutos', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByIntervaloMinutosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloMinutos', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByMedicamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByMedicamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByMinutoProxima() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutoProxima', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByMinutoProximaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutoProxima', Sort.desc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByTomasRestantes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tomasRestantes', Sort.asc);
    });
  }

  QueryBuilder<Schedule, Schedule, QAfterSortBy> thenByTomasRestantesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tomasRestantes', Sort.desc);
    });
  }
}

extension ScheduleQueryWhereDistinct
    on QueryBuilder<Schedule, Schedule, QDistinct> {
  QueryBuilder<Schedule, Schedule, QDistinct> distinctByCasillero() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'casillero');
    });
  }

  QueryBuilder<Schedule, Schedule, QDistinct> distinctByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaCreacion');
    });
  }

  QueryBuilder<Schedule, Schedule, QDistinct> distinctByHoraProxima() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'horaProxima');
    });
  }

  QueryBuilder<Schedule, Schedule, QDistinct> distinctByIntervaloMinutos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervaloMinutos');
    });
  }

  QueryBuilder<Schedule, Schedule, QDistinct> distinctByMedicamento(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicamento', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Schedule, Schedule, QDistinct> distinctByMinutoProxima() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutoProxima');
    });
  }

  QueryBuilder<Schedule, Schedule, QDistinct> distinctByTomasRestantes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tomasRestantes');
    });
  }
}

extension ScheduleQueryProperty
    on QueryBuilder<Schedule, Schedule, QQueryProperty> {
  QueryBuilder<Schedule, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Schedule, int?, QQueryOperations> casilleroProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'casillero');
    });
  }

  QueryBuilder<Schedule, DateTime, QQueryOperations> fechaCreacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaCreacion');
    });
  }

  QueryBuilder<Schedule, int, QQueryOperations> horaProximaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'horaProxima');
    });
  }

  QueryBuilder<Schedule, int, QQueryOperations> intervaloMinutosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervaloMinutos');
    });
  }

  QueryBuilder<Schedule, String, QQueryOperations> medicamentoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicamento');
    });
  }

  QueryBuilder<Schedule, int, QQueryOperations> minutoProximaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutoProxima');
    });
  }

  QueryBuilder<Schedule, int, QQueryOperations> tomasRestantesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tomasRestantes');
    });
  }
}
