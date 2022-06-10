import 'dart:io';

// TODO: Works but check it again.

void dhallsToCsv(String language, List<String> dhalls) async {
  final String dhallToCsvExe;
  final String tempFile;
  final String separator;

  if (Platform.isLinux || Platform.isMacOS || Platform.isFuchsia) {
    dhallToCsvExe = 'dhall-to-csv';
    separator = '/';
  } else {
    dhallToCsvExe = 'dhall-to-csv.exe';
    separator = '\\';
  }
  tempFile = '$language$separator.temp.dhall';

  final file = await File(tempFile).create();
  final sink = file.openWrite();
  sink.write(
'''
let package = ./package.dhall
let Line = package.Line
let addSceneToList = package.addSceneToList
in
'''
  );
  for (var dhall in dhalls) {
    final scene = dhall
      .substring(0, dhall.lastIndexOf('.dhall'))
      .replaceFirst('$language$separator', '');
    sink.write(
      '(addSceneToList "$scene" ($dhall))#\n'
    );
  }
  sink.write('([] : List Line)\n');
  await sink.close();

  final languageName = language
    .substring(language.lastIndexOf(separator) + 1, language.length);
  final outputFile = '$language$separator..$separator$languageName.csv';
  final process = await Process.start(
    dhallToCsvExe,
    ['--file', tempFile, '--output', outputFile],
    runInShell: true
  );
  await stderr.addStream(process.stderr);
  file.delete();
}

/// Make CSV files from language directories.
void main() async {
  final languages =
    (Platform.isLinux || Platform.isMacOS || Platform.isFuchsia)
    ? 'assets/lines/languages'
    : 'assets\\lines\\languages';

  for (var file in Directory.current.listSync(recursive: true)) {
    if (file.path.endsWith(languages) && file is Directory) {
      for (var language in file.listSync()) {
        if (language is Directory) {
          List<String> dhalls = [];
          for (var scene in language.listSync()) {
            if (scene is Directory) {
              for (var dhall in scene.listSync(recursive: true)) {
                if (dhall.path.endsWith('.dhall')) {
                  dhalls.add(dhall.path);
                }
              }
            }
          }
          dhallsToCsv(language.path, dhalls);
        }
      }
      break;
    }
  }
}
