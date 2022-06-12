import 'dart:io';

final separator = (Platform.isWindows) ? '\\' : '/';

/// Creates a directory inside the parent directory.
Future<Directory> createDirectory(String name, Directory parent) {
  return Directory('${parent.path}$separator$name').create();
}

/// Adds a package.dhall file to a directory.
void addPackage(Directory parent) async {
  const url =
      'https://raw.githubusercontent.com/AlexandrosKap/DialogosDhallPackage/main/package.dhall\n';
  final package =
      await File('${parent.path}${separator}package.dhall').create();
  package.writeAsString(url);
}

/// Adds a template scene directory to a directory.
void addTemplate(Directory parent) async {
  final tempalte = await createDirectory('main', parent);
  final file = await File('${tempalte.path}${separator}hello.dhall').create();
  file.writeAsStringSync('''
let package = ../package.dhall

let alex = package.print "Alex"
let dioni = package.print "Dioni"

in  [ alex "Hello hello!"
    , alex "I'm Alex."
    , dioni "And I am Dioni."
    , alex "Thank you for using Dialogos."
    , alex "UwU"
    ]
''');
}

/// Creates a "lines" directory.
void main(List<String> arguments) async {
  if (arguments.length == 1) {
    final parent = Directory(arguments[0]);
    if (parent.existsSync()) {
      if (!Directory('${parent.path}${separator}lines').existsSync()) {
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
