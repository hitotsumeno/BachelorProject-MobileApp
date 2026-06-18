// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScheduledTaskCollection on Isar {
  IsarCollection<ScheduledTask> get scheduledTasks => this.collection();
}

const ScheduledTaskSchema = CollectionSchema(
  name: r'ScheduledTask',
  id: -2920409038306608989,
  properties: {
    r'dailyInterval': PropertySchema(
      id: 0,
      name: r'dailyInterval',
      type: IsarType.long,
    ),
    r'difficulty': PropertySchema(
      id: 1,
      name: r'difficulty',
      type: IsarType.byte,
      enumMap: _ScheduledTaskdifficultyEnumValueMap,
    ),
    r'isDone': PropertySchema(
      id: 2,
      name: r'isDone',
      type: IsarType.bool,
    ),
    r'lastCompletedDate': PropertySchema(
      id: 3,
      name: r'lastCompletedDate',
      type: IsarType.dateTime,
    ),
    r'lastStreakDate': PropertySchema(
      id: 4,
      name: r'lastStreakDate',
      type: IsarType.dateTime,
    ),
    r'minutesBefore': PropertySchema(
      id: 5,
      name: r'minutesBefore',
      type: IsarType.long,
    ),
    r'monthlyDayOfMonth': PropertySchema(
      id: 6,
      name: r'monthlyDayOfMonth',
      type: IsarType.long,
    ),
    r'monthlyOrdinal': PropertySchema(
      id: 7,
      name: r'monthlyOrdinal',
      type: IsarType.byte,
      enumMap: _ScheduledTaskmonthlyOrdinalEnumValueMap,
    ),
    r'monthlySubMode': PropertySchema(
      id: 8,
      name: r'monthlySubMode',
      type: IsarType.byte,
      enumMap: _ScheduledTaskmonthlySubModeEnumValueMap,
    ),
    r'monthlyWeekday': PropertySchema(
      id: 9,
      name: r'monthlyWeekday',
      type: IsarType.long,
    ),
    r'note': PropertySchema(
      id: 10,
      name: r'note',
      type: IsarType.string,
    ),
    r'notificationHour': PropertySchema(
      id: 11,
      name: r'notificationHour',
      type: IsarType.long,
    ),
    r'notificationMinute': PropertySchema(
      id: 12,
      name: r'notificationMinute',
      type: IsarType.long,
    ),
    r'recurrenceType': PropertySchema(
      id: 13,
      name: r'recurrenceType',
      type: IsarType.byte,
      enumMap: _ScheduledTaskrecurrenceTypeEnumValueMap,
    ),
    r'reminderMode': PropertySchema(
      id: 14,
      name: r'reminderMode',
      type: IsarType.byte,
      enumMap: _ScheduledTaskreminderModeEnumValueMap,
    ),
    r'scheduledDate': PropertySchema(
      id: 15,
      name: r'scheduledDate',
      type: IsarType.dateTime,
    ),
    r'streak': PropertySchema(
      id: 16,
      name: r'streak',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 17,
      name: r'text',
      type: IsarType.string,
    ),
    r'weeklyDays': PropertySchema(
      id: 18,
      name: r'weeklyDays',
      type: IsarType.longList,
    )
  },
  estimateSize: _scheduledTaskEstimateSize,
  serialize: _scheduledTaskSerialize,
  deserialize: _scheduledTaskDeserialize,
  deserializeProp: _scheduledTaskDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _scheduledTaskGetId,
  getLinks: _scheduledTaskGetLinks,
  attach: _scheduledTaskAttach,
  version: '3.1.0+1',
);

int _scheduledTaskEstimateSize(
  ScheduledTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  bytesCount += 3 + object.weeklyDays.length * 8;
  return bytesCount;
}

void _scheduledTaskSerialize(
  ScheduledTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dailyInterval);
  writer.writeByte(offsets[1], object.difficulty.index);
  writer.writeBool(offsets[2], object.isDone);
  writer.writeDateTime(offsets[3], object.lastCompletedDate);
  writer.writeDateTime(offsets[4], object.lastStreakDate);
  writer.writeLong(offsets[5], object.minutesBefore);
  writer.writeLong(offsets[6], object.monthlyDayOfMonth);
  writer.writeByte(offsets[7], object.monthlyOrdinal.index);
  writer.writeByte(offsets[8], object.monthlySubMode.index);
  writer.writeLong(offsets[9], object.monthlyWeekday);
  writer.writeString(offsets[10], object.note);
  writer.writeLong(offsets[11], object.notificationHour);
  writer.writeLong(offsets[12], object.notificationMinute);
  writer.writeByte(offsets[13], object.recurrenceType.index);
  writer.writeByte(offsets[14], object.reminderMode.index);
  writer.writeDateTime(offsets[15], object.scheduledDate);
  writer.writeLong(offsets[16], object.streak);
  writer.writeString(offsets[17], object.text);
  writer.writeLongList(offsets[18], object.weeklyDays);
}

