import 'dart:io';

import 'setup.dart' as setup;

final separator =
  (Platform.isWindows)
  ? '\\'
  : '/';

/// Gets the lines directory inside assets.
Directory getLines(Directory assets) {
  return Directory('${assets.path}${separator}lines');
}

/// Gets the languages directory insdie lines.
Directory getLanguages(Directory lines) {
  return Directory('${lines.path}${separator}languages');
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
    final temp = await File('${language.path}$separator.temp.dhall').create();
    final sink = temp.openWrite();
    sink.write(
      '''
      let package = ./package.dhall
      let Line = package.Line
      let addSceneToList = package.addSceneToList
      in
      '''
    );
    for (var dhall in dhalls) {
      final scene = dhall.path
        .substring(0, dhall.path.lastIndexOf('.dhall'))
        .replaceFirst('${language.path}$separator', '')
        .replaceAll(separator, '/');
      sink.write('(addSceneToList "$scene" (.$separator$scene.dhall))#\n');
    }
    sink.write('([] : List Line)\n');
    await sink.close();

    // Transpile the temporary Dhall file to a CSV and delete it.
    final process = await Process.start(
      '.$separator.dhall-to-csv.exe',
      ['--file', temp.path, '--output', '${language.path}.csv']
    );
    await stderr.addStream(process.stderr);
    await stderr.flush();
    temp.delete();
  } else {
    print('Add directories with dhall files inside ${language.path}.');
  }
}

/// Finds the Lines directory and creates CSV files.
void main(List<String> arguments) async {
  await setup.main();
  for (var argument in arguments) {
    final assets = Directory(argument);
    final lines = getLines(assets);
    if (lines.existsSync()) {
      final languages = getLanguages(lines);
      if (languages.existsSync()) {
        final languagesFiles = languages.listSync();
        for (var language in languagesFiles) {
          if (language is Directory) {
            createCsv(language);
          }
        }
        if (languagesFiles.isEmpty) {
          print('Add language directories inside ${languages.path}.');
        }
      } else {
        print('Add a "languages" directory inside ${lines.path}.');
      }
    } else {
      if (assets.existsSync()) {
        print('Add a "lines" directory inside ${assets.path}.');
      } else {
        print('Argument "${assets.path}" is not a directory.');
      }
    }
  }
  if (arguments.isEmpty) {
    print("Usage: dialogos [Assets Directory]");
  }
}
