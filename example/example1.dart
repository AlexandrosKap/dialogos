import 'package:dialogos/dialogos.dart';

void main() async {
  const scenes = ['level1/hello', 'level1/alex'];

  final lineManager = LineManager();
  await lineManager.load('example/assets/lines/en.csv');

  final dialogue = Dialogue(lineManager);
  print(dialogue.startRandom(scenes));
  while (dialogue.hasNext) {
    print(dialogue.next());
  }
}
