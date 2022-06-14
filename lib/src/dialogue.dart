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
  Map<String, int> _positions = {};

  Dialogue(this._lineManager);

  Line get line => _lines[_lineNumber];
  Line get randomLine => _lines[_random.nextInt(_lines.length)];

  /// Checks if the current scene has one more line.
  bool get hasNext => _lineNumber + 1 < _lines.length;

  void _gotoEventProcess() {
    _lineNumber = _positions[line.text] ?? _lineNumber;
    if (hasNext) {
      _lineNumber++;
    }
  }

  /// Updates the list of dialogue lines.
  /// Useful when the manager's lines have changed.
  void refresh() {
    _lines = _lineManager.getScene(_lineScene);
  }

  /// Goes to a specific line.
  Line goto(int number) {
    if (number >= 0 && number < _lines.length) {
      _lineNumber = number;
      switch (line.event) {
        case Line.gotoEvent:
          _gotoEventProcess();
          break;
        case Line.menuEvent:
          break;
      }
      return line;
    } else {
      throw Exception('Number is outside range [0, ${_lines.length - 1}].');
    }
  }

  /// Menu function... Testing ...
  void select(int option) {
    goto(_positions[line.firstArguments[option]] ?? _lineNumber);
  }

  /// Starts a new scene.
  Line start(String scene) {
    _lineScene = scene;
    refresh();

    // Creates new positions.
    _positions.clear();
    var index = 0;
    for (var line in _lines) {
      if (line.isPositionEvent) {
        _positions[line.text] = index;
      }
      index++;
    }

    return goto(0);
  }

  /// Starts a new random scene.
  Line startRandom(List<String> scenes) {
    return start(scenes[_random.nextInt(scenes.length)]);
  }

  /// Goes to the next line of the current scene.
  Line next() {
    return goto(_lineNumber + 1);
  }

  /// Goes to the last line of the current scene.
  Line end() {
    return goto(_lines.length - 1);
  }
}
