import 'dart:io';
import 'package:scanner/scanner.dart';

main() async {
  var scanner = new Scanner(stdin);

  do {
    stdout.write('Type something: ');
    var line = await scanner.nextLine();

    if (line.isEmpty || line == 'QUIT') {
      //scanner.close();
      break;
    }
    
    print('You typed: $line');
  } while(scanner.hasNextLine());

  print('Bye!');
}
