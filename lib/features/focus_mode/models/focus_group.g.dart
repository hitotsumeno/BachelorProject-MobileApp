// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_group.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFocusGroupCollection on Isar {
  IsarCollection<FocusGroup> get focusGroups => this.collection();
}

const FocusGroupSchema = CollectionSchema(
  name: r'FocusGroup',
  id: -1299570738614889172,
  properties: {
    r'activeDays': PropertySchema(
      id: 0,
      name: r'activeDays',
      type: IsarType.longList,
    ),
    r'appDisplayNames': PropertySchema(
      id: 1,
      name: r'appDisplayNames',
      type: IsarType.stringList,
    ),
    r'appPackageNames': PropertySchema(
      id: 2,
      name: r'appPackageNames',
      type: IsarType.stringList,
    ),
    r'intervalEndsAt': PropertySchema(
      id: 3,
      name: r'intervalEndsAt',
      type: IsarType.string,
    ),
    r'intervalLengthMinutes': PropertySchema(
      id: 4,
      name: r'intervalLengthMinutes',
      type: IsarType.long,
    ),
    r'intervalsPerDay': PropertySchema(
      id: 5,
      name: r'intervalsPerDay',
      type: IsarType.long,
    ),
    r'intervalsUsedToday': PropertySchema(
      id: 6,
      name: r'intervalsUsedToday',
      type: IsarType.long,
    ),
    r'isEnabled': PropertySchema(
      id: 7,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'isStrict': PropertySchema(
      id: 8,
      name: r'isStrict',
      type: IsarType.bool,
    ),
    r'lastStreakDate': PropertySchema(
      id: 9,
      name: r'lastStreakDate',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 10,
      name: r'name',
      type: IsarType.string,
    ),
    r'streak': PropertySchema(
      id: 11,
      name: r'streak',
      type: IsarType.long,
    ),
    r'timeWindows': PropertySchema(
      id: 12,
      name: r'timeWindows',
      type: IsarType.objectList,
      target: r'FocusTimeWindow',
    )
  },
  estimateSize: _focusGroupEstimateSize,
  serialize: _focusGroupSerialize,
  deserialize: _focusGroupDeserialize,
  deserializeProp: _focusGroupDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'FocusTimeWindow': FocusTimeWindowSchema},
  getId: _focusGroupGetId,
  getLinks: _focusGroupGetLinks,
  attach: _focusGroupAttach,
  version: '3.1.0+1',
);

