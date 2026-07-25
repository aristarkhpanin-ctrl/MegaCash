// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBankEntityCollection on Isar {
  IsarCollection<BankEntity> get bankEntitys => this.collection();
}

const BankEntitySchema = CollectionSchema(
  name: r'BankEntity',
  id: -7427048786906927959,
  properties: {
    r'colorValue': PropertySchema(
      id: 0,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'uid': PropertySchema(id: 2, name: r'uid', type: IsarType.string),
  },

  estimateSize: _bankEntityEstimateSize,
  serialize: _bankEntitySerialize,
  deserialize: _bankEntityDeserialize,
  deserializeProp: _bankEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _bankEntityGetId,
  getLinks: _bankEntityGetLinks,
  attach: _bankEntityAttach,
  version: '3.3.2',
);

int _bankEntityEstimateSize(
  BankEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _bankEntitySerialize(
  BankEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.colorValue);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.uid);
}

BankEntity _bankEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BankEntity();
  object.colorValue = reader.readLong(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.uid = reader.readString(offsets[2]);
  return object;
}

P _bankEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bankEntityGetId(BankEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bankEntityGetLinks(BankEntity object) {
  return [];
}

void _bankEntityAttach(IsarCollection<dynamic> col, Id id, BankEntity object) {
  object.id = id;
}

extension BankEntityByIndex on IsarCollection<BankEntity> {
  Future<BankEntity?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  BankEntity? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<BankEntity?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<BankEntity?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(BankEntity object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(BankEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<BankEntity> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<BankEntity> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension BankEntityQueryWhereSort
    on QueryBuilder<BankEntity, BankEntity, QWhere> {
  QueryBuilder<BankEntity, BankEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BankEntityQueryWhere
    on QueryBuilder<BankEntity, BankEntity, QWhereClause> {
  QueryBuilder<BankEntity, BankEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BankEntity, BankEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterWhereClause> uidEqualTo(
    String uid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uid', value: [uid]),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterWhereClause> uidNotEqualTo(
    String uid,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension BankEntityQueryFilter
    on QueryBuilder<BankEntity, BankEntity, QFilterCondition> {
  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> colorValueEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorValue', value: value),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition>
  colorValueGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition>
  colorValueLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uid', value: ''),
      );
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uid', value: ''),
      );
    });
  }
}

extension BankEntityQueryObject
    on QueryBuilder<BankEntity, BankEntity, QFilterCondition> {}

extension BankEntityQueryLinks
    on QueryBuilder<BankEntity, BankEntity, QFilterCondition> {}

extension BankEntityQuerySortBy
    on QueryBuilder<BankEntity, BankEntity, QSortBy> {
  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension BankEntityQuerySortThenBy
    on QueryBuilder<BankEntity, BankEntity, QSortThenBy> {
  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension BankEntityQueryWhereDistinct
    on QueryBuilder<BankEntity, BankEntity, QDistinct> {
  QueryBuilder<BankEntity, BankEntity, QDistinct> distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<BankEntity, BankEntity, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BankEntity, BankEntity, QDistinct> distinctByUid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension BankEntityQueryProperty
    on QueryBuilder<BankEntity, BankEntity, QQueryProperty> {
  QueryBuilder<BankEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BankEntity, int, QQueryOperations> colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<BankEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<BankEntity, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCardEntityCollection on Isar {
  IsarCollection<CardEntity> get cardEntitys => this.collection();
}

const CardEntitySchema = CollectionSchema(
  name: r'CardEntity',
  id: 8921433643831792852,
  properties: {
    r'bankId': PropertySchema(id: 0, name: r'bankId', type: IsarType.string),
    r'baseRate': PropertySchema(
      id: 1,
      name: r'baseRate',
      type: IsarType.double,
    ),
    r'productName': PropertySchema(
      id: 2,
      name: r'productName',
      type: IsarType.string,
    ),
    r'slotLimit': PropertySchema(
      id: 3,
      name: r'slotLimit',
      type: IsarType.long,
    ),
    r'uid': PropertySchema(id: 4, name: r'uid', type: IsarType.string),
  },

  estimateSize: _cardEntityEstimateSize,
  serialize: _cardEntitySerialize,
  deserialize: _cardEntityDeserialize,
  deserializeProp: _cardEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'bankId': IndexSchema(
      id: 4297861765917079002,
      name: r'bankId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bankId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _cardEntityGetId,
  getLinks: _cardEntityGetLinks,
  attach: _cardEntityAttach,
  version: '3.3.2',
);

int _cardEntityEstimateSize(
  CardEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bankId.length * 3;
  bytesCount += 3 + object.productName.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _cardEntitySerialize(
  CardEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bankId);
  writer.writeDouble(offsets[1], object.baseRate);
  writer.writeString(offsets[2], object.productName);
  writer.writeLong(offsets[3], object.slotLimit);
  writer.writeString(offsets[4], object.uid);
}

CardEntity _cardEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardEntity();
  object.bankId = reader.readString(offsets[0]);
  object.baseRate = reader.readDouble(offsets[1]);
  object.id = id;
  object.productName = reader.readString(offsets[2]);
  object.slotLimit = reader.readLong(offsets[3]);
  object.uid = reader.readString(offsets[4]);
  return object;
}

P _cardEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cardEntityGetId(CardEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cardEntityGetLinks(CardEntity object) {
  return [];
}

void _cardEntityAttach(IsarCollection<dynamic> col, Id id, CardEntity object) {
  object.id = id;
}

extension CardEntityByIndex on IsarCollection<CardEntity> {
  Future<CardEntity?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  CardEntity? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<CardEntity?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<CardEntity?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(CardEntity object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(CardEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<CardEntity> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<CardEntity> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension CardEntityQueryWhereSort
    on QueryBuilder<CardEntity, CardEntity, QWhere> {
  QueryBuilder<CardEntity, CardEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CardEntityQueryWhere
    on QueryBuilder<CardEntity, CardEntity, QWhereClause> {
  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> uidEqualTo(
    String uid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uid', value: [uid]),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> uidNotEqualTo(
    String uid,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> bankIdEqualTo(
    String bankId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'bankId', value: [bankId]),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterWhereClause> bankIdNotEqualTo(
    String bankId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bankId',
                lower: [],
                upper: [bankId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bankId',
                lower: [bankId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bankId',
                lower: [bankId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bankId',
                lower: [],
                upper: [bankId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CardEntityQueryFilter
    on QueryBuilder<CardEntity, CardEntity, QFilterCondition> {
  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bankId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bankId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bankId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bankId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bankId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bankId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bankId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bankId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> bankIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bankId', value: ''),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  bankIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bankId', value: ''),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> baseRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baseRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  baseRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> baseRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> baseRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'productName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'productName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'productName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'productName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'productName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'productName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'productName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'productName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'productName', value: ''),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'productName', value: ''),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> slotLimitEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'slotLimit', value: value),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition>
  slotLimitGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'slotLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> slotLimitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'slotLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> slotLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'slotLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uid', value: ''),
      );
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uid', value: ''),
      );
    });
  }
}

extension CardEntityQueryObject
    on QueryBuilder<CardEntity, CardEntity, QFilterCondition> {}

extension CardEntityQueryLinks
    on QueryBuilder<CardEntity, CardEntity, QFilterCondition> {}

extension CardEntityQuerySortBy
    on QueryBuilder<CardEntity, CardEntity, QSortBy> {
  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByBankId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankId', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByBankIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankId', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByBaseRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRate', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByBaseRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRate', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortBySlotLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotLimit', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortBySlotLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotLimit', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension CardEntityQuerySortThenBy
    on QueryBuilder<CardEntity, CardEntity, QSortThenBy> {
  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByBankId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankId', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByBankIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankId', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByBaseRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRate', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByBaseRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRate', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenBySlotLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotLimit', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenBySlotLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotLimit', Sort.desc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension CardEntityQueryWhereDistinct
    on QueryBuilder<CardEntity, CardEntity, QDistinct> {
  QueryBuilder<CardEntity, CardEntity, QDistinct> distinctByBankId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QDistinct> distinctByBaseRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseRate');
    });
  }

  QueryBuilder<CardEntity, CardEntity, QDistinct> distinctByProductName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardEntity, CardEntity, QDistinct> distinctBySlotLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slotLimit');
    });
  }

  QueryBuilder<CardEntity, CardEntity, QDistinct> distinctByUid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension CardEntityQueryProperty
    on QueryBuilder<CardEntity, CardEntity, QQueryProperty> {
  QueryBuilder<CardEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CardEntity, String, QQueryOperations> bankIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankId');
    });
  }

  QueryBuilder<CardEntity, double, QQueryOperations> baseRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseRate');
    });
  }

  QueryBuilder<CardEntity, String, QQueryOperations> productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productName');
    });
  }

  QueryBuilder<CardEntity, int, QQueryOperations> slotLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slotLimit');
    });
  }

  QueryBuilder<CardEntity, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOfferEntityCollection on Isar {
  IsarCollection<OfferEntity> get offerEntitys => this.collection();
}

