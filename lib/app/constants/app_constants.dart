import 'package:flutter/material.dart';

Duration apiCallAfter = const Duration(hours: 1);

const double kPadding = 16.0;
const double kSpacing = 12.0;
const double kBorderRadius = 8.0;

double kBottomPadding(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}

double kTopPadding(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double kRightPadding(BuildContext context) {
  return MediaQuery.of(context).padding.right;
}

double kLeftPadding(BuildContext context) {
  return MediaQuery.of(context).padding.left;
}