int _focusGroupEstimateSize(
  FocusGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activeDays.length * 8;
  bytesCount += 3 + object.appDisplayNames.length * 3;
  {
    for (var i = 0; i < object.appDisplayNames.length; i++) {
      final value = object.appDisplayNames[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.appPackageNames.length * 3;
  {
    for (var i = 0; i < object.appPackageNames.length; i++) {
      final value = object.appPackageNames[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.intervalEndsAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastStreakDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.timeWindows.length * 3;
  {
    final offsets = allOffsets[FocusTimeWindow]!;
    for (var i = 0; i < object.timeWindows.length; i++) {
      final value = object.timeWindows[i];
      bytesCount +=
          FocusTimeWindowSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _focusGroupSerialize(
  FocusGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.activeDays);
  writer.writeStringList(offsets[1], object.appDisplayNames);
  writer.writeStringList(offsets[2], object.appPackageNames);
  writer.writeString(offsets[3], object.intervalEndsAt);
  writer.writeLong(offsets[4], object.intervalLengthMinutes);
  writer.writeLong(offsets[5], object.intervalsPerDay);
  writer.writeLong(offsets[6], object.intervalsUsedToday);
  writer.writeBool(offsets[7], object.isEnabled);
  writer.writeBool(offsets[8], object.isStrict);
  writer.writeString(offsets[9], object.lastStreakDate);
  writer.writeString(offsets[10], object.name);
  writer.writeLong(offsets[11], object.streak);
  writer.writeObjectList<FocusTimeWindow>(
    offsets[12],
    allOffsets,
    FocusTimeWindowSchema.serialize,
    object.timeWindows,
  );
}

FocusGroup _focusGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FocusGroup();
  object.activeDays = reader.readLongList(offsets[0]) ?? [];
  object.appDisplayNames = reader.readStringList(offsets[1]) ?? [];
  object.appPackageNames = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.intervalEndsAt = reader.readStringOrNull(offsets[3]);
  object.intervalLengthMinutes = reader.readLong(offsets[4]);
  object.intervalsPerDay = reader.readLong(offsets[5]);
  object.intervalsUsedToday = reader.readLong(offsets[6]);
  object.isEnabled = reader.readBool(offsets[7]);
  object.isStrict = reader.readBool(offsets[8]);
  object.lastStreakDate = reader.readStringOrNull(offsets[9]);
  object.name = reader.readString(offsets[10]);
  object.streak = reader.readLong(offsets[11]);
  object.timeWindows = reader.readObjectList<FocusTimeWindow>(
        offsets[12],
        FocusTimeWindowSchema.deserialize,
        allOffsets,
        FocusTimeWindow(),
      ) ??
      [];
  return object;
}

P _focusGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readObjectList<FocusTimeWindow>(
            offset,
            FocusTimeWindowSchema.deserialize,
            allOffsets,
            FocusTimeWindow(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _focusGroupGetId(FocusGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _focusGroupGetLinks(FocusGroup object) {
  return [];
}

void _focusGroupAttach(IsarCollection<dynamic> col, Id id, FocusGroup object) {
  object.id = id;
}

extension FocusGroupQueryWhereSort
    on QueryBuilder<FocusGroup, FocusGroup, QWhere> {
  QueryBuilder<FocusGroup, FocusGroup, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FocusGroupQueryWhere
    on QueryBuilder<FocusGroup, FocusGroup, QWhereClause> {
  QueryBuilder<FocusGroup, FocusGroup, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<FocusGroup, FocusGroup, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterWhereClause> idBetween(
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
}

extension FocusGroupQueryFilter
    on QueryBuilder<FocusGroup, FocusGroup, QFilterCondition> {
  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      activeDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appDisplayNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appDisplayNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appDisplayNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appDisplayNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appDisplayNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appDisplayNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appDisplayNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appDisplayNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appDisplayNames',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appDisplayNames',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appDisplayNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appDisplayNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appDisplayNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appDisplayNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appDisplayNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appDisplayNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appDisplayNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appPackageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appPackageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appPackageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appPackageNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appPackageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appPackageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appPackageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appPackageNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appPackageNames',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appPackageNames',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appPackageNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appPackageNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appPackageNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appPackageNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appPackageNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      appPackageNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appPackageNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intervalEndsAt',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intervalEndsAt',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalEndsAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalEndsAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalEndsAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalEndsAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'intervalEndsAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'intervalEndsAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'intervalEndsAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'intervalEndsAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalEndsAt',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalEndsAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'intervalEndsAt',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalLengthMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalLengthMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalLengthMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalLengthMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalLengthMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalLengthMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalLengthMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalLengthMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsPerDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalsPerDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsPerDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalsPerDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsPerDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalsPerDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsPerDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalsPerDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsUsedTodayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalsUsedToday',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsUsedTodayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalsUsedToday',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsUsedTodayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalsUsedToday',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      intervalsUsedTodayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalsUsedToday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> isEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> isStrictEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isStrict',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastStreakDate',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastStreakDate',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastStreakDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastStreakDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastStreakDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastStreakDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastStreakDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastStreakDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastStreakDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastStreakDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastStreakDate',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      lastStreakDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastStreakDate',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> streakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streak',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> streakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streak',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> streakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streak',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition> streakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      timeWindowsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeWindows',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      timeWindowsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeWindows',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      timeWindowsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeWindows',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      timeWindowsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeWindows',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      timeWindowsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeWindows',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      timeWindowsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeWindows',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension FocusGroupQueryObject
    on QueryBuilder<FocusGroup, FocusGroup, QFilterCondition> {
  QueryBuilder<FocusGroup, FocusGroup, QAfterFilterCondition>
      timeWindowsElement(FilterQuery<FocusTimeWindow> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'timeWindows');
    });
  }
}

extension FocusGroupQueryLinks
    on QueryBuilder<FocusGroup, FocusGroup, QFilterCondition> {}

extension FocusGroupQuerySortBy
    on QueryBuilder<FocusGroup, FocusGroup, QSortBy> {
  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByIntervalEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalEndsAt', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      sortByIntervalEndsAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalEndsAt', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      sortByIntervalLengthMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalLengthMinutes', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      sortByIntervalLengthMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalLengthMinutes', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByIntervalsPerDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsPerDay', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      sortByIntervalsPerDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsPerDay', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      sortByIntervalsUsedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsUsedToday', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      sortByIntervalsUsedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsUsedToday', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByIsStrict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStrict', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByIsStrictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStrict', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByLastStreakDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      sortByLastStreakDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> sortByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }
}

extension FocusGroupQuerySortThenBy
    on QueryBuilder<FocusGroup, FocusGroup, QSortThenBy> {
  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByIntervalEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalEndsAt', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      thenByIntervalEndsAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalEndsAt', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      thenByIntervalLengthMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalLengthMinutes', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      thenByIntervalLengthMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalLengthMinutes', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByIntervalsPerDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsPerDay', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      thenByIntervalsPerDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsPerDay', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      thenByIntervalsUsedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsUsedToday', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      thenByIntervalsUsedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalsUsedToday', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByIsStrict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStrict', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByIsStrictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStrict', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByLastStreakDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy>
      thenByLastStreakDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QAfterSortBy> thenByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }
}

extension FocusGroupQueryWhereDistinct
    on QueryBuilder<FocusGroup, FocusGroup, QDistinct> {
  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByActiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeDays');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByAppDisplayNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appDisplayNames');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByAppPackageNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appPackageNames');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByIntervalEndsAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalEndsAt',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct>
      distinctByIntervalLengthMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalLengthMinutes');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByIntervalsPerDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalsPerDay');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct>
      distinctByIntervalsUsedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalsUsedToday');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByIsStrict() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isStrict');
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByLastStreakDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastStreakDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FocusGroup, FocusGroup, QDistinct> distinctByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streak');
    });
  }
}

extension FocusGroupQueryProperty
    on QueryBuilder<FocusGroup, FocusGroup, QQueryProperty> {
  QueryBuilder<FocusGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FocusGroup, List<int>, QQueryOperations> activeDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeDays');
    });
  }

  QueryBuilder<FocusGroup, List<String>, QQueryOperations>
      appDisplayNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appDisplayNames');
    });
  }

  QueryBuilder<FocusGroup, List<String>, QQueryOperations>
      appPackageNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appPackageNames');
    });
  }

  QueryBuilder<FocusGroup, String?, QQueryOperations> intervalEndsAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalEndsAt');
    });
  }

  QueryBuilder<FocusGroup, int, QQueryOperations>
      intervalLengthMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalLengthMinutes');
    });
  }

  QueryBuilder<FocusGroup, int, QQueryOperations> intervalsPerDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalsPerDay');
    });
  }

  QueryBuilder<FocusGroup, int, QQueryOperations> intervalsUsedTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalsUsedToday');
    });
  }

  QueryBuilder<FocusGroup, bool, QQueryOperations> isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<FocusGroup, bool, QQueryOperations> isStrictProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isStrict');
    });
  }

  QueryBuilder<FocusGroup, String?, QQueryOperations> lastStreakDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastStreakDate');
    });
  }

  QueryBuilder<FocusGroup, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FocusGroup, int, QQueryOperations> streakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streak');
    });
  }

  QueryBuilder<FocusGroup, List<FocusTimeWindow>, QQueryOperations>
      timeWindowsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeWindows');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FocusTimeWindowSchema = Schema(
  name: r'FocusTimeWindow',
  id: 4462626583798325198,
  properties: {
    r'endHour': PropertySchema(
      id: 0,
      name: r'endHour',
      type: IsarType.long,
    ),
    r'endMinute': PropertySchema(
      id: 1,
      name: r'endMinute',
      type: IsarType.long,
    ),
    r'startHour': PropertySchema(
      id: 2,
      name: r'startHour',
      type: IsarType.long,
    ),
    r'startMinute': PropertySchema(
      id: 3,
      name: r'startMinute',
      type: IsarType.long,
    )
  },
  estimateSize: _focusTimeWindowEstimateSize,
  serialize: _focusTimeWindowSerialize,
  deserialize: _focusTimeWindowDeserialize,
  deserializeProp: _focusTimeWindowDeserializeProp,
);

int _focusTimeWindowEstimateSize(
  FocusTimeWindow object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _focusTimeWindowSerialize(
  FocusTimeWindow object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.endHour);
  writer.writeLong(offsets[1], object.endMinute);
  writer.writeLong(offsets[2], object.startHour);
  writer.writeLong(offsets[3], object.startMinute);
}

FocusTimeWindow _focusTimeWindowDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FocusTimeWindow();
  object.endHour = reader.readLong(offsets[0]);
  object.endMinute = reader.readLong(offsets[1]);
  object.startHour = reader.readLong(offsets[2]);
  object.startMinute = reader.readLong(offsets[3]);
  return object;
}

P _focusTimeWindowDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FocusTimeWindowQueryFilter
    on QueryBuilder<FocusTimeWindow, FocusTimeWindow, QFilterCondition> {
  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endHour',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endHour',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endHour',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      endMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startHour',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startHour',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startHour',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusTimeWindow, FocusTimeWindow, QAfterFilterCondition>
      startMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FocusTimeWindowQueryObject
    on QueryBuilder<FocusTimeWindow, FocusTimeWindow, QFilterCondition> {}
