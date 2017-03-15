import 'dart:async';
import 'package:charcode/ascii.dart';
import 'package:scanner/scanner.dart';
import 'package:test/test.dart';

Stream<List<int>> daleMami() async* {
  yield [$3, $0, $5];
}

Stream<List<int>> neg24() async* {
  yield [$minus, $2, $4];
}

main() {
  test('has next', () async {
    var scanner = new Scanner(daleMami());
    expect(await scanner.hasNextInt(), isTrue);
  });

  group('read', () {
    test('positive', () async {
      var scanner = new Scanner(daleMami());
      var pitbull = await scanner.nextInt();
      expect(pitbull, equals(305));
    });

    test('negative', () async {
      var scanner = new Scanner(neg24());
      var n = await scanner.nextInt();
      expect(n, equals(-24));
    });
  });
}