ScheduledTask _scheduledTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScheduledTask();
  object.dailyInterval = reader.readLong(offsets[0]);
  object.difficulty =
      _ScheduledTaskdifficultyValueEnumMap[reader.readByteOrNull(offsets[1])] ??
          TaskDifficulty.easy;
  object.id = id;
  object.isDone = reader.readBool(offsets[2]);
  object.lastCompletedDate = reader.readDateTimeOrNull(offsets[3]);
  object.lastStreakDate = reader.readDateTimeOrNull(offsets[4]);
  object.minutesBefore = reader.readLong(offsets[5]);
  object.monthlyDayOfMonth = reader.readLongOrNull(offsets[6]);
  object.monthlyOrdinal = _ScheduledTaskmonthlyOrdinalValueEnumMap[
          reader.readByteOrNull(offsets[7])] ??
      MonthlyOrdinal.first;
  object.monthlySubMode = _ScheduledTaskmonthlySubModeValueEnumMap[
          reader.readByteOrNull(offsets[8])] ??
      MonthlySubMode.byDate;
  object.monthlyWeekday = reader.readLongOrNull(offsets[9]);
  object.note = reader.readStringOrNull(offsets[10]);
  object.notificationHour = reader.readLongOrNull(offsets[11]);
  object.notificationMinute = reader.readLongOrNull(offsets[12]);
  object.recurrenceType = _ScheduledTaskrecurrenceTypeValueEnumMap[
          reader.readByteOrNull(offsets[13])] ??
      RecurrenceType.daily;
  object.reminderMode = _ScheduledTaskreminderModeValueEnumMap[
          reader.readByteOrNull(offsets[14])] ??
      ReminderMode.none;
  object.scheduledDate = reader.readDateTimeOrNull(offsets[15]);
  object.streak = reader.readLong(offsets[16]);
  object.text = reader.readString(offsets[17]);
  object.weeklyDays = reader.readLongList(offsets[18]) ?? [];
  return object;
}

P _scheduledTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (_ScheduledTaskdifficultyValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TaskDifficulty.easy) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (_ScheduledTaskmonthlyOrdinalValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MonthlyOrdinal.first) as P;
    case 8:
      return (_ScheduledTaskmonthlySubModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MonthlySubMode.byDate) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (_ScheduledTaskrecurrenceTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RecurrenceType.daily) as P;
    case 14:
      return (_ScheduledTaskreminderModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ReminderMode.none) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ScheduledTaskdifficultyEnumValueMap = {
  'easy': 0,
  'medium': 1,
  'hard': 2,
};
const _ScheduledTaskdifficultyValueEnumMap = {
  0: TaskDifficulty.easy,
  1: TaskDifficulty.medium,
  2: TaskDifficulty.hard,
};
const _ScheduledTaskmonthlyOrdinalEnumValueMap = {
  'first': 0,
  'second': 1,
  'third': 2,
  'fourth': 3,
  'last': 4,
};
const _ScheduledTaskmonthlyOrdinalValueEnumMap = {
  0: MonthlyOrdinal.first,
  1: MonthlyOrdinal.second,
  2: MonthlyOrdinal.third,
  3: MonthlyOrdinal.fourth,
  4: MonthlyOrdinal.last,
};
const _ScheduledTaskmonthlySubModeEnumValueMap = {
  'byDate': 0,
  'byOrdinalWeekday': 1,
};
const _ScheduledTaskmonthlySubModeValueEnumMap = {
  0: MonthlySubMode.byDate,
  1: MonthlySubMode.byOrdinalWeekday,
};
const _ScheduledTaskrecurrenceTypeEnumValueMap = {
  'daily': 0,
  'weekly': 1,
  'monthly': 2,
};
const _ScheduledTaskrecurrenceTypeValueEnumMap = {
  0: RecurrenceType.daily,
  1: RecurrenceType.weekly,
  2: RecurrenceType.monthly,
};
const _ScheduledTaskreminderModeEnumValueMap = {
  'none': 0,
  'atTime': 1,
  'minutesBefore': 2,
  'both': 3,
};
const _ScheduledTaskreminderModeValueEnumMap = {
  0: ReminderMode.none,
  1: ReminderMode.atTime,
  2: ReminderMode.minutesBefore,
  3: ReminderMode.both,
};

