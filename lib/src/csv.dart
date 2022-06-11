import 'dart:convert' show utf8;
import 'dart:io' show File;
import 'package:csv/csv.dart' show CsvToListConverter;

Future<List<List<dynamic>>> csvRead(String path) {
  return File(path).openRead()
    .transform(utf8.decoder)
    .transform(CsvToListConverter())
    .toList();
}
