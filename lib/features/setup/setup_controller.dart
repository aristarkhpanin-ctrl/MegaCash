import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/ids.dart';
import '../../data/providers.dart';
import '../../domain/models/monthly_offer.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/models/recognition_log.dart';
import '../../domain/models/selection.dart';
import '../../domain/ocr/recognition_service.dart';
import '../../domain/optimizer/optimization_result.dart';
import '../../domain/optimizer/optimizer.dart';
import '../home/home_providers.dart';

/// Ход месячной настройки.
///
/// Состояние всего цикла держится в одном месте: экраны Б1–Б8 — это шаги
/// одного дела, и раскладывать их данные по отдельным экранам значит
/// потерять их при первом же возврате назад.
class SetupState {
  const SetupState({
    this.cards = const [],
    this.imagesByCard = const {},
    this.offers = const [],
    this.unmatched = const [],
    this.result,
    this.pinned = const [],
    this.excluded = const [],
    this.recognizing = false,
    this.recognizedCards = 0,
    this.recalculated = false,
    this.rawTexts = const [],
  });

  final List<PaymentCard> cards;

  /// Скриншоты, разложенные по картам.
  final Map<String, List<String>> imagesByCard;

  /// Предложения: распознанные и введённые руками.
  final List<MonthlyOffer> offers;

  /// Строки, которые не удалось отнести к категории — магазины и сервисы.
  final List<UnmatchedOffer> unmatched;

  final OptimizationResult? result;

  /// Решения пользователя, которые пересчёт обязан сохранить.
  final List<Assignment> pinned;
  final List<String> excluded;

  final bool recognizing;
  final int recognizedCards;

  /// Показать плашку «пересчитали после переноса».
  final bool recalculated;

  final List<String> rawTexts;

  int get totalImages =>
      imagesByCard.values.fold(0, (sum, list) => sum + list.length);

  bool get hasOffers => offers.isNotEmpty;

  /// Предложения, распознанные неуверенно: их показываем на проверку.
  List<MonthlyOffer> get needsReview =>
      offers.where((o) => o.needsReview).toList();

  SetupState copyWith({
    List<PaymentCard>? cards,
    Map<String, List<String>>? imagesByCard,
    List<MonthlyOffer>? offers,
    List<UnmatchedOffer>? unmatched,
    OptimizationResult? result,
    List<Assignment>? pinned,
    List<String>? excluded,
    bool? recognizing,
    int? recognizedCards,
    bool? recalculated,
    List<String>? rawTexts,
  }) =>
      SetupState(
        cards: cards ?? this.cards,
        imagesByCard: imagesByCard ?? this.imagesByCard,
        offers: offers ?? this.offers,
        unmatched: unmatched ?? this.unmatched,
        result: result ?? this.result,
        pinned: pinned ?? this.pinned,
        excluded: excluded ?? this.excluded,
        recognizing: recognizing ?? this.recognizing,
        recognizedCards: recognizedCards ?? this.recognizedCards,
        recalculated: recalculated ?? this.recalculated,
        rawTexts: rawTexts ?? this.rawTexts,
      );
}

class SetupController extends Notifier<SetupState> {
  @override
  SetupState build() => const SetupState();

  /// Загружает карты пользователя в начале настройки.
  Future<void> start() async {
    final cards = await ref.read(cardsProvider.future);
    state = SetupState(cards: cards.map((c) => c.card).toList());
  }

  void addImages(String cardId, List<String> paths) {
    final next = {...state.imagesByCard};
    next[cardId] = [...?next[cardId], ...paths];
    state = state.copyWith(imagesByCard: next);
  }

  void removeImage(String cardId, String path) {
    final next = {...state.imagesByCard};
    next[cardId] = [...?next[cardId]]..remove(path);
    if (next[cardId]!.isEmpty) next.remove(cardId);
    state = state.copyWith(imagesByCard: next);
  }

