import 'dart:io';
import 'package:scanner/scanner.dart';

main() async {
  var file = new File.fromUri(Platform.script.resolve('../README.md'));
  var scanner = new Scanner(file.openRead());

  while (await scanner.hasNextLine()) {
    print(await scanner.nextLine());
  }
}
