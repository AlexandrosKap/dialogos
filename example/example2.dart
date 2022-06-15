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
      print('\n${line.menuEventPositions}');
      print('${line.menuEventOptions}\n');
      print(dialogue.gotoPosition(line.menuEventPositions[0]));
    } else {
      print(line);
    }
  }
}
