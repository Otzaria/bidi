import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  test('default visual order preserves direct glyph renderer placement', () {
    const input = 'אְבֱג';
    final paragraph = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(paragraph.bidiText), 'גֱבְא');
    expect(paragraph.indices, [4, 3, 2, 1, 0]);
    expect(paragraph.sourceLengths, [1, 1, 1, 1, 1]);
    expect(String.fromCharCodes(bidi.logicalToVisual(input)), 'גֱבְא');
    final indices = <int>[];
    final lengths = <int>[];
    expect(bidi.logicalToVisual2(input, indices, lengths), 'גֱבְא');
    expect(indices, paragraph.indices);
    expect(lengths, paragraph.sourceLengths);
  });

  test('explicit cluster order stays aligned through every entry point', () {
    const input = 'אְבֱג';
    const order = bidi.RtlCombiningMarkOrder.afterBase;
    final paragraph = bidi.BidiString.fromLogical(
      input,
      combiningMarkOrder: order,
    ).paragraphs.single;
    expect(String.fromCharCodes(paragraph.bidiText), 'גבֱאְ');
    expect(paragraph.indices, [4, 2, 3, 0, 1]);
    expect(paragraph.sourceLengths, [1, 1, 1, 1, 1]);
    expect(
      String.fromCharCodes(
          bidi.logicalToVisual(input, combiningMarkOrder: order)),
      'גבֱאְ',
    );
    final indices = <int>[];
    final lengths = <int>[];
    expect(
      bidi.logicalToVisual2(input, indices, lengths, combiningMarkOrder: order),
      'גבֱאְ',
    );
    expect(indices, paragraph.indices);
    expect(lengths, paragraph.sourceLengths);
  });

  test('consecutive marks retain source spans for either rendering convention',
      () {
    const input = 'אְֱב\nאְֱב';
    for (final order in bidi.RtlCombiningMarkOrder.values) {
      final indices = <int>[99];
      final lengths = <int>[77];
      final visual = bidi.logicalToVisual2(
        input,
        indices,
        lengths,
        combiningMarkOrder: order,
      );
      final cluster =
          order == bidi.RtlCombiningMarkOrder.beforeBase ? 'בְֱא' : 'באְֱ';
      final positions = order == bidi.RtlCombiningMarkOrder.beforeBase
          ? [3, 2, 1, 0]
          : [3, 0, 1, 2];
      expect(visual, '$cluster\n$cluster');
      expect(indices, [99, ...positions, 4, ...positions.map((i) => i + 5)]);
      expect(lengths, [77, ...List.filled(9, 1)]);
    }
  });
}
