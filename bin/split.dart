import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' show File;
import 'separator.dart' show separator;

/// Gets the line count of a file.
Future<int> getLineCount(File file) async {
  final lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  return lines.length;
}

/// Creates part files for a big file.
void createFilesFromFile(File file, int partCount) async {
  final lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  final fileName = file.path.replaceFirst(file.parent.path, '');
  final partName =
      '${file.parent.path}$separator${fileName}_part'.replaceFirst('.csv', '');
  final linesPerPart = await getLineCount(file) ~/ partCount;

  // Creates part files.
  if (linesPerPart > 1) {
    var partLineCount = 0;
    var partFileCount = 1;
    var partFile = await File('$partName$partFileCount.csv').create();
    var partSink = partFile.openWrite();
    await for (var line in lines) {
      partLineCount++;
      if (partLineCount > linesPerPart && partFileCount < partCount) {
        partLineCount = 1;
        partFileCount++;
        await partSink.close();
        partFile = await File('$partName$partFileCount.csv').create();
        partSink = partFile.openWrite();
      }
      partSink.writeln(line);
    }
    await partSink.close();
  } else {
    print('The lines per part count is to small.');
    print('Try again with a smaller number of parts.');
  }
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
