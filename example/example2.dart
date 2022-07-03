import 'dart:io' show stdin;

import 'package:dialogos/dialogos.dart';

String showMenu(Line event) {
  final positions = event.firstArguments;
  final options = event.secondArguments;

  // Print options.
  print('');
  var index = 0;
  for (var option in options) {
    print('$index => $option');
    index++;
  }

  // Returns a position from the options.
  print('Enter a option:');
  while(true) {
    final number = int.tryParse(stdin.readLineSync() ?? '');
    if (number != null && number >= 0 && number < options.length) {
      print('');
      return positions[number];
    }
  }
}

void main() async {
  const scene = 'level2/options';

  final lineManager = LineManager();
  await lineManager.load('example/assets/lines/en.csv');
  final dialogue = Dialogue(lineManager);

  dialogue.start(scene);
  while (dialogue.hasNext) {
    final line = dialogue.line;
    if (line.isMenuEvent) {
      print(dialogue.gotoPosition(showMenu(line)));
    } else {
      print(line);
    }
    dialogue.next();
  }
}
