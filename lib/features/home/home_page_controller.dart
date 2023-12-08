import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/models/process_model.dart';
import 'home_page_state.dart';

class HomePageController extends ChangeNotifier {
  final _process = ProcessModel();
  String _baseDir = '';
  String _projectDir = '';
  String _keyStorageDir = '';

  ProcessModel get process => _process;
  String get projectDir => _projectDir;
  String get keyStorageDir => _keyStorageDir;

  set projectDir(String dirName) {
    _projectDir = dirName;
    notifyListeners();
  }

  set keyStorageDir(String dirName) {
    _keyStorageDir = dirName;
    notifyListeners();
  }

  HomePageState _state = HomePageStateInitial();

  HomePageState get state => _state;

  void _changeState(HomePageState newState) {
    _state = newState;
    notifyListeners();
  }

  void init() {
    _starting();
  }

  Future<void> execute(String command, List<String> arguments) async {
    _changeState(HomePageStateLoading());
    try {
      ProcessResult result = await Process.run(command, arguments);
      _process.copyFromProcessResult(result);
      // await _getDirectories();
      _changeState(HomePageStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(HomePageStateError());
    }
  }

  Future<void> _starting() async {
    _changeState(HomePageStateLoading());
    try {
      await _getDirectories();
      _changeState(HomePageStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(HomePageStateError());
    }
  }

  Future<void> _getDirectories() async {
    final directory = await getApplicationDocumentsDirectory();
    // final directory = await getApplicationCacheDirectory();

    _baseDir = directory.parent.path;
    _keyStorageDir = _baseDir;
    _projectDir = Directory.current.path; //directory.path;

    log(Directory.current.toString());
  }
}
