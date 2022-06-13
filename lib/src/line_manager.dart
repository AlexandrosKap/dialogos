import 'dart:convert' show utf8;
import 'dart:io' show File, Platform;

import 'package:csv/csv.dart' show CsvToListConverter;

import 'line.dart';

/// A line manager.
class LineManager {
  final Map<String, Line> _lines = {};

  /// Loads lines from a CSV file.
  /// The path can also contain '/' on Windows.
  Future<void> load(String path) async {
    if (Platform.isWindows) {
      path = path.replaceAll('/', '\\');
    }
    final csv = await File(path)
        .openRead()
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

  /// Gets a line from the lines map by using a code.
  Line getLine(String code) {
    final result = _lines[code];
    if (result == null) {
      throw Exception('Code does not exist.');
    }
    return result;
  }

  /// Gets all lines that belong to a specific scene.
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
