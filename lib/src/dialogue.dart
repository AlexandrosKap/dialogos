import 'dart:math' show Random;

import 'line.dart';
import 'line_manager.dart';

/// A scene player.
class Dialogue {
  final _random = Random();
  final LineManager _lineManager;
  final Map<String, int> _positions = {};

  var _lineNumber = 0;
  var _lineScene = '';
  List<Line> _lines = [];

  Dialogue(this._lineManager);

  Line get line => _lines[_lineNumber];
  Line get randomLine => _lines[_random.nextInt(_lines.length)];

  /// Checks if the current scene has one more line.
  bool get hasNext => _lineNumber + 1 < _lines.length;

  /// Called when the goto functions find a position event.
  void _onPositionEvent() {
    if (hasNext) {
      next();
    }
  }

  /// Called when the goto functions find a goto event.
  void _onGotoEvent() {
    gotoPosition(line.secondArgument);
  }

  /// Updates the list of dialogue lines.
  /// Useful when the manager's lines have changed.
  void refresh() {
    _lines = _lineManager.getScene(_lineScene);
  }

  /// Goes to a specific line.
  Line gotoLine(int number) {
    if (number >= 0 && number < _lines.length) {
      _lineNumber = number;
      if (line.isPositionEvent) {
        _onPositionEvent();
      } else if (line.isGotoEvent) {
        _onGotoEvent();
      }
      return line;
    } else {
      throw Exception('Line number "$number" is too big or too small.');
    }
  }

  /// Goes to a specific position.
  Line gotoPosition(String position) {
    final number = _positions[position];
    if (number != null) {
      return gotoLine(number);
    } else {
      throw Exception('Position "$position" does not exist.');
    }
  }

  /// Goes to the first line of the current scene.
  /// Enter a scene to start a new scene.
  Line start(String? scene) {
    if (scene != null) {
      _lineScene = scene;
      refresh();

      // Creates new positions.
      _positions.clear();
      var index = 0;
      for (var line in _lines) {
        if (line.isPositionEvent) {
          _positions[line.secondArgument] = index;
        }
        index++;
      }
    }
    return gotoLine(0);
  }

  /// Starts a new random scene.
  Line startRandom(List<String> scenes) {
    return start(scenes[_random.nextInt(scenes.length)]);
  }

  /// Goes to the next line of the current scene.
  Line next() {
    return gotoLine(_lineNumber + 1);
  }

  /// Goes to the last line of the current scene.
  Line end() {
    return gotoLine(_lines.length - 1);
  }
}
