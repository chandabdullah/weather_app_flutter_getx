import 'package:flutter/material.dart';
import 'package:weather_app/config/theme/light_theme_colors.dart';

class MyGradient {
  static Gradient defaultGradient() {
    return LinearGradient(
      colors: [
        LightThemeColors.primaryColor,
        LightThemeColors.primaryColor,
        LightThemeColors.primaryColor,
        LightThemeColors.secondaryColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
