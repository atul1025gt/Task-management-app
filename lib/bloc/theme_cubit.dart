// TODO: Theme Cubit for light/dark mode
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
