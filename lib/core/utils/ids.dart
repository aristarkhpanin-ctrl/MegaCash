import 'dart:math';

/// Идентификаторы сущностей.
///
/// Синхронизации между устройствами нет, поэтому глобальная уникальность
/// не нужна — достаточно не столкнуться внутри одной базы. Время в основе
/// даёт естественный порядок создания.
abstract final class Ids {
  static final Random _random = Random();

  static String generate() {
    final now = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final salt = _random.nextInt(1 << 32).toRadixString(36).padLeft(6, '0');
    return '$now-$salt';
  }
}
