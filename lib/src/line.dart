/// A dialogue line representation.
class Line {
  static const positionEvent = 'position';
  static const gotoEvent = 'goto';
  static const menuEvent = 'menu';

  late final String emotion;
  late final String event;
  late final String name;
  late final int number;
  late final double pause;
  late final String scene;
  late final String sound;
  late final String text;

  Line(List<dynamic> data) {
    emotion = data[0];
    event = data[1];
    name = data[2];
    number = data[3];
    pause = data[4];
    scene = data[5];
    sound = data[6];
    text = data[7];
  }

  bool get isEvent => event.isNotEmpty;
  bool get isPositionEvent => event == positionEvent;
  bool get isGotoEvent => event == gotoEvent;
  bool get isMenuEvent => event == menuEvent;

  String get firstArgument => name;
  List<String> get firstArguments => name.split('||');
  String get secondArgument => text;
  List<String> get secondArguments => text.split('||');

  @override
  String toString() {
    return text;
  }
}
