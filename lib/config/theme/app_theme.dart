import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
];

final colorNames = <Color, String>{
  Colors.blue: 'Blue',
  Colors.teal: 'Teal',
  Colors.green: 'Green',
  Colors.red: 'Red',
  Colors.purple: 'Purple',
  Colors.deepPurple: 'Deep Purple',
  Colors.orange: 'Orange',
  Colors.pink: 'Pink',
  Colors.pinkAccent: 'Pink Accent',
};

class AppTheme {
  final int?
      selectedColor; // Cambiado a nullable para manejar el color personalizado
  final Color? customColor; // Nuevo campo para el color personalizado
  final bool isDarkMode;
  final bool useCustomColor;

  AppTheme({
    this.selectedColor,
    this.customColor,
    this.isDarkMode = false,
    this.useCustomColor = false,
  }) : assert(
          selectedColor == null ||
              (selectedColor >= 0 && selectedColor < colorList.length),
          'Selected color index must be between 0 and ${colorList.length - 1}',
        );

  Color get activeColor => useCustomColor && customColor != null
      ? customColor!
      : colorList[selectedColor ?? 0];

  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkMode,
    Color? customColor,
    bool? useCustomColor,
  }) {
    return AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      customColor: customColor ?? this.customColor,
      useCustomColor: useCustomColor ?? this.useCustomColor,
    );
  }

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: activeColor,
        appBarTheme: const AppBarTheme(centerTitle: false),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      );
}
