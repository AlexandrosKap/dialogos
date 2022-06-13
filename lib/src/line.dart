/// A dialogue line representation.
class Line {
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

  @override
  String toString() {
    return text;
  }
}
