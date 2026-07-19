// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

/// A widget that renders a country flag from the bundled SVG assets.
///
/// Flag images are loaded from `res/si/<code>.si` files included in this
/// package. The [code] must be a valid ISO 3166-1 alpha-2 country code
/// (case-insensitive, e.g. `SA`, `ae`, `TR`).
///
/// Use [FlagImage.circular] for a circle-clipped flag, or
/// [FlagImage.rectangular] for a plain rectangle.
///
/// Example:
/// ```dart
/// // 40×40 circle flag
/// FlagImage.circular(code: 'SA', size: 40)
///
/// // 60×40 rectangular flag
/// FlagImage.rectangular(code: 'SA', width: 60, height: 40)
///
/// // 48×48 rounded-rectangle flag
/// FlagImage.rounded(code: 'AE', size: 48, borderRadius: 8)
/// ```
abstract class FlagImage extends StatelessWidget {
  const FlagImage._({super.key});

  /// Renders the flag clipped to a perfect circle with diameter [size].
  factory FlagImage.circular({
    required String code,
    required double size,
    Key? key,
  }) =>
      _CircularFlagImage(code: code.toLowerCase(), size: size, key: key);

  /// Renders the flag as a [width]×[height] rectangle.
  factory FlagImage.rectangular({
    required String code,
    required double width,
    required double height,
    Key? key,
  }) =>
      _RectangularFlagImage(
          code: code.toLowerCase(), width: width, height: height, key: key);

  /// Renders the flag clipped to a rounded rectangle.
  factory FlagImage.rounded({
    required String code,
    required double size,
    double borderRadius = 8,
    Key? key,
  }) =>
      _RoundedFlagImage(
          code: code.toLowerCase(),
          size: size,
          borderRadius: borderRadius,
          key: key);

  static Widget _svgWidget(String code) => ScalableImageWidget.fromSISource(
        si: ScalableImageSource.fromSI(
          rootBundle,
          'packages/khateb_country_helper/res/si/$code.si',
        ),
        fit: BoxFit.cover,
        onError: (_) => const _FlagNotFound(),
      );
}

// ─── Circular ──────────────────────────────────────────────────────────────

class _CircularFlagImage extends FlagImage {
  const _CircularFlagImage({
    required this.code,
    required this.size,
    super.key,
  }) : super._();

  final String code;
  final double size;

  @override
  Widget build(BuildContext context) => ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: FlagImage._svgWidget(code),
        ),
      );
}

// ─── Rectangular ────────────────────────────────────────────────────────────

class _RectangularFlagImage extends FlagImage {
  const _RectangularFlagImage({
    required this.code,
    required this.width,
    required this.height,
    super.key,
  }) : super._();

  final String code;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: FlagImage._svgWidget(code),
      );
}

// ─── Rounded rectangle ───────────────────────────────────────────────────────

class _RoundedFlagImage extends FlagImage {
  const _RoundedFlagImage({
    required this.code,
    required this.size,
    required this.borderRadius,
    super.key,
  }) : super._();

  final String code;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: size,
          height: size,
          child: FlagImage._svgWidget(code),
        ),
      );
}

// ─── Fallback ────────────────────────────────────────────────────────────────

class _FlagNotFound extends StatelessWidget {
  const _FlagNotFound();

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.flag_outlined, size: 16, color: Colors.grey),
        ),
      );
}
