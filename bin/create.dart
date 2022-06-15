import 'dart:io' show File, Directory;

import 'package:path/path.dart' as p;

/// Creates a directory inside a directory.
Future<Directory> createDirectory(String name, Directory parent) {
  return Directory(p.join(parent.path, name)).create();
}

/// Adds a package.dhall file to a directory.
void addPackage(Directory parent) async {
  const url =
      'https://raw.githubusercontent.com/AlexandrosKap/DialogosDhallPackage/main/package.dhall\n';
  final package = await File(p.join(parent.path, 'package.dhall')).create();
  package.writeAsString(url);
}

/// Adds a template scene directory to a directory.
void addTemplate(Directory parent) async {
  final tempalte = await createDirectory('main', parent);
  final file = await File(p.join(tempalte.path, 'hello.dhall')).create();
  file.writeAsStringSync('''
let package = ../package.dhall

let ali = package.print "Ali"

in  [ ali "Hello hello!"
    , ali "I'm Ali."
    , ali "Thank you for using Dialogos."
    , ali "UwU"
    ]
''');
}

/// Creates a "lines" directory.
void main(List<String> arguments) async {
  if (arguments.length == 1) {
    final parent = Directory(arguments[0]);
    if (parent.existsSync()) {
      if (!Directory(p.join(parent.path, 'lines')).existsSync()) {
        final lines = await createDirectory('lines', parent);
        final en = await createDirectory('en', lines);
        addPackage(en);
        addTemplate(en);
      } else {
        print('A "lines" directory already exists in "${parent.path}".');
      }
    } else {
      print('Argument "${parent.path}" is not a directory.');
    }
  } else {
    print('Usage: create [Directory]');
  }
}
