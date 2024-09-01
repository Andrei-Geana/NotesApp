import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
    tertiary: Colors.green
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 22, 22, 22),
    primary: const Color.fromARGB(255, 14, 14, 14),
    secondary: const Color.fromARGB(255, 49, 49, 49),
    inversePrimary: Colors.grey.shade300,
    tertiary: Colors.green
  )
);
