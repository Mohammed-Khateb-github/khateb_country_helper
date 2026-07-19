// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

import 'package:flutter/widgets.dart';

/// A widget that renders a country flag as a Unicode emoji.
///
/// Flags are computed from the two-letter ISO 3166-1 alpha-2 country [code]
/// using Unicode Regional Indicator symbols (U+1F1E6–U+1F1FF). No external
/// library or asset bundle is required.
///
/// The [code] is case-insensitive. If the code is invalid or null,
/// a fallback [Text] with the [fallback] string is rendered.
///
/// Example:
/// ```dart
/// CountryFlagEmoji(code: 'SA', size: 30)  // 🇸🇦
/// CountryFlagEmoji(code: 'ps', size: 24)  // 🇵🇸
/// ```
class CountryFlagEmoji extends StatelessWidget {
  /// Creates a flag emoji widget for the given [code].
  const CountryFlagEmoji({
    required this.code,
    super.key,
    this.size = 28,
    this.fallback = '🏳',
  });

  /// ISO 3166-1 alpha-2 country code (e.g. `SA`, `tr`, `US`).
  final String code;

  /// Font size of the emoji. Defaults to `28`.
  final double size;

  /// Fallback text shown when [code] is invalid or unrecognised.
  final String fallback;

  @override
  Widget build(BuildContext context) {
    final emoji = _buildEmoji(code);
    return Text(
      emoji ?? fallback,
      style: TextStyle(fontSize: size, height: 1),
      textAlign: TextAlign.center,
    );
  }

  // ─── Private ───────────────────────────────────────────────────────────────

  static const int _regionalIndicatorA = 0x1F1E6;
  static const int _asciiUpperA = 0x41;

  /// Converts an ISO alpha-2 [code] to a Unicode flag emoji string.
  ///
  /// Returns `null` when [code] is not exactly two ASCII letters.
  static String? _buildEmoji(String code) {
    if (code.length < 2) return null;
    final upper = code.toUpperCase();
    final a = upper.codeUnitAt(0) - _asciiUpperA;
    final b = upper.codeUnitAt(1) - _asciiUpperA;
    if (a < 0 || a > 25 || b < 0 || b > 25) return null;
    return String.fromCharCode(_regionalIndicatorA + a) +
        String.fromCharCode(_regionalIndicatorA + b);
  }

  /// Returns the emoji string for [code], or null if invalid.
  ///
  /// Useful when you want the raw emoji without rendering a widget.
  static String? emojiFromCode(String code) => _buildEmoji(code);
}