Id _scheduledTaskGetId(ScheduledTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scheduledTaskGetLinks(ScheduledTask object) {
  return [];
}

void _scheduledTaskAttach(
    IsarCollection<dynamic> col, Id id, ScheduledTask object) {
  object.id = id;
}

extension ScheduledTaskQueryWhereSort
    on QueryBuilder<ScheduledTask, ScheduledTask, QWhere> {
  QueryBuilder<ScheduledTask, ScheduledTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScheduledTaskQueryWhere
    on QueryBuilder<ScheduledTask, ScheduledTask, QWhereClause> {
  QueryBuilder<ScheduledTask, ScheduledTask, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterWhereClause> idBetween(
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

extension ScheduledTaskQueryFilter
    on QueryBuilder<ScheduledTask, ScheduledTask, QFilterCondition> {
  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      dailyIntervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      dailyIntervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      dailyIntervalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      dailyIntervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      difficultyEqualTo(TaskDifficulty value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'difficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      difficultyGreaterThan(
    TaskDifficulty value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'difficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      difficultyLessThan(
    TaskDifficulty value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'difficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      difficultyBetween(
    TaskDifficulty lower,
    TaskDifficulty upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'difficulty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
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

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      isDoneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDone',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastCompletedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastCompletedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastCompletedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastCompletedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastCompletedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastCompletedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCompletedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastStreakDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastStreakDate',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastStreakDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastStreakDate',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastStreakDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastStreakDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastStreakDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastStreakDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastStreakDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastStreakDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      lastStreakDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastStreakDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      minutesBeforeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutesBefore',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      minutesBeforeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutesBefore',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      minutesBeforeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutesBefore',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      minutesBeforeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutesBefore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyDayOfMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'monthlyDayOfMonth',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyDayOfMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'monthlyDayOfMonth',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyDayOfMonthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyDayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyDayOfMonthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyDayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyDayOfMonthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyDayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyDayOfMonthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyDayOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyOrdinalEqualTo(MonthlyOrdinal value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyOrdinal',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyOrdinalGreaterThan(
    MonthlyOrdinal value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyOrdinal',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyOrdinalLessThan(
    MonthlyOrdinal value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyOrdinal',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyOrdinalBetween(
    MonthlyOrdinal lower,
    MonthlyOrdinal upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyOrdinal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlySubModeEqualTo(MonthlySubMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlySubMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlySubModeGreaterThan(
    MonthlySubMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlySubMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlySubModeLessThan(
    MonthlySubMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlySubMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlySubModeBetween(
    MonthlySubMode lower,
    MonthlySubMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlySubMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyWeekdayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'monthlyWeekday',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyWeekdayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'monthlyWeekday',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyWeekdayEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyWeekday',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyWeekdayGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyWeekday',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyWeekdayLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyWeekday',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      monthlyWeekdayBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyWeekday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notificationHour',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notificationHour',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationHourEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationHourGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationHourLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationHourBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationMinuteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notificationMinute',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationMinuteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notificationMinute',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationMinuteEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationMinuteGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationMinuteLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      notificationMinuteBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      recurrenceTypeEqualTo(RecurrenceType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceType',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      recurrenceTypeGreaterThan(
    RecurrenceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceType',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      recurrenceTypeLessThan(
    RecurrenceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceType',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      recurrenceTypeBetween(
    RecurrenceType lower,
    RecurrenceType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      reminderModeEqualTo(ReminderMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      reminderModeGreaterThan(
    ReminderMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      reminderModeLessThan(
    ReminderMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      reminderModeBetween(
    ReminderMode lower,
    ReminderMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      scheduledDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledDate',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      scheduledDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledDate',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      scheduledDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      scheduledDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      scheduledDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      scheduledDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      streakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streak',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      streakGreaterThan(
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

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      streakLessThan(
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

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      streakBetween(
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

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyDays',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyDays',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyDays',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklyDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklyDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklyDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklyDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklyDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterFilterCondition>
      weeklyDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklyDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ScheduledTaskQueryObject
    on QueryBuilder<ScheduledTask, ScheduledTask, QFilterCondition> {}

extension ScheduledTaskQueryLinks
    on QueryBuilder<ScheduledTask, ScheduledTask, QFilterCondition> {}

extension ScheduledTaskQuerySortBy
    on QueryBuilder<ScheduledTask, ScheduledTask, QSortBy> {
  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByDailyInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyInterval', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByDailyIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyInterval', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByIsDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByLastStreakDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByLastStreakDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMinutesBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesBefore', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMinutesBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesBefore', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlyDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyDayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlyDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyDayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlyOrdinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyOrdinal', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlyOrdinalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyOrdinal', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlySubMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySubMode', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlySubModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySubMode', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlyWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWeekday', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByMonthlyWeekdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWeekday', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByNotificationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationHour', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByNotificationHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationHour', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByNotificationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationMinute', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByNotificationMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationMinute', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByRecurrenceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceType', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByRecurrenceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceType', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByReminderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMode', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByReminderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMode', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      sortByScheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension ScheduledTaskQuerySortThenBy
    on QueryBuilder<ScheduledTask, ScheduledTask, QSortThenBy> {
  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByDailyInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyInterval', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByDailyIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyInterval', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByIsDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByLastStreakDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByLastStreakDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStreakDate', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMinutesBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesBefore', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMinutesBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesBefore', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlyDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyDayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlyDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyDayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlyOrdinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyOrdinal', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlyOrdinalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyOrdinal', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlySubMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySubMode', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlySubModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySubMode', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlyWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWeekday', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByMonthlyWeekdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWeekday', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByNotificationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationHour', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByNotificationHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationHour', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByNotificationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationMinute', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByNotificationMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationMinute', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByRecurrenceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceType', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByRecurrenceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceType', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByReminderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMode', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByReminderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMode', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy>
      thenByScheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension ScheduledTaskQueryWhereDistinct
    on QueryBuilder<ScheduledTask, ScheduledTask, QDistinct> {
  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByDailyInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyInterval');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct> distinctByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficulty');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct> distinctByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDone');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletedDate');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByLastStreakDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastStreakDate');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByMinutesBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutesBefore');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByMonthlyDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyDayOfMonth');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByMonthlyOrdinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyOrdinal');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByMonthlySubMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlySubMode');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByMonthlyWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyWeekday');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByNotificationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationHour');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByNotificationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationMinute');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByRecurrenceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceType');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByReminderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderMode');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct>
      distinctByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledDate');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct> distinctByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streak');
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduledTask, ScheduledTask, QDistinct> distinctByWeeklyDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyDays');
    });
  }
}

extension ScheduledTaskQueryProperty
    on QueryBuilder<ScheduledTask, ScheduledTask, QQueryProperty> {
  QueryBuilder<ScheduledTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScheduledTask, int, QQueryOperations> dailyIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyInterval');
    });
  }

  QueryBuilder<ScheduledTask, TaskDifficulty, QQueryOperations>
      difficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficulty');
    });
  }

  QueryBuilder<ScheduledTask, bool, QQueryOperations> isDoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDone');
    });
  }

  QueryBuilder<ScheduledTask, DateTime?, QQueryOperations>
      lastCompletedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletedDate');
    });
  }

  QueryBuilder<ScheduledTask, DateTime?, QQueryOperations>
      lastStreakDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastStreakDate');
    });
  }

  QueryBuilder<ScheduledTask, int, QQueryOperations> minutesBeforeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutesBefore');
    });
  }

  QueryBuilder<ScheduledTask, int?, QQueryOperations>
      monthlyDayOfMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyDayOfMonth');
    });
  }

  QueryBuilder<ScheduledTask, MonthlyOrdinal, QQueryOperations>
      monthlyOrdinalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyOrdinal');
    });
  }

  QueryBuilder<ScheduledTask, MonthlySubMode, QQueryOperations>
      monthlySubModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlySubMode');
    });
  }

  QueryBuilder<ScheduledTask, int?, QQueryOperations> monthlyWeekdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyWeekday');
    });
  }

  QueryBuilder<ScheduledTask, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<ScheduledTask, int?, QQueryOperations>
      notificationHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationHour');
    });
  }

  QueryBuilder<ScheduledTask, int?, QQueryOperations>
      notificationMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationMinute');
    });
  }

  QueryBuilder<ScheduledTask, RecurrenceType, QQueryOperations>
      recurrenceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceType');
    });
  }

  QueryBuilder<ScheduledTask, ReminderMode, QQueryOperations>
      reminderModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderMode');
    });
  }

  QueryBuilder<ScheduledTask, DateTime?, QQueryOperations>
      scheduledDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledDate');
    });
  }

  QueryBuilder<ScheduledTask, int, QQueryOperations> streakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streak');
    });
  }

  QueryBuilder<ScheduledTask, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<ScheduledTask, List<int>, QQueryOperations>
      weeklyDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyDays');
    });
  }
}
