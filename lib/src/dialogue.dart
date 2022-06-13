import 'dart:math' show Random;

import 'line.dart';
import 'line_manager.dart';

/// A scene player.
class Dialogue {
  final _random = Random();
  final LineManager _lineManager;
  var _lineNumber = 0;
  var _lineScene = '';
  List<Line> _lines = [];

  Dialogue(this._lineManager);

  Line get line => _lines[_lineNumber];
  Line get randomLine => _lines[_random.nextInt(_lines.length)];

  /// Updates the list of dialogue lines.
  /// Useful when the manager's lines have changed.
  void refresh() {
    _lines = _lineManager.getScene(_lineScene);
  }

  /// Goes to a specific line.
  Line goto(int number) {
    if (number >= 0 && number < _lines.length) {
      _lineNumber = number;
      return line;
    } else {
      throw Exception('Number is outside range [0, ${_lines.length - 1}].');
    }
  }

  /// Starts a new scene.
  Line start(String scene) {
    _lineScene = scene;
    refresh();
    goto(0);
    return line;
  }

  /// Starts a new random scene.
  Line startRandom(List<String> scenes) {
    return start(scenes[_random.nextInt(scenes.length)]);
  }

  /// Goes to the next line of the current scene.
  Line next() {
    goto(_lineNumber + 1);
    return line;
  }

  /// Goes to the last line of the current scene.
  Line end() {
    goto(_lines.length - 1);
    return line;
  }

  /// Checks if the current scene has one more line.
  bool hasNext() {
    return _lineNumber + 1 < _lines.length;
  }
}
