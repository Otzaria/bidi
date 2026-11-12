import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  for (final order in bidi.RtlCombiningMarkOrder.values) {
    test('all entry points align marks and indices for $order', () {
      const input = 'אְבֱג';
      final paragraph = bidi.BidiString.fromLogical(
        input,
        combiningMarkOrder: order,
      ).paragraphs.single;
      final visual =
          order == bidi.RtlCombiningMarkOrder.beforeBase ? 'גֱבְא' : 'גבֱאְ';
      final positions = order == bidi.RtlCombiningMarkOrder.beforeBase
          ? [4, 3, 2, 1, 0]
          : [4, 2, 3, 0, 1];
      expect(String.fromCharCodes(paragraph.bidiText), visual);
      expect(paragraph.indices, positions);
      expect(
        String.fromCharCodes(
            bidi.logicalToVisual(input, combiningMarkOrder: order)),
        visual,
      );
      final indices = <int>[];
      final lengths = <int>[];
      expect(
        bidi.logicalToVisual2(input, indices, lengths,
            combiningMarkOrder: order),
        visual,
      );
      expect(indices, positions);
    });
  }
  test('default order preserves direct glyph renderer placement', () {
    const input = 'אְבֱג';
    final paragraph = bidi.BidiString.fromLogical(input).paragraphs.single;
    expect(String.fromCharCodes(paragraph.bidiText), 'גֱבְא');
    expect(String.fromCharCodes(bidi.logicalToVisual(input)), 'גֱבְא');
    expect(bidi.logicalToVisual2(input, <int>[], <int>[]), 'גֱבְא');
  });
}
