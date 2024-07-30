import 'dart:ui';

import 'package:flutter/material.dart';
import '/config/theme/my_gradient.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    super.key,
    required this.child,
    required this.color,
    required this.filter,
  });

  final Widget child;
  final Color color;
  final ImageFilter filter;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: filter,
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        child: child,
      ),
    );
  }
}