  /// Распознаёт все загруженные скриншоты.
  ///
  /// Идёт по картам, а не по картинкам: предложение принадлежит карте,
  /// и без этой привязки распознанное некуда положить.
  Future<void> recognize() async {
    final service = ref.read(recognitionServiceProvider);
    final monthKey = ref.read(currentMonthProvider);

    state = state.copyWith(
      recognizing: true,
      recognizedCards: 0,
      offers: const [],
      unmatched: const [],
      rawTexts: const [],
    );

    final offers = <MonthlyOffer>[];
    final unmatched = <UnmatchedOffer>[];
    final rawTexts = <String>[];
    var done = 0;

    for (final entry in state.imagesByCard.entries) {
      for (final path in entry.value) {
        try {
          final outcome = await service.recognize(
            imagePath: path,
            cardId: entry.key,
            monthKey: monthKey,
          );
          offers.addAll(outcome.offers);
          unmatched.addAll(outcome.unmatched);
          rawTexts.add(outcome.rawText);
        } on Object catch (error) {
          // Один нечитаемый скриншот не должен ронять весь разбор:
          // остальные карты человек уже загрузил.
          rawTexts.add('Не удалось распознать $path: $error');
        }
      }
      done++;
      state = state.copyWith(recognizedCards: done);
    }

    state = state.copyWith(
      offers: _dedupe(offers),
      unmatched: _dedupeUnmatched(unmatched),
      rawTexts: rawTexts,
      recognizing: false,
    );

    await _saveLog();
  }

  /// Убирает повторы: одна категория не может встретиться у карты дважды.
  static List<MonthlyOffer> _dedupe(List<MonthlyOffer> offers) {
    final byKey = <String, MonthlyOffer>{};
    for (final offer in offers) {
      final key = '${offer.cardId}|${offer.categoryId}';
      final existing = byKey[key];
      if (existing == null || offer.rate > existing.rate) {
        byKey[key] = offer;
      }
    }
    return byKey.values.toList();
  }

  /// Скриншоты одной карты перекрываются: человек листает список и снимает
  /// его по кускам. Одно и то же предложение приходит несколько раз.
  static List<UnmatchedOffer> _dedupeUnmatched(List<UnmatchedOffer> items) {
    final seen = <String>{};
    return [
      for (final item in items)
        if (seen.add(item.key)) item,
    ];
  }

  Future<void> _saveLog() async {
    if (state.rawTexts.isEmpty) return;
    await ref.read(recognitionLogRepositoryProvider).add(
          RecognitionLog.build(
            id: Ids.generate(),
            rawText: state.rawTexts.join('\n---\n'),
            foundCount: state.offers.length,
            unmatched: state.unmatched.map((u) => u.rawName).toList(),
          ),
        );
  }

  /// Добавляет предложение вручную — на экране ручного ввода или при
  /// разборе несопоставленных строк.
  void addManualOffer({
    required String cardId,
    required String categoryId,
    required double rate,
    String? note,
  }) {
    final monthKey = ref.read(currentMonthProvider);
    final offers = [
      ...state.offers.where(
        (o) => !(o.cardId == cardId && o.categoryId == categoryId),
      ),
      MonthlyOffer(
        id: Ids.generate(),
        cardId: cardId,
        monthKey: monthKey,
        categoryId: categoryId,
        rate: rate,
        source: OfferSource.manual,
        note: note,
      ),
    ];
    state = state.copyWith(offers: offers);
  }

  /// Подтверждает распознанное с исправлением процента или категории.
  void correctOffer(String offerId, {String? categoryId, double? rate}) {
    state = state.copyWith(
      offers: [
        for (final o in state.offers)
          if (o.id == offerId)
            o.copyWith(
              categoryId: categoryId,
              rate: rate,
              // Подтверждённое человеком больше не считается сомнительным.
              confidence: 1,
              source: OfferSource.manual,
            )
          else
            o,
      ],
    );
  }

  void dropOffer(String offerId) {
    state = state.copyWith(
      offers: state.offers.where((o) => o.id != offerId).toList(),
    );
  }

  /// Убирает несопоставленную строку из списка на разбор — разобранную
  /// или ненужную.
  void dismissUnmatched(UnmatchedOffer item) {
    state = state.copyWith(
      unmatched: state.unmatched.where((u) => u.key != item.key).toList(),
    );
  }

