# Dialogos

An experimental dialogue system for Dart.

## Features

* 😍 Tooling
* 😁 Language files
* 🤔 Lines are referenced by a line code
* 😎 Lines are grouped by scene
* 😮 Event lines that can be customized
* 🥺 Variables

## Getting started

Clone and run the example:

```sh
git clone https://github.com/AlexandrosKap/dialogos.git
cd dialogos
dart pub get
dart run example/example1.dart
```

## Usage

### Tooling

Dialogos includes a helpful script called "dialogos.dart".
This script has to commands:

* create
* transpile

The "create" command will create
a new "lines" directory.
This directory will contain language directories.

Example:

```sh
dart run dialogos create .
```

The "transpile" command will create
language files for every language directory inside a "lines" directory.
The language files are CSV files that contain all the lines for that language.

Example:

```sh
# Make sure that "." has a "lines" directory.
dart run dialogos transpile .
```

## Additional information

### Language files

Lnguage files are CSV files that contain all the lines for that language.
These are the files that will be loaded by a game engine or a program.
