import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('Creating files...');

  // Run `dart run build_runner -d` after generation.
  await Process.run('dart', ['run', 'build_runner', '-d']);

  progress.complete();
}