const OfferEntitySchema = CollectionSchema(
  name: r'OfferEntity',
  id: 3403297649535041640,
  properties: {
    r'cardId': PropertySchema(id: 0, name: r'cardId', type: IsarType.string),
    r'categoryId': PropertySchema(
      id: 1,
      name: r'categoryId',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 2,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'monthKey': PropertySchema(
      id: 3,
      name: r'monthKey',
      type: IsarType.string,
    ),
    r'rate': PropertySchema(id: 4, name: r'rate', type: IsarType.double),
    r'source': PropertySchema(
      id: 5,
      name: r'source',
      type: IsarType.byte,
      enumMap: _OfferEntitysourceEnumValueMap,
    ),
    r'uid': PropertySchema(id: 6, name: r'uid', type: IsarType.string),
  },

  estimateSize: _offerEntityEstimateSize,
  serialize: _offerEntitySerialize,
  deserialize: _offerEntityDeserialize,
  deserializeProp: _offerEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'monthKey_cardId': IndexSchema(
      id: 6661902317864911661,
      name: r'monthKey_cardId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'monthKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'cardId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _offerEntityGetId,
  getLinks: _offerEntityGetLinks,
  attach: _offerEntityAttach,
  version: '3.3.2',
);

int _offerEntityEstimateSize(
  OfferEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cardId.length * 3;
  bytesCount += 3 + object.categoryId.length * 3;
  bytesCount += 3 + object.monthKey.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _offerEntitySerialize(
  OfferEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cardId);
  writer.writeString(offsets[1], object.categoryId);
  writer.writeDouble(offsets[2], object.confidence);
  writer.writeString(offsets[3], object.monthKey);
  writer.writeDouble(offsets[4], object.rate);
  writer.writeByte(offsets[5], object.source.index);
  writer.writeString(offsets[6], object.uid);
}

OfferEntity _offerEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OfferEntity();
  object.cardId = reader.readString(offsets[0]);
  object.categoryId = reader.readString(offsets[1]);
  object.confidence = reader.readDouble(offsets[2]);
  object.id = id;
  object.monthKey = reader.readString(offsets[3]);
  object.rate = reader.readDouble(offsets[4]);
  object.source =
      _OfferEntitysourceValueEnumMap[reader.readByteOrNull(offsets[5])] ??
      OfferSource.ocr;
  object.uid = reader.readString(offsets[6]);
  return object;
}

P _offerEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (_OfferEntitysourceValueEnumMap[reader.readByteOrNull(offset)] ??
              OfferSource.ocr)
          as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _OfferEntitysourceEnumValueMap = {'ocr': 0, 'manual': 1};
const _OfferEntitysourceValueEnumMap = {
  0: OfferSource.ocr,
  1: OfferSource.manual,
};

Id _offerEntityGetId(OfferEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _offerEntityGetLinks(OfferEntity object) {
  return [];
}

void _offerEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  OfferEntity object,
) {
  object.id = id;
}

extension OfferEntityByIndex on IsarCollection<OfferEntity> {
  Future<OfferEntity?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  OfferEntity? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<OfferEntity?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<OfferEntity?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(OfferEntity object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(OfferEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<OfferEntity> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<OfferEntity> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension OfferEntityQueryWhereSort
    on QueryBuilder<OfferEntity, OfferEntity, QWhere> {
  QueryBuilder<OfferEntity, OfferEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OfferEntityQueryWhere
    on QueryBuilder<OfferEntity, OfferEntity, QWhereClause> {
  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause> uidEqualTo(
    String uid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uid', value: [uid]),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause> uidNotEqualTo(
    String uid,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause>
  monthKeyEqualToAnyCardId(String monthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'monthKey_cardId',
          value: [monthKey],
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause>
  monthKeyNotEqualToAnyCardId(String monthKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [],
                upper: [monthKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [],
                upper: [monthKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause>
  monthKeyCardIdEqualTo(String monthKey, String cardId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'monthKey_cardId',
          value: [monthKey, cardId],
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterWhereClause>
  monthKeyEqualToCardIdNotEqualTo(String monthKey, String cardId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                upper: [monthKey, cardId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey, cardId],
                includeLower: false,
                upper: [monthKey],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey, cardId],
                includeLower: false,
                upper: [monthKey],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                upper: [monthKey, cardId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension OfferEntityQueryFilter
    on QueryBuilder<OfferEntity, OfferEntity, QFilterCondition> {
  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> cardIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  cardIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> cardIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> cardIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cardId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  cardIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> cardIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> cardIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> cardIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cardId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  cardIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cardId', value: ''),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  cardIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cardId', value: ''),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categoryId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  categoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  confidenceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'confidence',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  confidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'confidence',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  confidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'confidence',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  confidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'confidence',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> monthKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  monthKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  monthKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> monthKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  monthKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  monthKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  monthKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> monthKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'monthKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  monthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'monthKey', value: ''),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  monthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'monthKey', value: ''),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> rateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> rateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> rateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> rateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> sourceEqualTo(
    OfferSource value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: value),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  sourceGreaterThan(OfferSource value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'source',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> sourceLessThan(
    OfferSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'source',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> sourceBetween(
    OfferSource lower,
    OfferSource upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'source',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uid', value: ''),
      );
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterFilterCondition>
  uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uid', value: ''),
      );
    });
  }
}

extension OfferEntityQueryObject
    on QueryBuilder<OfferEntity, OfferEntity, QFilterCondition> {}

extension OfferEntityQueryLinks
    on QueryBuilder<OfferEntity, OfferEntity, QFilterCondition> {}

extension OfferEntityQuerySortBy
    on QueryBuilder<OfferEntity, OfferEntity, QSortBy> {
  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension OfferEntityQuerySortThenBy
    on QueryBuilder<OfferEntity, OfferEntity, QSortThenBy> {
  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension OfferEntityQueryWhereDistinct
    on QueryBuilder<OfferEntity, OfferEntity, QDistinct> {
  QueryBuilder<OfferEntity, OfferEntity, QDistinct> distinctByCardId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QDistinct> distinctByCategoryId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QDistinct> distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QDistinct> distinctByMonthKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QDistinct> distinctByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rate');
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QDistinct> distinctBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source');
    });
  }

  QueryBuilder<OfferEntity, OfferEntity, QDistinct> distinctByUid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension OfferEntityQueryProperty
    on QueryBuilder<OfferEntity, OfferEntity, QQueryProperty> {
  QueryBuilder<OfferEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OfferEntity, String, QQueryOperations> cardIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardId');
    });
  }

  QueryBuilder<OfferEntity, String, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<OfferEntity, double, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<OfferEntity, String, QQueryOperations> monthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthKey');
    });
  }

  QueryBuilder<OfferEntity, double, QQueryOperations> rateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rate');
    });
  }

  QueryBuilder<OfferEntity, OfferSource, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<OfferEntity, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSelectionEntityCollection on Isar {
  IsarCollection<SelectionEntity> get selectionEntitys => this.collection();
}

const SelectionEntitySchema = CollectionSchema(
  name: r'SelectionEntity',
  id: -950349139151539942,
  properties: {
    r'cardId': PropertySchema(id: 0, name: r'cardId', type: IsarType.string),
    r'categoryId': PropertySchema(
      id: 1,
      name: r'categoryId',
      type: IsarType.string,
    ),
    r'monthKey': PropertySchema(
      id: 2,
      name: r'monthKey',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 3,
      name: r'status',
      type: IsarType.byte,
      enumMap: _SelectionEntitystatusEnumValueMap,
    ),
    r'uid': PropertySchema(id: 4, name: r'uid', type: IsarType.string),
  },

  estimateSize: _selectionEntityEstimateSize,
  serialize: _selectionEntitySerialize,
  deserialize: _selectionEntityDeserialize,
  deserializeProp: _selectionEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'monthKey_cardId': IndexSchema(
      id: 6661902317864911661,
      name: r'monthKey_cardId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'monthKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'cardId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _selectionEntityGetId,
  getLinks: _selectionEntityGetLinks,
  attach: _selectionEntityAttach,
  version: '3.3.2',
);

int _selectionEntityEstimateSize(
  SelectionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cardId.length * 3;
  bytesCount += 3 + object.categoryId.length * 3;
  bytesCount += 3 + object.monthKey.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _selectionEntitySerialize(
  SelectionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cardId);
  writer.writeString(offsets[1], object.categoryId);
  writer.writeString(offsets[2], object.monthKey);
  writer.writeByte(offsets[3], object.status.index);
  writer.writeString(offsets[4], object.uid);
}

SelectionEntity _selectionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SelectionEntity();
  object.cardId = reader.readString(offsets[0]);
  object.categoryId = reader.readString(offsets[1]);
  object.id = id;
  object.monthKey = reader.readString(offsets[2]);
  object.status =
      _SelectionEntitystatusValueEnumMap[reader.readByteOrNull(offsets[3])] ??
      SelectionStatus.recommended;
  object.uid = reader.readString(offsets[4]);
  return object;
}

P _selectionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_SelectionEntitystatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              SelectionStatus.recommended)
          as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SelectionEntitystatusEnumValueMap = {
  'recommended': 0,
  'userChosen': 1,
  'activated': 2,
};
const _SelectionEntitystatusValueEnumMap = {
  0: SelectionStatus.recommended,
  1: SelectionStatus.userChosen,
  2: SelectionStatus.activated,
};

