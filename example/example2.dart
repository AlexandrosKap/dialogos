import 'package:dialogos/dialogos.dart';

// Testing the menu event.

void main() async {
  const scenes = ['level2/options'];

  final lineManager = LineManager();
  await lineManager.load('example/assets/lines/en.csv');

  final dialogue = Dialogue(lineManager);
  print(dialogue.startRandom(scenes));
  while (dialogue.hasNext) {
    final line = dialogue.next();

    if (line.isMenuEvent) {
      print('');
      print(line.firstArguments);
      print(line.secondArguments);
      print('');

      dialogue.select(line.secondArguments.length - 1);
    } else {
      print(line);
    }
  }
}
