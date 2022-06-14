import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' show File;

// TODO: Make it work.

/// Gets the line count of a file.
Future<int> getLineCount(File file) async {
  var result = 0;
  final lines = file
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter());
  await for (var line in lines) {
    result += 1;
  }
  return result;
}

/// Splits a CSV file.
void main(List<String> arguments) async {
  if (arguments.length == 2) {
    try {
      final language = File(arguments[0]);
      final partCount = int.parse(arguments[1]);

      if (language.existsSync()) {
        if (language.path.endsWith('.csv')) {
          final lineCount = await getLineCount(language);
          print(lineCount ~/ partCount);
        } else {
          print('File "${language.path}" is not a CSV file.');
        }
      }
    } on FormatException {
      print('The part count must be an integer.');
    }
  } else {
    print('Usage: split [CSV File] [Part Count]');
  }
}
