import 'package:dialogos/dialogos.dart';

void main() async {
  var dialogos = Dialogos('example/example.csv');
  await dialogos.load();
  print(dialogos.lines['level2/theory11']);
}
