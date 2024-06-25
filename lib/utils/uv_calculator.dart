class UVCalculator {
  static String getUVCalculator(num value) {
    if (value < 3) {
      return 'Weak';
    } else if (value < 6) {
      return 'Moderate';
    } else if (value < 8) {
      return 'High';
    } else if (value < 11) {
      return 'Very High';
    } else {
      return 'Extreme';
    }
  }
}
