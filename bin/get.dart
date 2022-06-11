import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:archive/archive_io.dart' as archive;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// A lot of work is needed. Can download for now.

/// Downloads the dhall-to-csv executable that mkcsv depends on.
void main() async {
  final String temp = '${Directory.current.path}_dhall_temp';
  final url = Uri.parse('https://github.com/dhall-lang/dhall-haskell/releases/download/1.41.1/dhall-csv-1.0.2-x86_64-linux.tar.bz2');

  final file = await File(temp).create();
  await file.writeAsBytes(await http.readBytes(url));

  final process = await Process.start('tar', ['-xf', temp, '-C', '..']);
  await stderr.addStream(process.stderr);
  file.delete();
}
