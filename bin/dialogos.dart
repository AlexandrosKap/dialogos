import 'create.dart' as create;
import 'transpile.dart' as transpile;

/// Return a sublist or an empty list if start is not inside list length.
List<String> sublist(List<String> list, int start) {
  return start >= 0 && start < list.length ? list.sublist(start) : [];
}

/// Skips an element of a list.
List<String> skipOne(List<String> list) {
  return sublist(list, 1);
}

/// A script that runs other scripts.
void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    final command = arguments[0];
    if (command == 'create') {
      create.main(skipOne(arguments));
    } else if (command == 'transpile') {
      transpile.main(skipOne(arguments));
    } else {
      print('Command "$command" does not exist.');
    }
  } else {
    print('Usage: dialogos [Command] [Arguments]');
    print('Commands:');
    print('  - create: Creates a "lines" directory.');
    print('  - transpile: Creates CSV files from a "lines" direcrory.');
  }
}
