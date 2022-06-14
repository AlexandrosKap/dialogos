import 'dart:io' show Platform;

final separator = (Platform.isWindows) ? '\\' : '/';

/// Prints the path separator.
void main() {
  print('The path saparator for this system is "$separator".');
}
