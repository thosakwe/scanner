import 'dart:async';
import 'package:charcode/ascii.dart';
import 'package:scanner/scanner.dart';
import 'package:test/test.dart';

Stream<List<int>> contents() async* {
  yield [$3, $0, $dot, $5];
}

Stream<List<int>> neg24() async* {
  yield [$minus, $2, $4, $dot, $0];
}

main() {
  test('has next', () async {
    var scanner = new Scanner(contents());
    expect(await scanner.hasNextInt(), isTrue);
  });

  group('read', () {
    test('positive', () async {
      var scanner = new Scanner(contents());
      var pitbull = await scanner.nextDouble();
      expect(pitbull, equals(30.5));
    });

    test('negative', () async {
      var scanner = new Scanner(neg24());
      var n = await scanner.nextDouble();
      expect(n, equals(-24.0));
    });
  });
}
