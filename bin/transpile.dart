import 'dart:io' show File, Directory, Platform, Process, stderr;

import 'package:path/path.dart' as p;

import 'setup.dart' as setup;

const exeName = '.dhall-to-csv.exe';

/// Gets the lines directory inside assets.
Directory getLines(Directory assets) {
  return Directory(p.join(assets.path, 'lines'));
}

/// Creates a CSV file for a language directory.
void createCsv(Directory language) async {
  // Find Dhall files inside the language directory.
  List<File> dhalls = [];
  for (var scene in language.listSync()) {
    if (scene is Directory) {
      for (var dhall in scene.listSync(recursive: true)) {
        if (dhall.path.endsWith('.dhall')) {
          dhalls.add(dhall as File);
        }
      }
    }
  }

  if (dhalls.isNotEmpty) {
    // Create a temporary Dhall file containing all Dhall files.
    final separator = Platform.isWindows ? '\\' : '/';
    final temp = await File(p.join(language.path, '.temp.dhall')).create();
    final sink = temp.openWrite();
    sink.write('''
      let package = ./package.dhall
      let Line = package.Line
      let addSceneToList = package.addSceneToList
      in
      ''');
    for (var dhall in dhalls) {
      final scene = dhall.path
          .substring(0, dhall.path.lastIndexOf('.dhall'))
          .replaceFirst('${language.path}$separator', '')
          .replaceAll(separator, '/');
      sink.writeln('(addSceneToList "$scene" (.$separator$scene.dhall))#');
    }
    sink.writeln('([] : List Line)');
    await sink.close();

    // Transpile the temporary Dhall file to a CSV and delete it.
    final process = await Process.start(p.join('.', exeName),
        ['--file', temp.path, '--output', '${language.path}.csv']);
    await stderr.addStream(process.stderr);
    await stderr.flush();
    temp.delete();
  } else {
    print('Add directories with dhall files inside "${language.path}".');
  }
}

/// Creates CSV files from a "lines" direcrory.
void main(List<String> arguments) async {
  await setup.main();
  if (arguments.length == 1) {
    final assets = Directory(arguments[0]);
    final lines = getLines(assets);
    if (lines.existsSync()) {
      var hasLanguage = false;
      for (var language in lines.listSync()) {
        if (language is Directory) {
          hasLanguage = true;
          createCsv(language);
        }
      }
      if (!hasLanguage) {
        print('Add language directories inside "${lines.path}".');
      }
    } else {
      if (assets.existsSync()) {
        print('Add a "lines" directory inside "${assets.path}".');
      } else {
        print('Argument "${assets.path}" is not a directory.');
      }
    }
  }
  if (arguments.isEmpty) {
    print("Usage: transpile [Assets Directory]");
  }
}
