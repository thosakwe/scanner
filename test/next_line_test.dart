import 'dart:async';
import 'package:charcode/ascii.dart';
import 'package:scanner/scanner.dart';
import 'package:test/test.dart';

Stream<List<int>> contents() async* {
  yield [$f, $o, $o, $cr, $lf, $b, $a, $r];
}

main() {
  test('has next', () async {
    var scanner = new Scanner(contents());
    expect(await scanner.hasNextLine(), isTrue);
  });

  test('read', () async {
    var scanner = new Scanner(contents());
    var line = await scanner.nextLine();
    expect(line, equals('foo'));
  });
}
