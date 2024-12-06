import 'package:cinemapedia/config/config_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => true);

final colorListProvider = Provider((ref) => colorList);

final selectedcolorListProvider = StateProvider((ref) => 0);
final useCustomColorProvider = StateProvider<bool>((ref) => false);

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

// Controller o Notifier
class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());
  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex, useCustomColor: false);
  }

  void changeCustomColor(Color color) {
    state = state.copyWith(customColor: color, useCustomColor: true);
  }
}
