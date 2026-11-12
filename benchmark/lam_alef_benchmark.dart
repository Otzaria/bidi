import 'package:bidi/bidi.dart' as bidi;

void main() {
  for (final count in [100, 1000, 10000]) {
    final input = List.filled(count, 'لَاX ').join();
    for (var warmup = 0; warmup < 2; warmup++) {
      bidi.logicalToVisual(input);
    }
    var checksum = 0;
    final watch = Stopwatch()..start();
    for (var iteration = 0; iteration < 5; iteration++) {
      checksum += bidi.logicalToVisual(input).length;
    }
    print(
        '$count ligatures: ${watch.elapsedMicroseconds / 5} us/op, $checksum');
  }
}
