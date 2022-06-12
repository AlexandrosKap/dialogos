import 'dart:io';

// Need works but works.
// TODO: Check if .gitignore has dhall line.
// TODO: Clean it.

// ignore: depend_on_referenced_packages
import 'package:archive/archive_io.dart' show extractFileToDisk;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

Uri getUrl() {
  const windows = 'https://github.com/dhall-lang/dhall-haskell/releases/download/1.41.1/dhall-csv-1.0.2-x86_64-windows.zip';
  const linux = 'https://github.com/dhall-lang/dhall-haskell/releases/download/1.41.1/dhall-csv-1.0.2-x86_64-linux.tar.bz2';
  const macos = 'https://github.com/dhall-lang/dhall-haskell/releases/download/1.41.1/dhall-csv-1.0.2-x86_64-macos.tar.bz2';

  if (Platform.isLinux) {
    return Uri.parse(linux);
  } else if (Platform.isWindows) {
    return Uri.parse(windows);
  } else {
    return Uri.parse(macos);
  }
}

Future<File> getTemp() {
  if (Platform.isWindows) {
    return File('${Directory.current.path}_temp_.zip').create();
  } else {
    return File('${Directory.current.path}_temp_.tar.bz2').create();
  }
}

Future<void> install(Directory parent) async {
  final File exe;
  if (Platform.isWindows) {
    await File('.gitignore').writeAsString(
      'dhall-to-csv.exe', mode: FileMode.append
    );
    exe = File('${parent.path}\\bin\\dhall-to-csv.exe');
    await exe.copy('${Directory.current.path}\\dhall-to-csv.exe');
  } else {
    await File('.gitignore').writeAsString(
      'dhall-to-csv', mode: FileMode.append
    );
    exe = File('${parent.path}/bin/dhall-to-csv');
    final output = await exe.copy('${Directory.current.path}/dhall-to-csv');
    final process = await Process.start('chmod', ['+x', output.path]);
    await stderr.addStream(process.stderr);
    stderr.flush();
  }
  exe.parent.delete(recursive: true);
}

bool hasExe() {
  final directory = Directory.current.path;
  for (var file in Directory.current.listSync()) {
    if (Platform.isWindows) {
      if (file.path.replaceFirst('$directory\\', '') == 'dhall-to-csv.exe') {
        return true;
      }
    } else {
      if (file.path.replaceFirst('$directory/', '') == 'dhall-to-csv') {
        return true;
      }
    }
  }
  return false;
}

/// Downloads dhall-to-csv that mkcsv depends on.
Future<void> main() async {
  if (!hasExe()) {
    print('Downloading dhall-to-csv.');
    final temp = await getTemp();
    await temp.writeAsBytes(await http.readBytes(getUrl()));
    await extractFileToDisk(temp.path, temp.parent.path);
    await install(temp.parent);
    temp.delete();
  }
}
