import 'package:flutter/material.dart';

class DarkThemeColors {
  // ==================================================
  // PREMIUM WEATHER APP DARK THEME (2026 MODERN UI)
  // ==================================================

  /// Brand Colors
  static const Color customPrimaryColor = Color(0xFF039DF5);
  static const Color customSecondaryColor = Color(0xFF5BC6FF);
  static const Color customTertiaryColor = Color(0xFF8DDCFF);

  static const Color primaryColor = customPrimaryColor;
  static const Color secondaryColor = customSecondaryColor;
  static const Color tertiaryColor = customTertiaryColor;

  // ==================================================
  // BACKGROUND
  // ==================================================

  /// Main scaffold background
  static const Color scaffoldBackgroundColor = Color(0xFF0B1220);

  /// Main surfaces
  static const Color backgroundColor = Color(0xFF0B1220);

  /// Cards / containers
  static const Color cardColor = Color(0xFF121C2E);

  /// Divider / borders
  static const Color dividerColor = Color(0xFF233247);

  /// Surface tint
  static const Color surfaceColor = Color(0xFF162235);

  // ==================================================
  // APP BAR
  // ==================================================

  static const Color appBarColor = Colors.transparent;

  static const Color appBarIconsColor = Colors.white;

  // ==================================================
  // ICONS
  // ==================================================

  static const Color iconColor = Colors.white;

  static const Color iconSecondaryColor = Color(0xFF9FB3C8);

  // ==================================================
  // BUTTONS
  // ==================================================

  static const Color buttonColor = customPrimaryColor;

  static const Color buttonTextColor = Colors.white;

  static const Color buttonDisabledColor = Color(0xFF263241);

  static const Color buttonDisabledTextColor = Color(0xFF7C8A99);

  // ==================================================
  // TEXT
  // ==================================================

  /// Main body text
  static const Color bodyTextColor = Color(0xFFDCE7F3);

  /// Headings
  static const Color headlinesTextColor = Colors.white;

  /// Captions
  static const Color captionTextColor = Color(0xFF8EA1B5);

  /// Hint text
  static const Color hintTextColor = Color(0xFF6E8195);

  /// Accent white
  static const Color whiteTextColor = Colors.white;

  // ==================================================
  // CHIP
  // ==================================================

  static const Color chipBackground = Color(0xFF162B45);

  static const Color chipTextColor = Color(0xFF8DDCFF);

  // ==================================================
  // WEATHER STATUS COLORS
  // ==================================================

  static const Color sunnyColor = Color(0xFFFFC65C);

  static const Color rainColor = Color(0xFF4DA6FF);

  static const Color cloudyColor = Color(0xFF9AA8B5);

  static const Color stormColor = Color(0xFF7D8CFF);

  static const Color nightColor = Color(0xFF1B2A46);

  // ==================================================
  // PROGRESS / LOADER
  // ==================================================

  static const Color progressIndicatorColor = customSecondaryColor;

  // ==================================================
  // SHADOWS
  // ==================================================

  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(55),
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> softGlow = [
    BoxShadow(
      color: customPrimaryColor.withAlpha(45),
      blurRadius: 18,
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

  static const LinearGradient darkSkyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0B1220),
      Color(0xFF162235),
      Color(0xFF1E2D45),
    ],
  );

  static const LinearGradient weatherCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10243D),
      Color(0xFF15375A),
      Color(0xFF1A4D7A),
    ],
  );
}
