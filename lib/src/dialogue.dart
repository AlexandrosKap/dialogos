import 'line.dart';
import 'line_manager.dart';

class Dialogue {
  var _lineNumber = 0;
  var _lineSetName = '';
  List<Line> _lineSet = [];
  final LineManager _lineManager;
  
  Dialogue(this._lineManager);

  get line => _lineSet[_lineNumber];

  void refresh() {
    _lineSet = _lineManager.getSet(_lineSetName);
  }

  void goto(int number) {
    _lineNumber = number;
    if (_lineNumber <= 0) {
      _lineNumber = 0;
    } else if (_lineNumber >= _lineSet.length) {
      _lineNumber = _lineSet.length - 1;
    } else {
      _lineNumber = number;
    }
  }

  Line start(String lineSetName) {
    _lineSetName = lineSetName;
    _lineSet = _lineManager.getSet(_lineSetName);
    goto(0);
    return line;
  }

  Line next() {
    goto(_lineNumber + 1);
    return line;
  }
}
