import 'package:flutter/material.dart';

class LightThemeColors {
  // ==================================================
  // PREMIUM WEATHER APP LIGHT THEME (2026 MODERN UI)
  // ==================================================

  /// Brand Colors
  static const Color customPrimaryColor = Color(0xFF039DF5);
  static const Color customSecondaryColor = Color(0xFF5BC6FF);
  static const Color customTertiaryColor = Color(0xFFDDF4FF);

  static const Color primaryColor = customPrimaryColor;
  static const Color secondaryColor = customSecondaryColor;
  static const Color tertiaryColor = customTertiaryColor;

  // ==================================================
  // BACKGROUND
  // ==================================================

  /// Premium soft white background
  static const Color scaffoldBackgroundColor = Color(0xFFF8FBFF);

  /// Main background
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Light cards with subtle premium tint
  static const Color cardColor = Color(0xFFFFFFFF);

  /// Soft borders / dividers
  static const Color dividerColor = Color(0xFFE8F1F8);

  /// Surface tint
  static const Color surfaceColor = Color(0xFFF2F8FD);

  // ==================================================
  // APP BAR
  // ==================================================

  static const Color appBarColor = Colors.transparent;

  static const Color appBarIconsColor = Color(0xFF0B2239);

  // ==================================================
  // ICONS
  // ==================================================

  static const Color iconColor = customPrimaryColor;

  static const Color iconSecondaryColor = Color(0xFF5B6B7A);

  // ==================================================
  // BUTTONS
  // ==================================================

  static const Color buttonColor = customPrimaryColor;

  static const Color buttonTextColor = Colors.white;

  static const Color buttonDisabledColor = Color(0xFFE3E8EE);

  static const Color buttonDisabledTextColor = Color(0xFF98A2AD);

  // ==================================================
  // TEXT
  // ==================================================

  /// Main body text
  static const Color bodyTextColor = Color(0xFF1A2B3C);

  /// Headlines / Titles
  static const Color headlinesTextColor = Color(0xFF0D1B2A);

  /// Captions / Helper text
  static const Color captionTextColor = Color(0xFF7A8A99);

  /// Input hints
  static const Color hintTextColor = Color(0xFFA0ADB8);

  /// White text on gradients
  static const Color whiteTextColor = Colors.white;

  // ==================================================
  // CHIP
  // ==================================================

  static const Color chipBackground = Color(0xFFEAF7FF);

  static const Color chipTextColor = Color(0xFF039DF5);

  // ==================================================
  // WEATHER STATUS COLORS
  // ==================================================

  static const Color sunnyColor = Color(0xFFFFB648);

  static const Color rainColor = Color(0xFF4A90E2);

  static const Color cloudyColor = Color(0xFFB0BEC5);

  static const Color stormColor = Color(0xFF5C6BC0);

  static const Color nightColor = Color(0xFF223A5E);

  // ==================================================
  // PROGRESS / LOADER
  // ==================================================

  static const Color progressIndicatorColor = customSecondaryColor;

  // ==================================================
  // SHADOWS
  // ==================================================

  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(10),
      blurRadius: 18,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: customPrimaryColor.withAlpha(18),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // ==================================================
  // PREMIUM GRADIENTS
  // ==================================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF039DF5),
      Color(0xFF5BC6FF),
    ],
  );

  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEAF7FF),
      Color(0xFFFFFFFF),
    ],
  );

  static const LinearGradient weatherCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF039DF5),
      Color(0xFF6ED0FF),
      Color(0xFFAEE5FF),
    ],
  );
}
