import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' show File;

import 'package:path/path.dart' as p;

// TODO: Works but I don't like how it works. Change it.
// TODO: Split by looking at scenes.

/// Gets the line count of a file.
Future<int> getLineCount(File file) async {
  final lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  return lines.length;
}

/// Creates part files for a big file.
void createFilesFromFile(File file, int partCount) async {
  final fileName = p.basenameWithoutExtension(file.path);
  final partName = p.join(file.parent.path, fileName, '_part');
  final lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());

  // Creates part files.
  print('NOT DONE!');
  print(partName);
}

/// Splits a CSV file.
void main(List<String> arguments) async {
  if (arguments.length == 2) {
    try {
      final language = File(arguments[0]);
      final partCount = int.parse(arguments[1]);

      if (language.existsSync()) {
        if (language.path.endsWith('.csv')) {
          createFilesFromFile(language, partCount);
        } else {
          print('File "${language.path}" is not a CSV file.');
        }
      } else {
        print('Argument "${language.path}" is not a file.');
      }
    } on FormatException {
      print('The part count must be an integer.');
    }
  } else {
    print('Usage: split [CSV File] [Part Count]');
  }
}
