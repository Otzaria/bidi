import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  test('all BMP codepoints retain the exact Unicode BiDi classes', () {
    final differences = <String>[];
    for (var character = 0; character <= 0xFFFF; ++character) {
      final original = bidi.characterTypes[character] ??
          bidi.CharacterType.ltr;
      final actual = bidi.getCharacterType(character);
      if (actual != original) {
        differences.add('U+${character.toRadixString(16)}: '
            '$original != $actual');
      }
    }
    expect(differences, isEmpty);
  });

  test('supplementary properties and sentinel inputs stay unchanged', () {
    expect(bidi.getCharacterType(0x1F600), bidi.CharacterType.otherNeutrals);
    expect(bidi.getCharacterType(0x1E900), bidi.CharacterType.rtl);
    expect(bidi.getCharacterType(0x10D00), bidi.CharacterType.al);
    expect(bidi.getCharacterType(-1), bidi.CharacterType.ltr);
    expect(bidi.getCharacterType(0x110000), bidi.CharacterType.ltr);
  });

  test('mixed Hebrew and Latin output and UTF-16 indices are unchanged', () {
    const input = 'abc [אבג] 123';
    final p = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(p.bidiText), 'abc [גבא] 123');
    expect(p.indices, [0, 1, 2, 3, 4, 7, 6, 5, 8, 9, 10, 11, 12]);
  });
}
