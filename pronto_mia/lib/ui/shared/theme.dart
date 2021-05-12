import 'package:flutter/material.dart';

import 'package:pronto_mia/ui/shared/custom_colors.dart';

final theme = ThemeData.light().copyWith(
  primaryColor: CustomColors.primary,
  accentColor: CustomColors.secondary,
  bottomAppBarColor: CustomColors.primary,
  dividerColor: CustomColors.divider,
  shadowColor: CustomColors.shadow,
  colorScheme: const ColorScheme.light(primary: CustomColors.primary),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: CustomColors.primary,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(CustomColors.primary),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(CustomColors.link),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: CustomColors.negativeText,
  )
);
