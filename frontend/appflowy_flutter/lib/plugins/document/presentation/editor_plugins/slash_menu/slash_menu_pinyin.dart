import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:lpinyin/lpinyin.dart';

final RegExp _chineseCharacter = RegExp(r'[一-鿿]');
final RegExp _nonAlphanumeric = RegExp(r'[^a-z0-9]');

/// Appends pinyin keywords for the localized (Chinese) name and keywords of
/// each slash menu item, so the items can also be searched by:
/// - full pinyin, e.g. 文档 -> wendang
/// - the first letter of each character, e.g. 文档 -> wd
///
/// The original keywords and the localized name itself remain searchable,
/// so searching by the Chinese name (e.g. 文档) or the English keywords
/// (e.g. page) still works.
List<SelectionMenuItem> appendPinyinKeywords(List<SelectionMenuItem> items) {
  for (final item in items) {
    // Snapshot before mutating the keywords below.
    final sources = <String>{item.name, ...item.keywords};
    for (final source in sources) {
      if (!_chineseCharacter.hasMatch(source)) {
        continue;
      }
      final fullPinyin = PinyinHelper.getPinyinE(
        source,
        separator: '',
        defPinyin: '',
        format: PinyinFormat.WITHOUT_TONE,
      ).toLowerCase().replaceAll(_nonAlphanumeric, '');
      final initials = PinyinHelper.getShortPinyin(source)
          .toLowerCase()
          .replaceAll(_nonAlphanumeric, '');
      for (final keyword in [fullPinyin, initials]) {
        if (keyword.isNotEmpty && !item.keywords.contains(keyword)) {
          item.keywords.add(keyword);
        }
      }
    }
  }
  return items;
}
