import 'dart:convert' show utf8;
import 'dart:io' show File;
import 'package:csv/csv.dart' show CsvToListConverter;
import 'line.dart';

class LineManager {
  final Map<String, Line> _lines = {};

  Future<void> load(String path) async {
    final csv = await File(path).openRead()
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .toList();
    var isFirst = true;
    for (var row in csv) {
      if (isFirst) {
        isFirst = false;
      } else {
        _lines[row[0]] = Line(row.sublist(1));
      }
    }
  }

  Line getLine(String code) {
    final result = _lines[code];
    if (result == null) {
      throw Exception('Code does not exist.');
    }
    return result;
  }

  List<Line> getScene(String scene) {
    List<Line> result = [];
    var index = 0;
    var code = '$scene$index';
    var line = _lines[code];
    while (line != null) {
      result.add(line);
      index++;
      code = '$scene$index';
      line = _lines[code];
    }
    if (result.isEmpty) {
      throw Exception('Scene does not exist.');
    }
    return result;
  }
}
