/// Банк, выпустивший карту.
///
/// Логотипы не хранятся и не показываются — только название текстом и
/// цветовая заливка. Это осознанное решение по товарным знакам.
class Bank {
  const Bank({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  final String id;

  /// «Т-Банк», «Сбербанк». Пользователь может завести и свой.
  final String name;

  /// Цвет карточки, ARGB. Приходит из данных, а не из дизайн-системы:
  /// цвет текста поверх вычисляется по яркости фона.
  final int colorValue;

  Bank copyWith({String? id, String? name, int? colorValue}) => Bank(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bank &&
          other.id == id &&
          other.name == name &&
          other.colorValue == colorValue;

  @override
  int get hashCode => Object.hash(id, name, colorValue);

  @override
  String toString() => 'Bank($id, $name)';
}
