import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/category.dart';

/// Выбор категории для строки, которую не удалось сопоставить.
///
/// Открывается снизу, а не отдельным экраном: несопоставленных строк на
/// экране банка бывает два десятка, и уход с возвратом на каждой сбивал бы
/// место в списке — человек каждый раз искал бы, где он остановился.
Future<Category?> showCategoryPicker(
  BuildContext context, {
  required List<Category> categories,
  required String title,
}) =>
    showModalBottomSheet<Category>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CategoryPicker(categories: categories, title: title),
    );

class _CategoryPicker extends StatefulWidget {
  const _CategoryPicker({required this.categories, required this.title});

  final List<Category> categories;

  /// Название так, как его написал банк: «РИВ ГОШ». Держим его на виду —
  /// в списке из двадцати строк без него непонятно, что именно разбираешь.
  final String title;

  @override
  State<_CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<_CategoryPicker> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final query = _normalize(_controller.text);
    final matches = widget.categories
        .where((cat) => query.isEmpty || _normalize(cat.name).contains(query))
        .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.screen,
                  Spacing.x4,
                  Spacing.screen,
                  Spacing.x2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'К КАКОЙ КАТЕГОРИИ ОТНЕСТИ',
                      style: AppText.label.copyWith(
                        color: c.textSecondary,
                        letterSpacing: 0.48,
                      ),
                    ),
                    const SizedBox(height: Spacing.x1),
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyStrong.copyWith(color: c.text),
                    ),
                    const SizedBox(height: Spacing.x3),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Поиск категории',
                        prefixIcon: Icon(Icons.search, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: matches.isEmpty
                    ? Center(
                        child: Text(
                          'Ничего не нашлось',
                          style: AppText.caption.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: Spacing.x4),
                        itemCount: matches.length,
                        itemBuilder: (context, i) => ListTile(
                          title: Text(
                            matches[i].name,
                            style: AppText.body.copyWith(color: c.text),
                          ),
                          onTap: () => Navigator.of(context).pop(matches[i]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll('ё', 'е').trim();
}
