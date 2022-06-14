import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' show File, FileMode, Directory, Platform, Process;
import 'package:archive/archive_io.dart' show extractFileToDisk;
import 'package:http/http.dart' as http;

/// Gets the url of the dhall-to-csv executable for the current OS.
Uri getUrl() {
  const windows =
      'https://github.com/dhall-lang/dhall-haskell/releases/download/1.41.1/dhall-csv-1.0.2-x86_64-windows.zip';
  const linux =
      'https://github.com/dhall-lang/dhall-haskell/releases/download/1.41.1/dhall-csv-1.0.2-x86_64-linux.tar.bz2';
  const macos =
      'https://github.com/dhall-lang/dhall-haskell/releases/download/1.41.1/dhall-csv-1.0.2-x86_64-macos.tar.bz2';

  if (Platform.isLinux) {
    return Uri.parse(linux);
  } else if (Platform.isWindows) {
    return Uri.parse(windows);
  } else {
    return Uri.parse(macos);
  }
}

/// Gets the temporary archive file.
Future<File> getTemp() {
  if (Platform.isWindows) {
    return File('${Directory.current.path}_temp_.zip').create();
  } else {
    return File('${Directory.current.path}_temp_.tar.bz2').create();
  }
}

/// Installs the dhall-to-csv executable inside the current directory.
/// The executable is saved as ".dhall-to-csv.exe".
Future<void> install(Directory dhallParent) async {
  final File exe;
  if (Platform.isWindows) {
    exe = File('${dhallParent.path}\\bin\\dhall-to-csv.exe');
    await exe.copy('${Directory.current.path}\\.dhall-to-csv.exe');
  } else {
    exe = File('${dhallParent.path}/bin/dhall-to-csv');
    final output =
        await exe.copy('${Directory.current.path}/.dhall-to-csv.exe');
    await Process.run('chmod', ['+x', output.path]);
  }
  exe.parent.delete(recursive: true);
}

/// Adds .dhall-to-csv.exe to the .gitignore file.
void addToGitignore() async {
  var canAdd = false;
  for (var file in Directory.current.listSync()) {
    if (file.path.endsWith('gitignore')) {
      canAdd = true;
      final lines = (file as File)
          .openRead()
          .transform(utf8.decoder)
          .transform(LineSplitter());
      await for (var line in lines) {
        if (line == '.dhall-to-csv.exe') {
          canAdd = false;
          break;
        }
      }
      break;
    }
  }

  if (canAdd) {
    await File('.gitignore')
        .writeAsString('.dhall-to-csv.exe', mode: FileMode.append);
  }
}

/// Checks if .dhall-to-csv.exe exists.
bool hasExe() {
  for (var file in Directory.current.listSync()) {
    if (file.path.endsWith('.dhall-to-csv.exe')) {
      return true;
    }
  }
  return false;
}

/// Downloads dhall-to-csv that dialogos depends on.
Future<void> main() async {
  addToGitignore();
  if (!hasExe()) {
    print('Downloading dhall-to-csv.');
    final temp = await getTemp();
    await temp.writeAsBytes(await http.readBytes(getUrl()));
    await extractFileToDisk(temp.path, temp.parent.path);
    await install(temp.parent);
    temp.delete();
  }
}
