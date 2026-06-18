// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_compliance.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyComplianceCollection on Isar {
  IsarCollection<DailyCompliance> get dailyCompliances => this.collection();
}

const DailyComplianceSchema = CollectionSchema(
  name: r'DailyCompliance',
  id: 6295246856850742706,
  properties: {
    r'bypassCount': PropertySchema(
      id: 0,
      name: r'bypassCount',
      type: IsarType.long,
    ),
    r'compliant': PropertySchema(
      id: 1,
      name: r'compliant',
      type: IsarType.bool,
    ),
    r'dateKey': PropertySchema(
      id: 2,
      name: r'dateKey',
      type: IsarType.string,
    ),
    r'rewardGranted': PropertySchema(
      id: 3,
      name: r'rewardGranted',
      type: IsarType.bool,
    )
  },
  estimateSize: _dailyComplianceEstimateSize,
  serialize: _dailyComplianceSerialize,
  deserialize: _dailyComplianceDeserialize,
  deserializeProp: _dailyComplianceDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateKey': IndexSchema(
      id: 7975223786082927131,
      name: r'dateKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'dateKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyComplianceGetId,
  getLinks: _dailyComplianceGetLinks,
  attach: _dailyComplianceAttach,
  version: '3.1.0+1',
);

int _dailyComplianceEstimateSize(
  DailyCompliance object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dateKey.length * 3;
  return bytesCount;
}

void _dailyComplianceSerialize(
  DailyCompliance object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bypassCount);
  writer.writeBool(offsets[1], object.compliant);
  writer.writeString(offsets[2], object.dateKey);
  writer.writeBool(offsets[3], object.rewardGranted);
}

DailyCompliance _dailyComplianceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyCompliance();
  object.bypassCount = reader.readLong(offsets[0]);
  object.compliant = reader.readBool(offsets[1]);
  object.dateKey = reader.readString(offsets[2]);
  object.id = id;
  object.rewardGranted = reader.readBool(offsets[3]);
  return object;
}

P _dailyComplianceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyComplianceGetId(DailyCompliance object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyComplianceGetLinks(DailyCompliance object) {
  return [];
}

void _dailyComplianceAttach(
    IsarCollection<dynamic> col, Id id, DailyCompliance object) {
  object.id = id;
}

extension DailyComplianceByIndex on IsarCollection<DailyCompliance> {
  Future<DailyCompliance?> getByDateKey(String dateKey) {
    return getByIndex(r'dateKey', [dateKey]);
  }

  DailyCompliance? getByDateKeySync(String dateKey) {
    return getByIndexSync(r'dateKey', [dateKey]);
  }

  Future<bool> deleteByDateKey(String dateKey) {
    return deleteByIndex(r'dateKey', [dateKey]);
  }

  bool deleteByDateKeySync(String dateKey) {
    return deleteByIndexSync(r'dateKey', [dateKey]);
  }

  Future<List<DailyCompliance?>> getAllByDateKey(List<String> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'dateKey', values);
  }

  List<DailyCompliance?> getAllByDateKeySync(List<String> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dateKey', values);
  }

  Future<int> deleteAllByDateKey(List<String> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dateKey', values);
  }

  int deleteAllByDateKeySync(List<String> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dateKey', values);
  }

  Future<Id> putByDateKey(DailyCompliance object) {
    return putByIndex(r'dateKey', object);
  }

  Id putByDateKeySync(DailyCompliance object, {bool saveLinks = true}) {
    return putByIndexSync(r'dateKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDateKey(List<DailyCompliance> objects) {
    return putAllByIndex(r'dateKey', objects);
  }

  List<Id> putAllByDateKeySync(List<DailyCompliance> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'dateKey', objects, saveLinks: saveLinks);
  }
}

extension DailyComplianceQueryWhereSort
    on QueryBuilder<DailyCompliance, DailyCompliance, QWhere> {
  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyComplianceQueryWhere
    on QueryBuilder<DailyCompliance, DailyCompliance, QWhereClause> {
  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhereClause>
      dateKeyEqualTo(String dateKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateKey',
        value: [dateKey],
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterWhereClause>
      dateKeyNotEqualTo(String dateKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [],
              upper: [dateKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [dateKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [dateKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [],
              upper: [dateKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DailyComplianceQueryFilter
    on QueryBuilder<DailyCompliance, DailyCompliance, QFilterCondition> {
  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      bypassCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bypassCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      bypassCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bypassCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      bypassCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bypassCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      bypassCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bypassCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      compliantEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compliant',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      dateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterFilterCondition>
      rewardGrantedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardGranted',
        value: value,
      ));
    });
  }
}

extension DailyComplianceQueryObject
    on QueryBuilder<DailyCompliance, DailyCompliance, QFilterCondition> {}

extension DailyComplianceQueryLinks
    on QueryBuilder<DailyCompliance, DailyCompliance, QFilterCondition> {}

extension DailyComplianceQuerySortBy
    on QueryBuilder<DailyCompliance, DailyCompliance, QSortBy> {
  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      sortByBypassCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bypassCount', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      sortByBypassCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bypassCount', Sort.desc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      sortByCompliant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compliant', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      sortByCompliantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compliant', Sort.desc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy> sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      sortByRewardGranted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardGranted', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      sortByRewardGrantedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardGranted', Sort.desc);
    });
  }
}

extension DailyComplianceQuerySortThenBy
    on QueryBuilder<DailyCompliance, DailyCompliance, QSortThenBy> {
  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      thenByBypassCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bypassCount', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      thenByBypassCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bypassCount', Sort.desc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      thenByCompliant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compliant', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      thenByCompliantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compliant', Sort.desc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy> thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      thenByRewardGranted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardGranted', Sort.asc);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QAfterSortBy>
      thenByRewardGrantedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardGranted', Sort.desc);
    });
  }
}

extension DailyComplianceQueryWhereDistinct
    on QueryBuilder<DailyCompliance, DailyCompliance, QDistinct> {
  QueryBuilder<DailyCompliance, DailyCompliance, QDistinct>
      distinctByBypassCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bypassCount');
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QDistinct>
      distinctByCompliant() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compliant');
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QDistinct> distinctByDateKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyCompliance, DailyCompliance, QDistinct>
      distinctByRewardGranted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewardGranted');
    });
  }
}

extension DailyComplianceQueryProperty
    on QueryBuilder<DailyCompliance, DailyCompliance, QQueryProperty> {
  QueryBuilder<DailyCompliance, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyCompliance, int, QQueryOperations> bypassCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bypassCount');
    });
  }

  QueryBuilder<DailyCompliance, bool, QQueryOperations> compliantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compliant');
    });
  }

  QueryBuilder<DailyCompliance, String, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<DailyCompliance, bool, QQueryOperations>
      rewardGrantedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewardGranted');
    });
  }
}
