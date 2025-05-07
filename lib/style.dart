import 'package:flutter/material.dart';

class KColors {
  //orangeBrule
  static const  Color primary =  Color(0xFFD35400);
  //creme
  static const Color secondary = Color(0xFFFFF5E1);
  //brunCacao
  static const Color tertiary = Color(0xFF6E2C00);
  static const Color vertOlive = Color(0xFFA9A97C);
  static const Color beigeClair = Color(0xFFF5F5DC);
}

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: KColors.primary,
    colorScheme: ColorScheme.light(
      primary: KColors.primary,
      secondary: KColors.secondary,
      tertiary: KColors.tertiary,
    ),
    textTheme: TextTheme(
      headlineLarge: KTypography.h1(context),
      headlineMedium: KTypography.h2(context),
      headlineSmall: KTypography.h3(context),
      bodyLarge: KTypography.h4(context),
      bodyMedium: KTypography.h5(context),
    ),
    // Ajoutez d'autres propriétés de thème ici
  );
}

class KTypography {
  static TextStyle h1(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .headlineLarge!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h2(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h3(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .headlineSmall!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h4(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h5(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h6(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.normal, color: color);
  }
}
