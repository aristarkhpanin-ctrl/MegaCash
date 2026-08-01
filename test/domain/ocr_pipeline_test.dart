import 'package:flutter_test/flutter_test.dart';
import 'package:megacash/data/remote/category_dictionary_impl.dart';
import 'package:megacash/domain/models/category.dart';
import 'package:megacash/domain/models/monthly_offer.dart';
import 'package:megacash/domain/ocr/category_matcher.dart';
import 'package:megacash/domain/ocr/ocr_engine.dart';
import 'package:megacash/domain/ocr/offer_parser.dart';
import 'package:megacash/domain/ocr/recognition_service.dart';
import 'package:megacash/domain/ocr/text_normalizer.dart';

import '../fixtures/bank_screens.dart';

/// Разбор проверяется на расшифровках настоящих скриншотов из Альфа-Банка,
/// ВТБ и Яндекс Пэй. Синтетика эти случаи не ловит: у всех трёх банков
/// процент стоит перед названием, у части позиций есть условия отдельной
/// строкой, а половина списка ВТБ — вообще магазины, а не категории.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Category> categories;
  late CategoryMatcher matcher;

  setUpAll(() async {
    categories = await BundledCategoryDictionary().all();
    matcher = CategoryMatcher(categories);
  });

  OcrPage page(String text) => OcrPage(
        lines: text
            .trim()
            .split('\n')
            .map((l) => OcrLine(text: l.trim()))
            .toList(),
      );

  ParseResult parse(String text) => OfferParser.parse(page(text));

  Map<String, double> ratesOf(String text) => {
        for (final o in parse(text).offers) o.rawName: o.rate,
      };

  group('Разбор строк', () {
    test('процент перед названием — так пишут все три банка', () {
      final rates = ratesOf(BankScreens.yandexPay);

      expect(rates['Все покупки'], 2);
      expect(rates['Кафе, бары и рестораны'], 5);
      expect(rates['Супермаркеты'], 5);
      expect(rates['Яндекс Такси'], 10);
      expect(rates['Кинопоиск'], 30);
      expect(rates['Самокаты'], 80);
      expect(rates['Книги'], 10);
    });

    test('процент в конце тоже разбирается', () {
      final result = parse('Супермаркеты 5%\nАптеки 1,5%');
      expect(result.offers, hasLength(2));
      expect(result.offers.first.rawName, 'Супермаркеты');
      expect(result.offers.first.rate, 5);
      expect(result.offers.last.rate, 1.5);
    });

    test('высокие проценты не отбрасываются', () {
      // 80% на самокаты и 40% на подписку — это настоящие предложения.
      final rates = ratesOf(BankScreens.vtbSecond);
      expect(rates['START'], 40);
      expect(ratesOf(BankScreens.yandexPay)['Самокаты'], 80);
    });

    test('условие подхватывается со следующей строки', () {
      final offers = parse(BankScreens.alfaFirst).offers;

      final clothes =
          offers.firstWhere((o) => o.rawName == 'Одежда и обувь');
      expect(clothes.note, 'Зарплатным клиентам');

      final transport = offers.firstWhere((o) => o.rawName == 'Транспорт');
      expect(transport.note, 'С Альфа-Смарт');

      final lamoda = offers.firstWhere((o) => o.rawName == 'Lamoda');
      expect(lamoda.note, 'На покупки от 8000 ₽');
    });

    test('у предложения без условия подписи нет', () {
      final offers = parse(BankScreens.alfaFirst).offers;
      final books = offers.firstWhere((o) => o.rawName == 'Книги');
      expect(books.note, isNull);
    });

    /// Ограничение суммы легко перепутать с предложением: там тоже есть
    /// число. Отличается тем, что процента в строке нет вовсе.
    test('«Кешбэк до 1 500 ₽» предложением не считается', () {
      final offers = parse(BankScreens.vtbFirst).offers;
      expect(
        offers.where((o) => o.rawName.contains('Кешбэк')),
        isEmpty,
      );
      expect(offers.where((o) => o.rate == 1500), isEmpty);
    });

    test('шапка, кнопки и «Подробнее» отбрасываются молча', () {
      final result = parse(BankScreens.vtbSecond);
      expect(result.ignored, isNot(contains('Подробнее')));
      expect(result.ignored, isNot(contains('Категории кешбэка')));
      expect(result.ignored, isNot(contains('1:30')));
      expect(result.ignored, isNot(contains('Базовый уровень')));
    });

    test('длинные описания в предложения не превращаются', () {
      final result = parse(BankScreens.vtbFirst);
      for (final offer in result.offers) {
        expect(offer.rawName.length, lessThanOrEqualTo(48));
      }
      expect(
        result.offers.where((o) => o.rawName.startsWith('При оплате')),
        isEmpty,
      );
    });

    test('на первых пяти экранах находится ожидаемое число предложений', () {
      expect(parse(BankScreens.alfaFirst).offers, hasLength(11));
      expect(parse(BankScreens.alfaSecond).offers, hasLength(11));
      expect(parse(BankScreens.vtbFirst).offers, hasLength(6));
      expect(parse(BankScreens.vtbSecond).offers, hasLength(6));
      expect(parse(BankScreens.yandexPay).offers, hasLength(9));
    });
  });

  group('Сопоставление со словарём', () {
    String? idOf(String name) => matcher.match(name).categoryId;

    test('формулировки банков находятся точно', () {
      expect(idOf('За все покупки'), 'all_purchases');
      expect(idOf('Все покупки'), 'all_purchases');
      expect(idOf('Супермаркеты'), 'supermarkets');
      expect(idOf('Кафе, бары и рестораны'), 'cafe');
      expect(idOf('Коммунальные услуги'), 'utilities');
      expect(idOf('Медицинские услуги'), 'medicine');
      expect(idOf('Автозапчасти'), 'auto');
      expect(idOf('Животные'), 'pets');
      expect(idOf('Техника'), 'electronics');
      expect(idOf('Деливери'), 'delivery');
      expect(idOf('Яндекс Такси'), 'taxi');
      expect(idOf('Яндекс Заправки'), 'fuel');
      expect(idOf('Кинопоиск'), 'cinema');
      expect(idOf('Детский мир'), 'kids');
      expect(idOf('Самокаты'), 'carsharing');
      expect(idOf('Фастфуд'), 'fastfood');
      expect(idOf('Транспорт'), 'transport');
    });

    test('точное совпадение даёт высокую уверенность', () {
      final m = matcher.match('Супермаркеты');
      expect(m.confidence, greaterThanOrEqualTo(0.9));
      expect(m.isMatched, isTrue);
    });

    test('одна перепутанная буква всё равно находит категорию', () {
      final m = matcher.match('Слпермаркеты');
      expect(m.categoryId, 'supermarkets');
      expect(m.confidence, lessThan(CategoryMatcher.exactConfidence));
    });

    test('одна ошибка на коротком названии тоже прощается', () {
      // По доле длины «Аптеко» отличается от «Аптеки» на 17% — порог такое
      // не пропустил бы, хотя это очевидная ошибка распознавания.
      expect(matcher.match('Аптеко').categoryId, 'pharmacy');
      expect(matcher.match('Книгн').categoryId, 'books');
    });

    test('две ошибки подряд — уже догадка, строка уходит человеку', () {
      final m = matcher.match('Слермаркеты');
      expect(
        m.confidence,
        lessThan(0.7),
        reason: 'подставлять наугад хуже, чем спросить',
      );
    });

    /// Ключевое решение: магазины не сводятся к категориям.
    /// «5% РИВ ГОШ» и «5% Красота» — разные предложения, и если склеить
    /// их в одну категорию, оптимизатор выбросит одно как дубль,
    /// отняв у человека слот.
    test('магазины и сервисы остаются несопоставленными', () {
      for (final brand in const [
        'РИВ ГОШ',
        'zolla',
        'Здравсити',
        'Авито Путешествия',
        'М.Косметик',
        'Почта России',
        'WOLLMER',
        'START',
        'Tasty Coffee',
        'Lamoda',
      ]) {
        expect(
          matcher.match(brand).isMatched,
          isFalse,
          reason: 'бренд «$brand» не должен подменяться категорией',
        );
      }
    });

    test('уверенность движка снижает итоговую', () {
      final sure = matcher.match('Супермаркеты');
      final unsure = matcher.match('Супермаркеты', lineConfidence: 0.6);
      expect(unsure.confidence, lessThan(sure.confidence));
      expect(unsure.confidence, closeTo(sure.confidence * 0.6, 0.001));
    });
  });

  group('Нормализация', () {
    test('«кешбэк» и «кэшбэк» — одно и то же', () {
      expect(
        TextNormalizer.key('Кешбэк до 500 ₽'),
        TextNormalizer.key('Кэшбэк до 500 ₽'),
      );
    });

    test('регистр, «ё» и знаки препинания не мешают', () {
      expect(
        TextNormalizer.key('Кафе, бары и рестораны'),
        TextNormalizer.key('кафе бары и рестораны'),
      );
      expect(TextNormalizer.key('Всё'), TextNormalizer.key('все'));
    });

    test('похожесть считается предсказуемо', () {
      expect(TextNormalizer.similarity('книги', 'книги'), 1);
      expect(TextNormalizer.similarity('книги', 'кннги'), greaterThan(0.7));
      expect(TextNormalizer.similarity('книги', 'аптеки'), lessThan(0.5));
    });
  });

  group('Сквозной разбор всех экранов', () {
    test('сопоставленных категорий больше, чем несопоставленных, у Альфы',
        () {
      final offers = parse(BankScreens.alfaFirst).offers;
      final matched = offers
          .where((o) => matcher.match(o.rawName).isMatched)
          .length;
      expect(matched, greaterThan(offers.length - matched));
    });

    /// Список ВТБ почти целиком состоит из магазинов. Это не сбой разбора,
    /// а устройство продукта банка, и приложение должно честно отдавать
    /// такие позиции человеку, а не подставлять наугад.
    test('у ВТБ почти всё — магазины, и это ожидаемо', () {
      final offers = parse(BankScreens.vtbFirst).offers;
      final unmatched = offers
          .where((o) => !matcher.match(o.rawName).isMatched)
          .length;
      expect(unmatched, greaterThanOrEqualTo(5));
    });

    test('ни одно распознанное предложение не теряет процент', () {
      for (final entry in BankScreens.all.entries) {
        for (final offer in parse(entry.value).offers) {
          expect(
            offer.rate,
            greaterThan(0),
            reason: '${entry.key}: ${offer.rawName}',
          );
          expect(offer.rate, lessThanOrEqualTo(100));
        }
      }
    });
  });

  group('Служба распознавания целиком', () {
    /// Критерий из техзадания: на тестовом наборе скриншотов распознаётся
    /// не меньше 80% строк с предложениями.
    test('доля извлечённых строк не ниже 80%', () {
      // Сколько строк с процентом есть на каждом экране на самом деле.
      const expected = {
        'Альфа-Банк · экран 1': 11,
        'Альфа-Банк · экран 2': 11,
        'ВТБ · экран 1': 6,
        'ВТБ · экран 2': 6,
        'Яндекс Пэй': 9,
        'Сбербанк': 8,
        'Ozon': 11,
        // Скидка «−50% Еда и Деливери» предложением не является.
        'Яндекс Пэй · август': 9,
        'Экран в две колонки': 8,
        'Т-Банк': 7,
        'СберСпасибо': 8,
      };

      var found = 0;
      var total = 0;
      for (final entry in BankScreens.all.entries) {
        found += parse(entry.value).offers.length;
        total += expected[entry.key]!;
      }

      expect(total, 94);
      expect(
        found / total,
        greaterThanOrEqualTo(0.8),
        reason: 'извлечено $found из $total',
      );
    });

    RecognitionService service() => RecognitionService(
          engine: _NeverCalledEngine(),
          categories: categories,
          idGenerator: () => 'id${DateTime.now().microsecondsSinceEpoch}',
        );

    test('предложения получают карту, месяц и происхождение', () {
      final outcome = service().fromPage(
        page(BankScreens.yandexPay),
        cardId: 'card1',
        monthKey: '2026-07',
      );

      expect(outcome.offers, isNotEmpty);
      for (final offer in outcome.offers) {
        expect(offer.cardId, 'card1');
        expect(offer.monthKey, '2026-07');
        expect(offer.source, OfferSource.ocr);
      }
    });

    test('условие банка сохраняется вместе с предложением', () {
      final outcome = service().fromPage(
        page(BankScreens.alfaFirst),
        cardId: 'card1',
        monthKey: '2026-07',
      );

      final clothes =
          outcome.offers.firstWhere((o) => o.categoryId == 'clothes');
      expect(clothes.note, 'Зарплатным клиентам');

      final transport =
          outcome.offers.firstWhere((o) => o.categoryId == 'transport');
      expect(transport.note, 'С Альфа-Смарт');
    });

    test('магазины уходят в несопоставленные, а не теряются', () {
      final outcome = service().fromPage(
        page(BankScreens.vtbFirst),
        cardId: 'card1',
        monthKey: '2026-07',
      );

      final names = outcome.unmatched.map((u) => u.rawName).toList();
      expect(names, contains('РИВ ГОШ'));
      expect(names, contains('zolla'));
      expect(names, contains('Здравсити'));

      // Проценты у них сохранены — пользователю останется указать категорию.
      final rivGauche =
          outcome.unmatched.firstWhere((u) => u.rawName == 'РИВ ГОШ');
      expect(rivGauche.rate, 15);

      expect(outcome.totalFound, 6);
    });

    test('одна категория не попадает в карту дважды', () {
      final outcome = service().fromPage(
        page('5% Супермаркеты\n7% Супермаркеты\n3% Аптеки'),
        cardId: 'card1',
        monthKey: '2026-07',
      );

      final supermarkets =
          outcome.offers.where((o) => o.categoryId == 'supermarkets');
      expect(supermarkets, hasLength(1));
      expect(
        supermarkets.single.rate,
        7,
        reason: 'из двух строк остаётся выгодная',
      );
    });

    test('неуверенно распознанное помечается к проверке', () {
      final outcome = service().fromPage(
        const OcrPage(
          lines: [
            OcrLine(text: '5% Слпермаркеты', confidence: 0.7),
            OcrLine(text: '3% Аптеки'),
          ],
        ),
        cardId: 'card1',
        monthKey: '2026-07',
      );

      expect(outcome.needsReviewCount, 1);
      final weak =
          outcome.offers.firstWhere((o) => o.categoryId == 'supermarkets');
      expect(weak.needsReview, isTrue);
    });

    test('весь распознанный текст сохраняется для журнала', () {
      final outcome = service().fromPage(
        page(BankScreens.alfaFirst),
        cardId: 'card1',
        monthKey: '2026-07',
      );
      expect(outcome.rawText, contains('Зарплатным клиентам'));
      expect(outcome.rawText, contains('1% За все покупки'));
    });
  });

  group('Второй набор скриншотов: Сбер, Ozon, Т-Банк, Яндекс', () {
    test('дробный процент в начале строки', () {
      final rates = ratesOf(BankScreens.sber);
      expect(rates['На все покупки'], 0.5);
      expect(rates['Супермаркеты'], 1.5);
      expect(rates['Парфюмерия и косметика'], 5);
    });

    /// Скидка на доставку — не кэшбэк. Если пустить её в подбор,
    /// оптимизатор займёт слот тем, что денег не возвращает вовсе.
    test('скидка со знаком минус в предложения не попадает', () {
      final offers = parse(BankScreens.yandexPayAugust).offers;
      expect(
        offers.where((o) => o.rawName.contains('Деливери')),
        isEmpty,
        reason: '«−50% Еда и Деливери» — это скидка, а не кэшбэк',
      );
      // Остальное на экране разобралось.
      expect(offers.map((o) => o.rawName), contains('Кинопоиск'));
      expect(offers.map((o) => o.rawName), contains('Все покупки'));
    });

    test('скидка отбрасывается и в обратном порядке написания', () {
      // Здесь минус ушёл бы в конец названия, а процент прошёл бы
      // как обычный.
      expect(parse('Еда и Деливери −50%').offers, isEmpty);
      expect(parse('Доставка -30%').offers, isEmpty);
    });

    test('сто процентов — допустимое предложение', () {
      final rates = ratesOf(BankScreens.yandexPayAugust);
      expect(rates['Свои Плюсы в S7'], 100);
    });

    /// На экранах в две колонки распознавание склеивает соседние плитки
    /// в одну строку. Без деления половина экрана просто пропала бы.
    test('строка с двумя предложениями делится надвое', () {
      final rates = ratesOf(BankScreens.gridTwoColumns);

      expect(rates['АЗС'], 5);
      expect(rates['Книги'], 5);
      expect(rates['Фастфуд'], 5);
      expect(rates['Магазины одежды'], 5);
      expect(rates['Транспорт'], 5);
      expect(rates['Запчасти и аксессуары'], 5);
      expect(rates['На все покупки'], 1);
      expect(rates['Цветы'], 10);

      expect(parse(BankScreens.gridTwoColumns).offers, hasLength(8));
    });

    test('двойной пробел после процента не мешает', () {
      expect(ratesOf(BankScreens.ozon)['Tasty Coffee'], 50);
    });

    test('условие «только по кредитной карте» подхватывается', () {
      final offers = parse(BankScreens.ozon).offers;
      final supermarkets =
          offers.firstWhere((o) => o.rawName == 'Супермаркеты');
      expect(supermarkets.note, 'Только по кредитной карте');
    });

    test('свои названия Т-Банка находятся в справочнике', () {
      String? idOf(String name) => matcher.match(name).categoryId;
      expect(idOf('Топливо в Городе'), 'fuel');
      expect(idOf('Шопинг в Городе'), 'clothes');
      expect(idOf('Спорттовары'), 'sport');
      expect(idOf('Искусство'), 'art');
    });

    test('названия СберСпасибо находятся в справочнике', () {
      String? idOf(String name) => matcher.match(name).categoryId;
      expect(idOf('Салоны красоты'), 'beauty');
      expect(idOf('Хобби и развлечения'), 'entertainment');
      expect(idOf('Товары для детей'), 'kids');
      expect(idOf('Такси и каршеринг'), 'taxi');
      expect(idOf('Парфюмерия и косметика'), 'beauty');
    });

    test('«Выбрано 0 из 4» и подписи подписки предложениями не считаются',
        () {
      for (final screen in [BankScreens.ozon, BankScreens.sberSpasibo]) {
        final names = parse(screen).offers.map((o) => o.rawName);
        expect(names, isNot(contains('Выбрано 0 из 4')));
        expect(names.where((n) => n.contains('СберПрайм')), isEmpty);
      }
    });

    test('на девяти экранах ничего не теряет процент', () {
      for (final entry in BankScreens.all.entries) {
        for (final offer in parse(entry.value).offers) {
          expect(offer.rate, greaterThan(0), reason: entry.key);
          expect(offer.rate, lessThanOrEqualTo(100), reason: entry.key);
        }
      }
    });
  });
}

/// Движок, который не должен вызываться: разбор проверяется
/// на расшифровках, поднимать Tesseract для этого незачем.
class _NeverCalledEngine implements OcrEngine {
  @override
  Future<void> prepare() async {}

  @override
  Future<OcrPage> recognizeFile(String path) async =>
      throw StateError('движок в этом тесте вызываться не должен');

  @override
  Future<void> dispose() async {}
}
