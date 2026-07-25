/// Венгерский алгоритм (Кун — Манкрес) для прямоугольных матриц.
///
/// Решает задачу о назначениях точно. Жадный перебор здесь не годится:
/// он не падает, он просто тихо советует неоптимальное, и заметить это
/// по глазам невозможно.
///
/// Размерность в приложении маленькая — до сорока категорий на два десятка
/// слотов, — поэтому кубическая сложность роли не играет.
library;

const double _inf = double.infinity;

/// Назначает строки на столбцы так, чтобы суммарная выгода была наибольшей.
///
/// `benefit[i][j]` — выгода от назначения строки `i` на столбец `j`,
/// величина неотрицательная. Возвращает для каждой строки индекс столбца
/// или -1, если строке столбца не досталось.
///
/// Назначения с нулевой выгодой возвращаются наравне с остальными:
/// отфильтровать их — забота вызывающего кода.
List<int> maxAssignment(List<List<double>> benefit) {
  final n = benefit.length;
  if (n == 0) return const [];
  final m = benefit.first.length;
  if (m == 0) return List<int>.filled(n, -1);

  // Реализация ниже требует, чтобы строк было не больше, чем столбцов.
  // Категорий обычно больше, чем слотов, поэтому матрицу разворачиваем.
  final transposed = n > m;
  final a = transposed ? _transpose(benefit) : benefit;

  final rowToCol = _solveMin(a);

  if (!transposed) return rowToCol;

  final result = List<int>.filled(n, -1);
  for (var i = 0; i < rowToCol.length; i++) {
    final col = rowToCol[i];
    if (col >= 0) result[col] = i;
  }
  return result;
}

List<List<double>> _transpose(List<List<double>> a) {
  final rows = a.length;
  final cols = a.first.length;
  return List.generate(
    cols,
    (j) => List.generate(rows, (i) => a[i][j], growable: false),
    growable: false,
  );
}

/// Классическая реализация с потенциалами. Работает на минимум, поэтому
/// выгода подаётся со знаком минус: минимум суммы «минус выгода» — это
/// максимум суммы выгоды.
///
/// Индексация внутри с единицы, нулевые строка и столбец служебные.
List<int> _solveMin(List<List<double>> benefit) {
  final n = benefit.length;
  final m = benefit.first.length;

  double cost(int i, int j) => -benefit[i - 1][j - 1];

  final u = List<double>.filled(n + 1, 0);
  final v = List<double>.filled(m + 1, 0);
  // p[j] — строка, назначенная столбцу j.
  final p = List<int>.filled(m + 1, 0);
  final way = List<int>.filled(m + 1, 0);

  for (var i = 1; i <= n; i++) {
    p[0] = i;
    var j0 = 0;
    final minv = List<double>.filled(m + 1, _inf);
    final used = List<bool>.filled(m + 1, false);

    do {
      used[j0] = true;
      final i0 = p[j0];
      var delta = _inf;
      var j1 = 0;

      for (var j = 1; j <= m; j++) {
        if (used[j]) continue;
        final cur = cost(i0, j) - u[i0] - v[j];
        if (cur < minv[j]) {
          minv[j] = cur;
          way[j] = j0;
        }
        if (minv[j] < delta) {
          delta = minv[j];
          j1 = j;
        }
      }

      for (var j = 0; j <= m; j++) {
        if (used[j]) {
          u[p[j]] += delta;
          v[j] -= delta;
        } else {
          minv[j] -= delta;
        }
      }

      j0 = j1;
    } while (p[j0] != 0);

    // Разворачиваем найденную увеличивающую цепочку.
    do {
      final j1 = way[j0];
      p[j0] = p[j1];
      j0 = j1;
    } while (j0 != 0);
  }

  final rowToCol = List<int>.filled(n, -1);
  for (var j = 1; j <= m; j++) {
    final row = p[j];
    if (row != 0) rowToCol[row - 1] = j - 1;
  }
  return rowToCol;
}
