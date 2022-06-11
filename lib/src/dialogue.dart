import 'dart:math';

import 'line.dart';
import 'line_manager.dart';

class Dialogue {
  final _random = Random();
  final LineManager _lineManager;
  var _lineNumber = 0;
  var _lineScene = '';
  List<Line> _lines = [];
  
  Dialogue(this._lineManager);

  Line get line => _lines[_lineNumber];
  Line get randomLine => _lines[_random.nextInt(_lines.length)];

  void refresh() {
    _lines = _lineManager.getScene(_lineScene);
  }

  Line goto(int number) {
    if (number >= 0 && number < _lines.length) {
      _lineNumber = number;
      return line;
    } else {
      throw Exception('Number is outside range [0, ${_lines.length - 1}].');
    }
  }

  Line start(String scene) {
    _lineScene = scene;
    refresh();
    goto(0);
    return line;
  }

  Line startRandom(List<String> scenes) {
    return start(scenes[_random.nextInt(scenes.length)]);
  }

  Line next() {
    goto(_lineNumber + 1);
    return line;
  }

  Line end() {
    goto(_lines.length - 1);
    return line;
  }

  bool hasNext() {
    return _lineNumber + 1 < _lines.length;
  }
}