  /// Считает рекомендацию с учётом решений пользователя.
  Future<void> optimize({bool afterMove = false}) async {
    final weights = await ref.read(weightsProvider.future);

    final result = const CashbackOptimizer().optimizeWithPins(
      cards: state.cards,
      offers: state.offers,
      weights: weights,
      pinned: state.pinned,
      excluded: state.excluded,
    );

    state = state.copyWith(result: result, recalculated: afterMove);
  }

  /// Пользователь забрал категорию в «Выбранные».
  ///
  /// Менять местами две строки нельзя: освободившийся слот меняет
  /// распределение и в других банках. Поэтому выбор фиксируется жёстким
  /// ограничением, а всё остальное считается заново.
  Future<void> promote(String categoryId, String cardId) async {
    final offer = state.offers.firstWhere(
      (o) => o.cardId == cardId && o.categoryId == categoryId,
    );

    state = state.copyWith(
      pinned: [
        ...state.pinned.where((p) => p.categoryId != categoryId),
        Assignment(cardId: cardId, categoryId: categoryId, rate: offer.rate),
      ],
      excluded: state.excluded.where((id) => id != categoryId).toList(),
    );

    await _bumpWeight(categoryId, up: true);
    await optimize(afterMove: true);
  }

  /// Пользователь отправил категорию в «Не выбранные».
  Future<void> demote(String categoryId) async {
    state = state.copyWith(
      excluded: [...state.excluded, categoryId],
      pinned: state.pinned.where((p) => p.categoryId != categoryId).toList(),
    );

    await _bumpWeight(categoryId, up: false);
    await optimize(afterMove: true);
  }

  /// Действия пользователя уточняют веса: забрал — важнее, отправил вниз —
  /// менее важно. Веса живут между месяцами, поэтому со временем
  /// рекомендация подстраивается под конкретного человека.
  Future<void> _bumpWeight(String categoryId, {required bool up}) async {
    final defaults =
        await ref.read(categoryDictionaryProvider).defaultWeights();
    final repo = ref.read(weightRepositoryProvider);
    final defaultWeight = defaults[categoryId] ?? 1;

    if (up) {
      await repo.promote(categoryId, defaultWeight: defaultWeight);
    } else {
      await repo.demote(categoryId, defaultWeight: defaultWeight);
    }
    ref.invalidate(weightsProvider);
  }

  /// Сохраняет предложения и выбор месяца — последний шаг настройки.
  Future<void> commit() async {
    final monthKey = ref.read(currentMonthProvider);
    final result = state.result;
    if (result == null) return;

    // Предложения месяца перезаписываются целиком: повторная настройка
    // заменяет прошлый разбор, а не накапливается поверх него.
    await ref.read(offerRepositoryProvider).clearMonth(monthKey);
    await ref.read(offerRepositoryProvider).saveAll(state.offers);

    await ref.read(selectionRepositoryProvider).replaceMonth(monthKey, [
      for (final a in result.selected)
        Selection(
          id: Ids.generate(),
          cardId: a.cardId,
          monthKey: monthKey,
          categoryId: a.categoryId,
          status: state.pinned.any((p) => p.categoryId == a.categoryId)
              ? SelectionStatus.userChosen
              : SelectionStatus.recommended,
        ),
    ]);

    ref
      ..invalidate(activeCategoriesProvider)
      ..invalidate(monthStateProvider)
      ..invalidate(newMonthBannerProvider)
      ..invalidate(selectionCountProvider(monthKey));
  }

  /// Отмечает, что пользователь включил категории в приложении банка.
  Future<void> markActivated() async {
    final monthKey = ref.read(currentMonthProvider);
    final repo = ref.read(selectionRepositoryProvider);
    for (final s in await repo.forMonth(monthKey)) {
      await repo.updateStatus(s.id, SelectionStatus.activated);
    }
    ref.invalidate(activeCategoriesProvider);
  }
}

final setupControllerProvider =
    NotifierProvider<SetupController, SetupState>(SetupController.new);
