[![pub package](https://img.shields.io/pub/v/bidi.svg)](https://pub.dartlang.org/packages/bidi)

Dart implementation of the Unicode Bidirectional Algorithm (UBA) for converting
**logical-order** text to **visual-order** Unicode character sequences.

This is the [Otzaria-maintained fork](https://github.com/Otzaria/bidi) of
[the original package](https://github.com/xclud/dart_bidi). It is used by
Otzaria's text/PDF printing pipeline to order mixed Hebrew, Latin, numerals,
punctuation and combining marks when the output renderer needs visual order.

The underlying resolver began with [Unicode UAX #9 revision 17](https://www.unicode.org/reports/tr9/tr9-17.html).
Recent improvements handle supplementary Unicode scalars, UTF-16 source mapping,
Hebrew combining-mark order and paired brackets. **It is not yet a complete
implementation of modern UAX #9**: directional isolates (LRI/RLI/FSI/PDI) and
all isolating-run-sequence rules are not fully supported. Use a conformant text
engine for unrestricted Unicode inputs.

Regular Flutter `Text` widgets already implement bidirectional text layout.
Do **not** pre-reorder strings with this package before displaying them in
those widgets: visual reordering is intended for output engines that explicitly
need visual-order glyph/text sequences.

## Web Demo

[Original upstream demo](https://bidi.pwa.ir) (not hosted by the Otzaria fork)

## Getting Started

To use the fork improvements documented here, add this Git dependency to
your `pubspec.yaml`:

```yaml
dependencies:
  bidi:
    git:
      url: https://github.com/Otzaria/bidi.git
      ref: 4531defe12ae543fc0034e3690e828653c76f1d6
```

The published `bidi: ^2.0.13` dependency does not include these fork improvements.

Then, in your code import and use the package:

```dart
import 'package:bidi/bidi.dart' as bidi;

final visualCodePoints = bidi.logicalToVisual('אבג Otzaria 2026');
final visualText = String.fromCharCodes(visualCodePoints);
print(visualText);
```

## Other Implementations

This package is also written in Rust (apart from this package, which is written in Dart). If you are looking for a pure Rust implementation of this package, look at [https://crates.io/crates/bidi/](https://crates.io/crates/bidi/).

## Visual-to-logical source offsets

For applications that need to associate a visual character with a source
position (for example text selection or PDF hit testing), use
`BidiString.fromLogical(input).paragraphs`. Each `Paragraph.indices` entry
refers to an **original UTF-16 offset relative to that paragraph**; the
aligned `Paragraph.sourceLengths` entries describe consumed UTF-16 spans.
A paragraph's separator is appended to `bidiText` but is not part of its
`indices` or `sourceLengths` lists.

Alternatively `logicalToVisual2(input, indexes, lengths)` appends the
**global** UTF-16 offsets and lengths, including paragraph separators, to
caller-provided lists. A supplementary Unicode scalar occupies two UTF-16
code units in the source, but one Unicode code point in the visual output.

## Release status

The published `bidi` package on [pub.dev](https://pub.dev/packages/bidi)
is currently associated with the original `pwa.ir` publisher. Merging
changes into this fork does **not** publish a new package version. A release
must be arranged by an authorized package uploader/publisher. The release
workflow triggers only on version tags such as `v2.0.14` and requires the
package owner to configure trusted publishing for `Otzaria/bidi` on pub.dev.
