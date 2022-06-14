import 'create.dart' as create;
import 'split.dart' as split;
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
    final subArguments = skipOne(arguments);
    switch (command) {
      case 'create':
        create.main(subArguments);
        break;
      case 'split':
        split.main(subArguments);
        break;
      case 'transpile':
        transpile.main(subArguments);
        break;
      default:
        print('Command "$command" does not exist.');
    }
  } else {
    print('Usage: dialogos [Command] [Arguments]');
    print('Commands:');
    print('  - create: Creates a "lines" directory.');
    print('  - split: Splits a CSV file.');
    print('  - transpile: Creates CSV files from a "lines" direcrory.');
  }
}
