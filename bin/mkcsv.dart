import 'dart:io';

/// TODO: Not done but can print csv to terminal.

/// Creates a CSV file from a language directory.
void main(List<String> arguments) async {
  if (arguments.length == 1) {
    final directory = Directory(arguments[0]);
    final dhallToCsvExe = 'dhall-to-csv';

    try {
      for (var file in directory.listSync(recursive: true)) {
        if (file.path.endsWith('.dhall')) {
          final process = await Process.start(
            dhallToCsvExe,
            ['--file', file.path],
            runInShell: true
          );
          await stdout.addStream(process.stdout);
        }
      }
    } on FileSystemException {
      print('Directory does not exist.');
    }
  } else {
    print("Usage: mkcsv [Directory]");
  }
}
