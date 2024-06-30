import 'package:flutter/material.dart';
import '/app/models/weather_model.dart';
import '/config/theme/light_theme_colors.dart';

class MyGradient {
  static Gradient backgroundGradient(Description? description) {
    switch (description) {
      case Description.BROKEN_CLOUDS:
        return const LinearGradient(
          colors: [
            Color(0xFF4A4A4A), // Dark grey
            Color(0xFF616161), // Medium grey
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Description.CLEAR_SKY:
        return const LinearGradient(
          colors: [
            Color(0xFF0A74DA), // Soft blue
            Color(0xFF81C7F5), // Light blue
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Description.FEW_CLOUDS:
        return const LinearGradient(
          colors: [
            Color(0xFF3A7CA5), // Darker blue-grey
            Color(0xFF679AC6), // Medium blue-grey
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Description.LIGHT_RAIN:
        return const LinearGradient(
          colors: [
            Color(0xFF5D737E), // Soft grey-blue
            Color(0xFF9BAEBF), // Light grey-blue
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Description.MODERATE_RAIN:
        return const LinearGradient(
          colors: [
            Color(0xFF4B6A78), // Darker grey-blue
            Color(0xFF7B919F), // Medium grey-blue
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Description.OVERCAST_CLOUDS:
        return const LinearGradient(
          colors: [
            Color(0xFF2E2E2E), // Very dark grey
            Color(0xFF5C5C5C), // Dark grey
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Description.SCATTERED_CLOUDS:
        return const LinearGradient(
          colors: [
            Color(0xFF556270), // Darker grey
            Color(0xFF778899), // Medium grey
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [
            Color(0xFF054075), // Default gradient color 1
            Color(0xFF08adcb), // Default gradient color 2
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  static Color getAppBarColor(Description? description) {
    switch (description) {
      case Description.BROKEN_CLOUDS:
        return const Color(0xFF4A4A4A); // Dark grey
      case Description.CLEAR_SKY:
        return const Color(0xFF0A74DA); // Soft blue
      case Description.FEW_CLOUDS:
        return const Color(0xFF3A7CA5); // Darker blue-grey
      case Description.LIGHT_RAIN:
        return const Color(0xFF5D737E); // Soft grey-blue
      case Description.MODERATE_RAIN:
        return const Color(0xFF4B6A78); // Darker grey-blue
      case Description.OVERCAST_CLOUDS:
        return const Color(0xFF2E2E2E); // Very dark grey
      case Description.SCATTERED_CLOUDS:
        return const Color(0xFF556270); // Darker grey
      default:
        return const Color(0xFF054075); // Default color
    }
  }
}
