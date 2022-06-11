import 'dart:io';

// TODO: Check if this works on Windows.
// TODO: Add comments.

/// Creates a CSV file from a list of dhall files.
/// It does that by using a dhall-to-csv executable from PATH.
void dhallsToCsv(String language, List<String> dhalls) async {
  const String dhallToCsvExe = 'dhall-to-csv';
  final String separator =
    (Platform.isLinux || Platform.isMacOS || Platform.isFuchsia)
    ? '/'
    : '\\';
  final String tempFile = '$language$separator.temp.dhall';

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
      .replaceFirst('$language$separator', '')
      .replaceAll(separator, '/');
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
  stderr.flush();
  file.delete();
}

/// Makes CSV files from directories with dhall files.
/// It does that by using a dhall-to-csv executable from PATH.
void main() async {
  final languagesPath =
    (Platform.isLinux || Platform.isMacOS || Platform.isFuchsia)
    ? 'assets/lines/languages'
    : 'assets\\lines\\languages';
  var hasLanguages = false;
  var hasLanguage = false;

  for (var file in Directory.current.listSync(recursive: true)) {
    if (file.path.endsWith(languagesPath) && file is Directory) {
      hasLanguages = true;
      for (var language in file.listSync()) {
        if (language is Directory) {
          hasLanguage = true;
          var hasScenes = false;
          var hasDhalls = false;
          List<String> dhalls = [];
          for (var scene in language.listSync()) {
            if (scene is Directory) {
              hasScenes = true;
              for (var dhall in scene.listSync(recursive: true)) {
                if (dhall.path.endsWith('.dhall')) {
                  hasDhalls = true;
                  dhalls.add(dhall.path);
                }
              }
            }
          }
          if (hasDhalls) {
            dhallsToCsv(language.path, dhalls);
          } else if (!hasScenes) {
            print('${language.path.replaceFirst(file.path, '')}:');
            print('  Add scene directories.');
          } else {
            print('${language.path.replaceFirst(file.path, '')}:');
            print('  Add dhall files in scene directories.');
          }
        }
      }
      break;
    }
  }

  if (hasLanguages) {
    if (!hasLanguage) {
      print('Add language directories in $languagesPath.');
    } else {
      print('Done!');
    }
  } else {
    print('Add $languagesPath somewhere in your project directory.');
  }
}
