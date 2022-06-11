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
