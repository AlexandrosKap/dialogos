import 'csv.dart';

class Awesome {
  get isAwesome => true;
}

class Line {
  final List<dynamic> _data;

  Line(this._data);

  String get emotion => _data[0];
  String get event => _data[1];
  String get name => _data[2];
  int get number => _data[3];
  double get pause => _data[4];
  String get scene => _data[5];
  String get sound => _data[6];
  String get text => _data[7];

  @override
  String toString() {
    return text;
  }
}

class LineManager {
  final Map<String, Line> _lines = {};

  Future<void> load(String csvPath) async {
    for (var record in await csvRead(csvPath)) {
      _lines[record[0]] = Line(csvParseRecord(record.sublist(1)));
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

class Dialogos {
  var _lineNumber = 0;
  var _lineSetName = '';
  List<Line> _lineSet = [];
  final LineManager _lineManager;
  
  Dialogos(this._lineManager);

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
