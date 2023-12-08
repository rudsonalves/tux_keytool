import 'package:flutter/material.dart';

class AppSettings {
  AppSettings._();
  static final AppSettings _instance = AppSettings._();
  static AppSettings get instance => _instance;

  final validaty$ = ValueNotifier<int>(10);
  final isSinglePass$ = ValueNotifier<bool>(false);
  final themeMode$ = ValueNotifier<ThemeMode>(ThemeMode.system);
  final numberChar$ = ValueNotifier<int>(24);

  int get validaty => validaty$.value;
  bool get isSinglePass => isSinglePass$.value;
  ThemeMode get themeMode => themeMode$.value;
  int get numberChar => numberChar$.value;

  set validaty(int value) => validaty$.value = value;
  set isSinglePass(bool value) => isSinglePass$.value = value;
  set themeMode(ThemeMode value) => themeMode$.value = value;
  set numberChar(int value) => numberChar$.value = value;
}
