import 'package:flutter/material.dart';

/// Consistent, harmonious accent/container colors for up to 4 players.
/// Chosen to complement the app's cyan Material 3 theme while providing
/// clear visual distinction and good contrast.
class PlayerColors {
  PlayerColors._();

  /// Subtle background/container colors (light tints).
  static const List<Color> containers = [
    Color(0xFFB2EBF2), // Cyan 100
    Color(0xFFE8EAF6), // Indigo 50
    Color(0xFFDCEDC8), // Light Green 100
    Color(0xFFFFF8E1), // Amber 50
  ];

  /// Stronger accent colors for text, borders and avatars.
  /// All have sufficient contrast on both white and their respective containers.
  static const List<Color> accents = [
    Color(0xFF00838F), // Cyan 800
    Color(0xFF3949AB), // Indigo 600
    Color(0xFF558B2F), // Light Green 800
    Color(0xFFF57F17), // Amber 900
  ];

  static Color container(int index) => containers[index % containers.length];
  static Color accent(int index) => accents[index % accents.length];
}
