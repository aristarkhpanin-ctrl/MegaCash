/// Подсказка при добавлении карты: банк и его цвет.
class KnownBank {
  const KnownBank(this.name, this.colorValue);

  final String name;
  final int colorValue;
}

/// Список для поиска при добавлении карты.
///
/// Это только удобство: банка может не оказаться в списке, тогда
/// пользователь заводит его сам. Цвета — фирменные, взяты для узнавания
/// карты по цвету; логотипы не используются.
abstract final class KnownBanks {
  static const List<KnownBank> all = [
    KnownBank('Сбербанк', 0xFF21A038),
    KnownBank('Т-Банк', 0xFF1C1C1E),
    KnownBank('Альфа-Банк', 0xFFEF3124),
    KnownBank('ВТБ', 0xFF009FDF),
    KnownBank('Райффайзен Банк', 0xFFFEE600),
    KnownBank('Газпромбанк', 0xFF1F2A63),
    KnownBank('Озон Банк', 0xFF005BFF),
    KnownBank('Яндекс Пэй', 0xFFFC3F1D),
    KnownBank('Почта Банк', 0xFF7B3FBF),
    KnownBank('Совкомбанк', 0xFF005CAB),
    KnownBank('МКБ', 0xFF00953B),
    KnownBank('ОТП Банк', 0xFF5C8A2B),
    KnownBank('Уралсиб', 0xFF2E6E5A),
    KnownBank('Хоум Банк', 0xFFD06A2C),
    KnownBank('Русский Стандарт', 0xFF463C7A),
    KnownBank('Росбанк', 0xFFCE1126),
    KnownBank('Открытие', 0xFF00BFFF),
    KnownBank('Промсвязьбанк', 0xFFF26722),
    KnownBank('Ак Барс', 0xFF00844B),
    KnownBank('Тинькофф Платинум', 0xFF333333),
  ];

  /// Цвет для банка, которого нет в списке.
  static const int fallbackColor = 0xFF6B665C;

  /// Поиск без учёта регистра и буквы «ё».
  static List<KnownBank> search(String query) {
    final q = _normalize(query);
    if (q.isEmpty) return all;
    return all.where((b) => _normalize(b.name).contains(q)).toList();
  }

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll('ё', 'е').trim();
}
