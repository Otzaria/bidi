import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  test('European terminator runs preserve adjacent numbers in RTL text', () {
    const input = 'א \$\$12 + 34%% ב';
    final p = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(p.bidiText), 'ב 34%% + \$\$12 א');
    expect(p.indices, [14, 13, 9, 10, 11, 12, 8, 7, 6, 2, 3, 4, 5, 1, 0]);
  });

  test('neutral segment separators retain their source order within RTL runs',
      () {
    final p = bidi.BidiString.fromLogical('אב\t... ג').paragraphs.single;
    expect(String.fromCharCodes(p.bidiText), 'ג ...\tבא');
    expect(p.indices, [7, 6, 5, 4, 3, 2, 1, 0]);
  });

  test('English with long neutral punctuation runs remains in order', () {
    const input = 'ABC ... ;::-- 2026, 2027 / XYZ';
    final p = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(p.bidiText), input);
    expect(p.indices, List<int>.generate(input.length, (i) => i));
  });

  test('Hebrew/English brackets remain equal to the reference corpus', () {
    const input = 'abc [אבג] 123';
    final p = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(p.bidiText), 'abc [גבא] 123');
    expect(p.indices, [0, 1, 2, 3, 4, 7, 6, 5, 8, 9, 10, 11, 12]);
  });

  test('large runs of neutrals preserve character and index alignment', () {
    final input = 'א${List<String>.filled(700, '.,;:! ').join()}ב';
    final p = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(p.bidiText.length, input.length);
    expect(p.indices.length, p.bidiText.length);
    expect(p.sourceLengths.length, p.indices.length);
    expect(
        p.indices.toSet(), List<int>.generate(input.length, (i) => i).toSet());
  });
}
