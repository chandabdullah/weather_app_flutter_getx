import 'dart:math' as math;
import 'package:flutter/material.dart';

extension ColorOpacityX on Color {
  Color withSafeOpacity(double opacity) {
    final value = (opacity.clamp(0.0, 1.0) * 255).round();
    return withAlpha(value);
  }
}
