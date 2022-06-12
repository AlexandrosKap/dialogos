import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:archive/archive_io.dart' show extractFileToDisk;

// TODO: Think about how to install the dhall package.
// TODO: Make it work.

final separator =
  (Platform.isWindows)
  ? '\\'
  : '/';

String makePath(List<String> names) {
  var result = '';
  for (var name in names) {
    result += '$name$separator';
  }
  return result;
}

Future<Directory> createDirectory(String name, Directory parent) {
  return Directory('${parent.path}$separator$name').create();
}

Future<Directory> createDhallPackage(Directory parent) async {
    final temp = await File('${parent.path}_ddptemp.zip').create();
    await temp.writeAsBytes(await http.readBytes(Uri.parse('ddd')));
    await extractFileToDisk(temp.path, parent.path);
    temp.delete(recursive: true);
    return Directory('${parent.path}${separator}DialogosDhallPackage');
}

/// Creates a "lines" directory.
void main(List<String> arguments) async {
  if (arguments.length == 1) {
    final directory = Directory(arguments[0]);
    if (directory.existsSync()) {
      final lines = await createDirectory('lines', directory);
      final languages = await createDirectory('languages', lines);
      //final dhallPackage = await createDhallPackage(lines);
      final en = await createDirectory('en', languages);
    } else {
      print('Argument "${directory.path}" is not a directory.');
    }
  } else {
    print('Usage: create [Directory]');
  }
}