Id _selectionEntityGetId(SelectionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _selectionEntityGetLinks(SelectionEntity object) {
  return [];
}

void _selectionEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  SelectionEntity object,
) {
  object.id = id;
}

extension SelectionEntityByIndex on IsarCollection<SelectionEntity> {
  Future<SelectionEntity?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  SelectionEntity? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<SelectionEntity?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<SelectionEntity?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(SelectionEntity object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(SelectionEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<SelectionEntity> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(
    List<SelectionEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension SelectionEntityQueryWhereSort
    on QueryBuilder<SelectionEntity, SelectionEntity, QWhere> {
  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SelectionEntityQueryWhere
    on QueryBuilder<SelectionEntity, SelectionEntity, QWhereClause> {
  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause>
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

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause> uidEqualTo(
    String uid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uid', value: [uid]),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause>
  uidNotEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause>
  monthKeyEqualToAnyCardId(String monthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'monthKey_cardId',
          value: [monthKey],
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause>
  monthKeyNotEqualToAnyCardId(String monthKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [],
                upper: [monthKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [],
                upper: [monthKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause>
  monthKeyCardIdEqualTo(String monthKey, String cardId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'monthKey_cardId',
          value: [monthKey, cardId],
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterWhereClause>
  monthKeyEqualToCardIdNotEqualTo(String monthKey, String cardId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                upper: [monthKey, cardId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey, cardId],
                includeLower: false,
                upper: [monthKey],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey, cardId],
                includeLower: false,
                upper: [monthKey],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthKey_cardId',
                lower: [monthKey],
                upper: [monthKey, cardId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension SelectionEntityQueryFilter
    on QueryBuilder<SelectionEntity, SelectionEntity, QFilterCondition> {
  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cardId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cardId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cardId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cardId', value: ''),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  cardIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cardId', value: ''),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categoryId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  categoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'monthKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'monthKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'monthKey', value: ''),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  monthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'monthKey', value: ''),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  statusEqualTo(SelectionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  statusGreaterThan(SelectionStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  statusLessThan(SelectionStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  statusBetween(
    SelectionStatus lower,
    SelectionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uid', value: ''),
      );
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterFilterCondition>
  uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uid', value: ''),
      );
    });
  }
}

extension SelectionEntityQueryObject
    on QueryBuilder<SelectionEntity, SelectionEntity, QFilterCondition> {}

extension SelectionEntityQueryLinks
    on QueryBuilder<SelectionEntity, SelectionEntity, QFilterCondition> {}

extension SelectionEntityQuerySortBy
    on QueryBuilder<SelectionEntity, SelectionEntity, QSortBy> {
  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> sortByCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  sortByCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  sortByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  sortByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension SelectionEntityQuerySortThenBy
    on QueryBuilder<SelectionEntity, SelectionEntity, QSortThenBy> {
  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> thenByCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  thenByCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardId', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  thenByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  thenByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension SelectionEntityQueryWhereDistinct
    on QueryBuilder<SelectionEntity, SelectionEntity, QDistinct> {
  QueryBuilder<SelectionEntity, SelectionEntity, QDistinct> distinctByCardId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QDistinct>
  distinctByCategoryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QDistinct> distinctByMonthKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<SelectionEntity, SelectionEntity, QDistinct> distinctByUid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension SelectionEntityQueryProperty
    on QueryBuilder<SelectionEntity, SelectionEntity, QQueryProperty> {
  QueryBuilder<SelectionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SelectionEntity, String, QQueryOperations> cardIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardId');
    });
  }

  QueryBuilder<SelectionEntity, String, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<SelectionEntity, String, QQueryOperations> monthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthKey');
    });
  }

  QueryBuilder<SelectionEntity, SelectionStatus, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SelectionEntity, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeightEntityCollection on Isar {
  IsarCollection<WeightEntity> get weightEntitys => this.collection();
}

const WeightEntitySchema = CollectionSchema(
  name: r'WeightEntity',
  id: 4584121349466144012,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.string,
    ),
    r'weight': PropertySchema(id: 1, name: r'weight', type: IsarType.double),
  },

  estimateSize: _weightEntityEstimateSize,
  serialize: _weightEntitySerialize,
  deserialize: _weightEntityDeserialize,
  deserializeProp: _weightEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'categoryId': IndexSchema(
      id: -8798048739239305339,
      name: r'categoryId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'categoryId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _weightEntityGetId,
  getLinks: _weightEntityGetLinks,
  attach: _weightEntityAttach,
  version: '3.3.2',
);

int _weightEntityEstimateSize(
  WeightEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryId.length * 3;
  return bytesCount;
}

void _weightEntitySerialize(
  WeightEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryId);
  writer.writeDouble(offsets[1], object.weight);
}

WeightEntity _weightEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeightEntity();
  object.categoryId = reader.readString(offsets[0]);
  object.id = id;
  object.weight = reader.readDouble(offsets[1]);
  return object;
}

P _weightEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weightEntityGetId(WeightEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weightEntityGetLinks(WeightEntity object) {
  return [];
}

void _weightEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  WeightEntity object,
) {
  object.id = id;
}

extension WeightEntityByIndex on IsarCollection<WeightEntity> {
  Future<WeightEntity?> getByCategoryId(String categoryId) {
    return getByIndex(r'categoryId', [categoryId]);
  }

  WeightEntity? getByCategoryIdSync(String categoryId) {
    return getByIndexSync(r'categoryId', [categoryId]);
  }

  Future<bool> deleteByCategoryId(String categoryId) {
    return deleteByIndex(r'categoryId', [categoryId]);
  }

  bool deleteByCategoryIdSync(String categoryId) {
    return deleteByIndexSync(r'categoryId', [categoryId]);
  }

  Future<List<WeightEntity?>> getAllByCategoryId(
    List<String> categoryIdValues,
  ) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'categoryId', values);
  }

  List<WeightEntity?> getAllByCategoryIdSync(List<String> categoryIdValues) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'categoryId', values);
  }

