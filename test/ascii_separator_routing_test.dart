import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  test('ASCII paragraph boundary classification matches Unicode data', () {
    for (var character = 0; character < 128; ++character) {
      final source = 'A${String.fromCharCode(character)}B';
      final paragraphs = bidi.BidiString.fromLogical(source).paragraphs;
      final separator = bidi.getCharacterType(character) ==
          bidi.CharacterType.separator;
      expect(paragraphs.length, separator ? 2 : 1,
          reason: 'ASCII code unit $character');
    }
  });

  test('non-ASCII separators and supplementary emoji retain behavior', () {
    for (final character in [0x0085, 0x2028, 0x2029]) {
      final source = 'A${String.fromCharCode(character)}B';
      final expected = bidi.getCharacterType(character) ==
          bidi.CharacterType.separator;
      expect(bidi.BidiString.fromLogical(source).paragraphs.length,
          expected ? 2 : 1, reason: 'U+$character');
    }
    final p = bidi.BidiString.fromLogical('A😀B').paragraphs.single;
    expect(String.fromCharCodes(p.bidiText), 'A😀B');
    expect(p.indices, [0, 1, 3]);
  });

  test('ASCII CRLF and repeated paragraph boundaries are unchanged', () {
    const input = 'one\r\ntwo\n\nthree\rfour\u001cfive';
    expect(String.fromCharCodes(bidi.logicalToVisual(input)), input);
    // The existing parser counts CR and LF separately, including CRLF.
    expect(bidi.BidiString.fromLogical(input).paragraphs.length, 7);
  });
}
