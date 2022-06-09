import 'dart:io';
import 'dart:convert';

/// Parses the string and returns CSV tokens.
List<String> csvLex(String line, [String separator = ',']) {
  List<String> result = [];
  final comma = separator.runes.first;
  final quote = '"'.runes.first;
  List<int> tempRunes = [];

  for (var rune in line.runes) {
    if (rune == comma || rune == quote) {
      if (tempRunes.isNotEmpty) {
        result.add(String.fromCharCodes(tempRunes));
        tempRunes.clear();
      }

      final character = String.fromCharCode(rune);
      if (result.isNotEmpty && rune == quote && result.last == character) {
        result.last += character;
      } else {
        result.add(character);
      }
    } else {
      tempRunes.add(rune);
    }
  }

  if (tempRunes.isNotEmpty) {
    result.add(String.fromCharCodes(tempRunes));
  }
  return result;
}

/// Parses the string and returns a CSV record object.
List<String> csvDecodeLine(String line, [String separator = ',']) {
  List<String> result = [];
  final quote = '"';
  final doubleQuote = '""';
  var isQuoted = false;

  var value = '';
  for (var token in csvLex(line, separator)) {
    if (token == separator) {
      if (isQuoted) {
        value += token;
      } else {
        result.add(value);
        value = '';
        isQuoted = false;
      }
    } else if (token == quote) {
      isQuoted = true;
    } else if (token == doubleQuote) {
      value += quote;
    } else {
      value += token;
    }
  }

  if (value.isNotEmpty) {
    result.add(value);
  }
  return result;
}

// TODO: Files with a new line character do not work.

/// Parses the string and returns a CSV object.
List<List<String>> csvDecode(String csv) {
  List<List<String>> result = [];
  for (var line in csv.split('\n')) {
    result.add(csvDecodeLine(line));
  }
  return result;
}

// TODO: Files with a new line character do not work.

/// Reads a CSV file from the specified path and returns a CSV object.
Future<List<List<String>>> csvRead(String path) async {
  List<List<String>> result = [];
  Stream<String> lines = File(path)
    .openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());
  await for (var line in lines) {
    result.add(csvDecodeLine(line));
  }
  return result;
}

// Parse a record and return it with dynamic types.
List<dynamic> csvParseRecord(List<String> record) {
  List<dynamic> result = [];
  for (var value in record) {
    if (int.tryParse(value) != null) {
      result.add(int.parse(value));
    } else if (double.tryParse(value) != null) {
      result.add(double.parse(value));
    } else {
      result.add(value);
    }
  }
  return result;
}
