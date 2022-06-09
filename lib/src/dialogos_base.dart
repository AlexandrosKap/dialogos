import 'csv.dart';

class Awesome {
  get isAwesome => true;
}

class Line {
  List<dynamic> data;

  Line(this.data);

  String get emotion => data[0];
  String get event => data[1];
  String get name => data[2];
  int get number => data[3];
  double get pauseEnd => data[4];
  double get pauseStart => data[5];
  String get scene => data[6];
  String get set => data[7];
  String get sound => data[8];
  String get text => data[9];

  @override
  String toString() {
    return text;
  }
}

class Dialogos {
  String csvPath;
  Map<String, Line> lines = {};

  Dialogos(this.csvPath);

  Future<void> load() async {
    for (var record in await csvRead(csvPath)) {
      lines[record[0]] = Line(record.sublist(1));
    }
  }

  void play() {
    print('play');
  }
}
