import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  test('all ASCII pairs preserve content and source spans including controls',
      () {
    for (var first = 0; first < 128; ++first) {
      for (var second = 0; second < 128; ++second) {
        final input = String.fromCharCodes([first, second]);
        final optimized = bidi.BidiString.fromLogical(input).paragraphs;
        expect([for (final p in optimized) ...p.bidiText], input.codeUnits);
        for (final paragraph in optimized) {
          final count = paragraph.text.length;
          expect(paragraph.indices, List.generate(count, (i) => i));
          expect(paragraph.n.text, paragraph.text);
          expect(paragraph.n.lengths, List.filled(count, 1));
          expect(paragraph.sourceLengths, List.filled(count, 1));
        }
      }
    }
  });

  test('pure ASCII paragraphs preserve text and every source index', () {
    const input = r'Plain English 2026, text: (1) + 2 = 3; $5.00!';
    final paragraph = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(paragraph.bidiText), input);
    expect(paragraph.indices, List<int>.generate(input.length, (i) => i));
    expect(paragraph.n.text, input.codeUnits);
    expect(paragraph.n.lengths, List<int>.filled(input.length, 1));
  });

  test('ASCII line and paragraph separators are preserved', () {
    const input = 'First\r\nSecond\nThird\rFourth\u001cFifth';
    expect(String.fromCharCodes(bidi.logicalToVisual(input)), input);
    final paragraphs = bidi.BidiString.fromLogical(input).paragraphs;
    expect(paragraphs, hasLength(6)); // CR and LF are separate separators.
    for (final paragraph in paragraphs) {
      expect(
        paragraph.indices,
        List<int>.generate(paragraph.text.length, (i) => i),
      );
    }
  });

  test('mixed-script paragraph still passes through full BiDi solver', () {
    const input = 'ASCII\nאבג\n123';
    final paragraphs = bidi.BidiString.fromLogical(input).paragraphs;
    expect(paragraphs, hasLength(3));
    expect(String.fromCharCodes(paragraphs.first.bidiText), 'ASCII\n');
    expect(String.fromCharCodes(paragraphs[1].bidiText), 'גבא\n');
    expect(String.fromCharCodes(paragraphs.last.bidiText), '123');
    expect(paragraphs[1].indices, [2, 1, 0]);
  });

  test('direction marks disable ASCII fast path', () {
    const input = '\u200F123';
    final paragraph = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(paragraph.bidiText), '123');
    expect(paragraph.indices.length, 3);
  });
}
