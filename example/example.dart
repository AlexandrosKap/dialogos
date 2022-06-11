import 'package:dialogos/dialogos.dart';

void main() async {
  print('');
  var lineManager = LineManager();
  await lineManager.load('example/assets/lines/languages/en.csv');

  var dialogos = Dialogue(lineManager);
  print(dialogos.start('level1/hello'));
  print(dialogos.next());
  print(dialogos.next());
}
