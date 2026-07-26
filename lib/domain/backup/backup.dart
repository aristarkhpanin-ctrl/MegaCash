import 'dart:convert';

import '../models/bank.dart';
import '../models/category_weight.dart';
import '../models/monthly_offer.dart';
import '../models/payment_card.dart';
import '../models/selection.dart';

/// Снимок всех данных пользователя.
///
/// Данные живут только на устройстве и аккаунта нет, поэтому потеря
/// телефона означает потерю всего. Копия в файл — единственный способ
/// это пережить, и она должна быть человекочитаемой: чтобы через год
/// её можно было открыть и понять, что внутри, даже без приложения.
class Backup {
  const Backup({
    required this.banks,
    required this.cards,
    required this.offers,
    required this.selections,
    required this.weights,
    this.createdAt,
  });

  /// Версия формата. Растёт, когда меняется состав полей.
  static const int formatVersion = 1;

  final List<Bank> banks;
  final List<PaymentCard> cards;
  final List<MonthlyOffer> offers;
  final List<Selection> selections;
  final List<CategoryWeight> weights;
  final DateTime? createdAt;

  bool get isEmpty =>
      banks.isEmpty && cards.isEmpty && offers.isEmpty && selections.isEmpty;

  Map<String, dynamic> toJson() => {
        'version': formatVersion,
        'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
        'banks': [
          for (final b in banks)
            {'id': b.id, 'name': b.name, 'color': b.colorValue},
        ],
        'cards': [
          for (final c in cards)
            {
              'id': c.id,
              'bankId': c.bankId,
              'productName': c.productName,
              'baseRate': c.baseRate,
              'slotLimit': c.slotLimit,
            },
        ],
        'offers': [
          for (final o in offers)
            {
              'id': o.id,
              'cardId': o.cardId,
              'monthKey': o.monthKey,
              'categoryId': o.categoryId,
              'rate': o.rate,
              'source': o.source.name,
              'confidence': o.confidence,
              if (o.note != null) 'note': o.note,
            },
        ],
        'selections': [
          for (final s in selections)
            {
              'id': s.id,
              'cardId': s.cardId,
              'monthKey': s.monthKey,
              'categoryId': s.categoryId,
              'status': s.status.name,
            },
        ],
        'weights': [
          for (final w in weights)
            {'categoryId': w.categoryId, 'weight': w.weight},
        ],
      };

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// Разбирает копию. Возвращает null, если файл не годится: подсунуть
  /// вместо копии посторонний файл легко, и молча стереть по нему всё
  /// было бы худшим из возможных исходов.
  static Backup? decode(String raw) {
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;

      final version = json['version'];
      if (version is! int || version > formatVersion) return null;
      if (json['cards'] is! List || json['banks'] is! List) return null;

      return Backup(
        createdAt: DateTime.tryParse('${json['createdAt']}'),
        banks: [
          for (final b in json['banks'] as List)
            if (b is Map<String, dynamic> &&
                b['id'] is String &&
                b['name'] is String)
              Bank(
                id: b['id'] as String,
                name: b['name'] as String,
                colorValue: b['color'] is int ? b['color'] as int : 0xFF6B665C,
              ),
        ],
        cards: [
          for (final c in json['cards'] as List)
            if (c is Map<String, dynamic> &&
                c['id'] is String &&
                c['bankId'] is String)
              PaymentCard(
                id: c['id'] as String,
                bankId: c['bankId'] as String,
                productName: '${c['productName'] ?? 'Карта'}',
                baseRate: _toDouble(c['baseRate']),
                slotLimit: c['slotLimit'] is int ? c['slotLimit'] as int : 3,
              ),
        ],
        offers: [
          for (final o in _listOf(json['offers']))
            if (o['id'] is String && o['cardId'] is String)
              MonthlyOffer(
                id: o['id'] as String,
                cardId: o['cardId'] as String,
                monthKey: '${o['monthKey']}',
                categoryId: '${o['categoryId']}',
                rate: _toDouble(o['rate']),
                source: o['source'] == 'ocr'
                    ? OfferSource.ocr
                    : OfferSource.manual,
                confidence: _toDouble(o['confidence'], orElse: 1),
                note: o['note'] as String?,
              ),
        ],
        selections: [
          for (final s in _listOf(json['selections']))
            if (s['id'] is String && s['cardId'] is String)
              Selection(
                id: s['id'] as String,
                cardId: s['cardId'] as String,
                monthKey: '${s['monthKey']}',
                categoryId: '${s['categoryId']}',
                status: switch (s['status']) {
                  'activated' => SelectionStatus.activated,
                  'userChosen' => SelectionStatus.userChosen,
                  _ => SelectionStatus.recommended,
                },
              ),
        ],
        weights: [
          for (final w in _listOf(json['weights']))
            if (w['categoryId'] is String)
              CategoryWeight(
                categoryId: w['categoryId'] as String,
                weight: _toDouble(w['weight'], orElse: 1),
              ),
        ],
      );
    } on Object {
      return null;
    }
  }

  static List<Map<String, dynamic>> _listOf(Object? value) => [
        if (value is List)
          for (final item in value)
            if (item is Map<String, dynamic>) item,
      ];

  static double _toDouble(Object? value, {double orElse = 0}) =>
      value is num ? value.toDouble() : orElse;
}
