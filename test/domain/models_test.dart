import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/core/utils/formatters.dart';
import 'package:megacash/domain/models/category_weight.dart';
import 'package:megacash/domain/models/month_key.dart';

void main() {
  group('MonthKey', () {
    test('формирует ключ с ведущим нулём', () {
      expect(MonthKey.of(DateTime(2026, 7, 15)), '2026-07');
      expect(MonthKey.of(DateTime(2026, 12)), '2026-12');
    });

    test('ключи сравниваются как строки в хронологическом порядке', () {
      final keys = ['2026-12', '2026-02', '2025-11', '2026-07']..sort();
      expect(keys, ['2025-11', '2026-02', '2026-07', '2026-12']);
    });

    test('разбирает ключ и отвергает мусор', () {
      expect(MonthKey.parse('2026-07'), DateTime(2026, 7));
      expect(MonthKey.parse('2026-13'), isNull);
      expect(MonthKey.parse('июль'), isNull);
      expect(MonthKey.parse('2026-7'), isNull);
    });

    test('переход через границу года', () {
      expect(MonthKey.next('2026-12'), '2027-01');
      expect(MonthKey.previous('2026-01'), '2025-12');
    });

    test('название месяца в двух падежах', () {
      expect(MonthKey.monthName('2026-07'), 'Июль');
      expect(MonthKey.monthNameAccusative('2026-07'), 'июль');
    });
  });

  group('Вес категории', () {
    test('множители из техзадания', () {
      const w = CategoryWeight(categoryId: 'supermarkets', weight: 10);
      expect(w.promoted().weight, closeTo(15, 0.001));
      expect(w.demoted().weight, closeTo(7, 0.001));
    });

    test('диапазон ограничен 0,1 … 30', () {
      const high = CategoryWeight(categoryId: 'a', weight: 25);
      expect(high.promoted().weight, 30);

      const low = CategoryWeight(categoryId: 'b', weight: 0.12);
      expect(low.demoted().weight, 0.1);
    });
  });

  group('Форматирование процентов', () {
    test('целые без хвоста, дробные через запятую', () {
      expect(Percent.format(5), '5%');
      expect(Percent.format(1.5), '1,5%');
      expect(Percent.format(10), '10%');
    });
  });

  group('Русские склонения', () {
    test('категории', () {
      expect(Plural.categories(1), '1 категория');
      expect(Plural.categories(2), '2 категории');
      expect(Plural.categories(5), '5 категорий');
      expect(Plural.categories(11), '11 категорий');
      expect(Plural.categories(21), '21 категория');
      expect(Plural.categories(22), '22 категории');
      expect(Plural.categories(0), '0 категорий');
    });

    test('карты', () {
      expect(Plural.cards(1), '1 карта');
      expect(Plural.cards(3), '3 карты');
      expect(Plural.cards(10), '10 карт');
      expect(Plural.cards(12), '12 карт');
    });

    test('активные категории — как в макете главного экрана', () {
      expect(Plural.activeCategories(1), '1 активная категория');
      expect(Plural.activeCategories(4), '4 активные категории');
      expect(Plural.activeCategories(8), '8 активных категорий');
    });
  });
}
