import 'dart:io';

class ProcessModel {
  int exitCode;
  String stdout;
  String stderr;

  ProcessModel({
    this.exitCode = 0,
    this.stdout = '',
    this.stderr = '',
  });

  void copyFromProcessResult(ProcessResult result) {
    exitCode = result.exitCode;
    stdout = result.stdout as String;
    stderr = result.stderr as String;
  }

  @override
  String toString() =>
      'ProcessModel(exitCode: $exitCode, stdout: $stdout, stderr: $stderr)';
}
