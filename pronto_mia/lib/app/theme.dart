import 'package:flutter/material.dart';

import 'package:pronto_mia/app/custom_colors.dart';


final theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: CustomColors.primary,
  accentColor: CustomColors.secondary,
  bottomAppBarColor: CustomColors.primary,
  scaffoldBackgroundColor: CustomColors.background,

  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.only(top: 8.0, bottom: 4.0),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(CustomColors.primary),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(CustomColors.primary),
    )
  )
);
