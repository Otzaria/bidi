import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  // Expected values are independently derived from FriBidi's log2vis,
  // including its visual-to-logical character positions.
  const cases = <_Case>[
    _Case('abc [אבג] 123', 'abc [גבא] 123', [0, 1, 2, 3, 4, 7, 6, 5, 8, 9, 10, 11, 12]),
    _Case('abc (אבג) 123', 'abc (גבא) 123', [0, 1, 2, 3, 4, 7, 6, 5, 8, 9, 10, 11, 12]),
    _Case('abc {אבג} 123', 'abc {גבא} 123', [0, 1, 2, 3, 4, 7, 6, 5, 8, 9, 10, 11, 12]),
    _Case('abc ([אבג]) 123', 'abc ([גבא]) 123', [0, 1, 2, 3, 4, 5, 8, 7, 6, 9, 10, 11, 12, 13, 14]),
    _Case('abc [אבג (DEF)] 123', 'abc [גבא (DEF)] 123', [0, 1, 2, 3, 4, 7, 6, 5, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]),
    _Case('אבג [abc] דהו', 'והד [abc] גבא', [12, 11, 10, 9, 8, 5, 6, 7, 4, 3, 2, 1, 0]),
  ];

  for (final fixture in cases) {
    test('bracket pair N0 matches reference: ${fixture.logical}', () {
      final paragraph =
          bidi.BidiString.fromLogical(fixture.logical).paragraphs.single;
      expect(String.fromCharCodes(paragraph.bidiText), fixture.visual);
      expect(paragraph.indices, fixture.indices);
    });
  }
}

class _Case {
  const _Case(this.logical, this.visual, this.indices);

  final String logical;
  final String visual;
  final List<int> indices;
}