  Future<int> deleteAllByCategoryId(List<String> categoryIdValues) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'categoryId', values);
  }

  int deleteAllByCategoryIdSync(List<String> categoryIdValues) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'categoryId', values);
  }

  Future<Id> putByCategoryId(WeightEntity object) {
    return putByIndex(r'categoryId', object);
  }

  Id putByCategoryIdSync(WeightEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'categoryId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCategoryId(List<WeightEntity> objects) {
    return putAllByIndex(r'categoryId', objects);
  }

  List<Id> putAllByCategoryIdSync(
    List<WeightEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'categoryId', objects, saveLinks: saveLinks);
  }
}

extension WeightEntityQueryWhereSort
    on QueryBuilder<WeightEntity, WeightEntity, QWhere> {
  QueryBuilder<WeightEntity, WeightEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WeightEntityQueryWhere
    on QueryBuilder<WeightEntity, WeightEntity, QWhereClause> {
  QueryBuilder<WeightEntity, WeightEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<WeightEntity, WeightEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterWhereClause> categoryIdEqualTo(
    String categoryId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'categoryId', value: [categoryId]),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterWhereClause>
  categoryIdNotEqualTo(String categoryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [],
                upper: [categoryId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [categoryId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [categoryId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [],
                upper: [categoryId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension WeightEntityQueryFilter
    on QueryBuilder<WeightEntity, WeightEntity, QFilterCondition> {
  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categoryId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  categoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition> weightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  weightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition>
  weightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterFilterCondition> weightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weight',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension WeightEntityQueryObject
    on QueryBuilder<WeightEntity, WeightEntity, QFilterCondition> {}

extension WeightEntityQueryLinks
    on QueryBuilder<WeightEntity, WeightEntity, QFilterCondition> {}

extension WeightEntityQuerySortBy
    on QueryBuilder<WeightEntity, WeightEntity, QSortBy> {
  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy>
  sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension WeightEntityQuerySortThenBy
    on QueryBuilder<WeightEntity, WeightEntity, QSortThenBy> {
  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy>
  thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QAfterSortBy> thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension WeightEntityQueryWhereDistinct
    on QueryBuilder<WeightEntity, WeightEntity, QDistinct> {
  QueryBuilder<WeightEntity, WeightEntity, QDistinct> distinctByCategoryId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeightEntity, WeightEntity, QDistinct> distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }
}

extension WeightEntityQueryProperty
    on QueryBuilder<WeightEntity, WeightEntity, QQueryProperty> {
  QueryBuilder<WeightEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeightEntity, String, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<WeightEntity, double, QQueryOperations> weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecognitionLogEntityCollection on Isar {
  IsarCollection<RecognitionLogEntity> get recognitionLogEntitys =>
      this.collection();
}

const RecognitionLogEntitySchema = CollectionSchema(
  name: r'RecognitionLogEntity',
  id: 7343507993209165252,
  properties: {
    r'at': PropertySchema(id: 0, name: r'at', type: IsarType.dateTime),
    r'foundCount': PropertySchema(
      id: 1,
      name: r'foundCount',
      type: IsarType.long,
    ),
    r'rawText': PropertySchema(id: 2, name: r'rawText', type: IsarType.string),
    r'uid': PropertySchema(id: 3, name: r'uid', type: IsarType.string),
    r'unmatchedStrings': PropertySchema(
      id: 4,
      name: r'unmatchedStrings',
      type: IsarType.stringList,
    ),
  },

  estimateSize: _recognitionLogEntityEstimateSize,
  serialize: _recognitionLogEntitySerialize,
  deserialize: _recognitionLogEntityDeserialize,
  deserializeProp: _recognitionLogEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _recognitionLogEntityGetId,
  getLinks: _recognitionLogEntityGetLinks,
  attach: _recognitionLogEntityAttach,
  version: '3.3.2',
);

int _recognitionLogEntityEstimateSize(
  RecognitionLogEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.rawText.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  bytesCount += 3 + object.unmatchedStrings.length * 3;
  {
    for (var i = 0; i < object.unmatchedStrings.length; i++) {
      final value = object.unmatchedStrings[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _recognitionLogEntitySerialize(
  RecognitionLogEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.at);
  writer.writeLong(offsets[1], object.foundCount);
  writer.writeString(offsets[2], object.rawText);
  writer.writeString(offsets[3], object.uid);
  writer.writeStringList(offsets[4], object.unmatchedStrings);
}

RecognitionLogEntity _recognitionLogEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecognitionLogEntity();
  object.at = reader.readDateTime(offsets[0]);
  object.foundCount = reader.readLong(offsets[1]);
  object.id = id;
  object.rawText = reader.readString(offsets[2]);
  object.uid = reader.readString(offsets[3]);
  object.unmatchedStrings = reader.readStringList(offsets[4]) ?? [];
  return object;
}

P _recognitionLogEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recognitionLogEntityGetId(RecognitionLogEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recognitionLogEntityGetLinks(
  RecognitionLogEntity object,
) {
  return [];
}

void _recognitionLogEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  RecognitionLogEntity object,
) {
  object.id = id;
}

extension RecognitionLogEntityByIndex on IsarCollection<RecognitionLogEntity> {
  Future<RecognitionLogEntity?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  RecognitionLogEntity? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<RecognitionLogEntity?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<RecognitionLogEntity?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(RecognitionLogEntity object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(RecognitionLogEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<RecognitionLogEntity> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(
    List<RecognitionLogEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension RecognitionLogEntityQueryWhereSort
    on QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QWhere> {
  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecognitionLogEntityQueryWhere
    on QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QWhereClause> {
  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhereClause>
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

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhereClause>
  uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uid', value: [uid]),
      );
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterWhereClause>
  uidNotEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [uid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uid',
                lower: [],
                upper: [uid],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension RecognitionLogEntityQueryFilter
    on
        QueryBuilder<
          RecognitionLogEntity,
          RecognitionLogEntity,
          QFilterCondition
        > {
  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  atEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'at', value: value),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  atGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'at',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  atLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'at',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  atBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'at',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  foundCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'foundCount', value: value),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  foundCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'foundCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  foundCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'foundCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  foundCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'foundCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rawText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rawText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rawText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rawText',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rawText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rawText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rawText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rawText',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rawText', value: ''),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  rawTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rawText', value: ''),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uid', value: ''),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uid', value: ''),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unmatchedStrings',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unmatchedStrings',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unmatchedStrings',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unmatchedStrings',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'unmatchedStrings',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'unmatchedStrings',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'unmatchedStrings',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'unmatchedStrings',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unmatchedStrings', value: ''),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'unmatchedStrings', value: ''),
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unmatchedStrings', length, true, length, true);
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unmatchedStrings', 0, true, 0, true);
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unmatchedStrings', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unmatchedStrings', 0, true, length, include);
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unmatchedStrings',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    RecognitionLogEntity,
    RecognitionLogEntity,
    QAfterFilterCondition
  >
  unmatchedStringsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unmatchedStrings',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension RecognitionLogEntityQueryObject
    on
        QueryBuilder<
          RecognitionLogEntity,
          RecognitionLogEntity,
          QFilterCondition
        > {}

extension RecognitionLogEntityQueryLinks
    on
        QueryBuilder<
          RecognitionLogEntity,
          RecognitionLogEntity,
          QFilterCondition
        > {}

extension RecognitionLogEntityQuerySortBy
    on QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QSortBy> {
  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByFoundCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foundCount', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByFoundCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foundCount', Sort.desc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByRawText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawText', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByRawTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawText', Sort.desc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension RecognitionLogEntityQuerySortThenBy
    on QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QSortThenBy> {
  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByFoundCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foundCount', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByFoundCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foundCount', Sort.desc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByRawText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawText', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByRawTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawText', Sort.desc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QAfterSortBy>
  thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension RecognitionLogEntityQueryWhereDistinct
    on QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QDistinct> {
  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QDistinct>
  distinctByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'at');
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QDistinct>
  distinctByFoundCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foundCount');
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QDistinct>
  distinctByRawText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QDistinct>
  distinctByUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecognitionLogEntity, RecognitionLogEntity, QDistinct>
  distinctByUnmatchedStrings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unmatchedStrings');
    });
  }
}

extension RecognitionLogEntityQueryProperty
    on
        QueryBuilder<
          RecognitionLogEntity,
          RecognitionLogEntity,
          QQueryProperty
        > {
  QueryBuilder<RecognitionLogEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecognitionLogEntity, DateTime, QQueryOperations> atProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'at');
    });
  }

  QueryBuilder<RecognitionLogEntity, int, QQueryOperations>
  foundCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foundCount');
    });
  }

  QueryBuilder<RecognitionLogEntity, String, QQueryOperations>
  rawTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawText');
    });
  }

  QueryBuilder<RecognitionLogEntity, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }

  QueryBuilder<RecognitionLogEntity, List<String>, QQueryOperations>
  unmatchedStringsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unmatchedStrings');
    });
  }
}
