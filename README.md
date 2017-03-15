# scanner

[![version 1.0.0](https://img.shields.io/badge/pub-1.0.0-brightgreen.svg)](https://pub.dartlang.org/packages/scanner)
[![build status](https://travis-ci.org/thosakwe/scanner.svg)](https://travis-ci.org/thosakwe/scanner)

Port of Java's Scanner class to Dart.
Works asynchronously.

# Usage
Printing the contents of a file:

```dart
import 'dart:io';
import 'package:scanner/scanner.dart';

main() async {
  var file = new File.fromUri(Platform.script.resolve('../README.md'));
  var scanner = new Scanner(file.openRead());

  while (await scanner.hasNextLine()) {
    print(await scanner.nextLine());
  }
}
```
