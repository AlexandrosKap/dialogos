import 'csv.dart';
import 'line.dart';

class LineManager {
  final Map<String, Line> _lines = {};

  Future<void> load(String path) async {
    for (var row in await csvRead(path)) {
      _lines[row[0]] = Line(row.sublist(1));
    }
  }

  List<Line> getSet(String setName) {
    List<Line> result = [];
    var index = 0;
    var code = '$setName$index';
    while (_lines[code] != null) {
      result.add(_lines[code]!);
      index++;
      code = '$setName$index';
    }
    return result;
  }
}
