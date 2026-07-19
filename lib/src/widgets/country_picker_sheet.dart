// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

import 'package:flutter/material.dart';

import '../data/countries_data.dart';
import '../flag_image.dart';
import '../models/country.dart';

// ─── Flag shape enum ──────────────────────────────────────────────────────────

/// Controls the clip shape of the flag image inside the country picker sheet.
enum FlagShape {
  /// Clips the flag to a perfect circle.
  circle,

  /// Renders the flag as a rectangle (no clipping).
  rectangle,

  /// Clips the flag to a rounded rectangle.
  rounded,
}

// ─── Public API ──────────────────────────────────────────────────────────────

/// Displays a modal bottom sheet for picking a country.
///
/// Returns the selected [Country], or `null` if dismissed.
///
/// The locale is **automatically detected** from [Localizations.localeOf].
/// Supported: `ar`, `en`, `tr`. Any other locale falls back to English.
///
/// ### Parameters
///
/// | Parameter | Type | Default | Description |
/// |-----------|------|---------|-------------|
/// | [context] | `BuildContext` | required | Context for the sheet. |
/// | [currentCountry] | `Country` | required | Pre-selected country. |
/// | [primaryColor] | `Color?` | theme | Accent color for selection. |
/// | [isDark] | `bool?` | auto | Force dark/light mode. |
/// | [title] | `String?` | auto | Sheet header text. |
/// | [titleStyle] | `TextStyle?` | null | Custom title style. |
/// | [searchHint] | `String?` | auto | Search placeholder text. |
/// | [searchHintStyle] | `TextStyle?` | null | Custom hint text style. |
/// | [flagShape] | `FlagShape` | `circle` | Shape of the flag image. |
/// | [flagSize] | `double` | `40` | Width/height of the flag image. |
///
/// ### Example
///
/// ```dart
/// final picked = await showCountryBottomSheet(
///   context,
///   currentCountry,
///   primaryColor: Colors.teal,
///   flagShape: FlagShape.circle,
///   flagSize: 44,
/// );
/// ```
Future<Country?> showCountryBottomSheet(
  BuildContext context,
  Country currentCountry, {
  Color? primaryColor,
  bool? isDark,
  String? title,
  TextStyle? titleStyle,
  String? searchHint,
  TextStyle? searchHintStyle,
  FlagShape flagShape = FlagShape.circle,
  double flagSize = 40,
}) async {
  final rawLocale = Localizations.localeOf(context).languageCode;
  const supported = {'ar', 'en', 'tr'};
  final locale = supported.contains(rawLocale) ? rawLocale : 'en';

  return showModalBottomSheet<Country>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    builder: (_) => _CountryPickerSheet(
      currentCountry: currentCountry,
      locale: locale,
      primaryColor: primaryColor,
      isDarkOverride: isDark,
      title: title,
      titleStyle: titleStyle,
      searchHint: searchHint,
      searchHintStyle: searchHintStyle,
      flagShape: flagShape,
      flagSize: flagSize,
    ),
  );
}

// ─── Sheet widget ────────────────────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({
    required this.currentCountry,
    required this.locale,
    required this.flagShape,
    required this.flagSize,
    this.primaryColor,
    this.isDarkOverride,
    this.title,
    this.titleStyle,
    this.searchHint,
    this.searchHintStyle,
  });

  final Country currentCountry;
  final String locale;
  final Color? primaryColor;
  final bool? isDarkOverride;
  final String? title;
  final TextStyle? titleStyle;
  final String? searchHint;
  final TextStyle? searchHintStyle;
  final FlagShape flagShape;
  final double flagSize;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';

  bool get _isDark {
    if (widget.isDarkOverride != null) return widget.isDarkOverride!;
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get _accent =>
      widget.primaryColor ?? Theme.of(context).colorScheme.primary;

  List<Country> get _filtered {
    if (_query.trim().isEmpty) return kAllCountries;
    final q = _query.trim().toLowerCase();
    return kAllCountries
        .where(
          (c) =>
              c.nameFor(widget.locale).toLowerCase().contains(q) ||
              c.code.toLowerCase().contains(q) ||
              c.dialCode.replaceAll('+', '').contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final surfaceColor =
        isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final subtleColor =
        isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70);
    final handleColor =
        isDark ? const Color(0xFF48484A) : const Color(0xFFD1D1D6);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Handle bar ──
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ──
          Text(
            widget.title ?? _defaultTitle(widget.locale),
            style: widget.titleStyle ??
                TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
          ),
          const SizedBox(height: 16),

          // ── Search field ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SearchField(
              surfaceColor: surfaceColor,
              textColor: textColor,
              subtleColor: subtleColor,
              hint: widget.searchHint ?? _defaultSearchHint(widget.locale),
              hintStyle: widget.searchHintStyle,
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),

          // ── Country list ──
          Expanded(
            child: _CountryList(
              countries: _filtered,
              currentCode: widget.currentCountry.code,
              locale: widget.locale,
              accent: _accent,
              textColor: textColor,
              subtleColor: subtleColor,
              surfaceColor: surfaceColor,
              flagShape: widget.flagShape,
              flagSize: widget.flagSize,
              emptyLabel: _emptyLabel(widget.locale),
            ),
          ),
        ],
      ),
    );
  }

  static String _defaultTitle(String locale) => switch (locale) {
        'ar' => 'اختر الدولة',
        'tr' => 'Ülke Seçin',
        _ => 'Select Country',
      };

  static String _defaultSearchHint(String locale) => switch (locale) {
        'ar' => 'ابحث عن دولة...',
        'tr' => 'Ülke ara...',
        _ => 'Search country...',
      };

  static String _emptyLabel(String locale) => switch (locale) {
        'ar' => 'لا توجد نتائج',
        'tr' => 'Sonuç bulunamadı',
        _ => 'No results found',
      };
}

// ─── Search field ────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.surfaceColor,
    required this.textColor,
    required this.subtleColor,
    required this.hint,
    required this.onChanged,
    this.hintStyle,
  });

  final Color surfaceColor;
  final Color textColor;
  final Color subtleColor;
  final String hint;
  final TextStyle? hintStyle;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        onChanged: onChanged,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: hintStyle ?? TextStyle(color: subtleColor, fontSize: 16),
          prefixIcon:
              Icon(Icons.search_rounded, color: subtleColor, size: 22),
          filled: true,
          fillColor: surfaceColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

// ─── Country list ────────────────────────────────────────────────────────────

class _CountryList extends StatelessWidget {
  const _CountryList({
    required this.countries,
    required this.currentCode,
    required this.locale,
    required this.accent,
    required this.textColor,
    required this.subtleColor,
    required this.surfaceColor,
    required this.flagShape,
    required this.flagSize,
    required this.emptyLabel,
  });

  final List<Country> countries;
  final String currentCode;
  final String locale;
  final Color accent;
  final Color textColor;
  final Color subtleColor;
  final Color surfaceColor;
  final FlagShape flagShape;
  final double flagSize;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) {
      return Center(
        child: Text(emptyLabel, style: TextStyle(color: subtleColor)),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
      itemCount: countries.length,
      itemBuilder: (ctx, i) => _CountryTile(
        country: countries[i],
        isSelected: countries[i].code == currentCode,
        locale: locale,
        accent: accent,
        textColor: textColor,
        subtleColor: subtleColor,
        surfaceColor: surfaceColor,
        flagShape: flagShape,
        flagSize: flagSize,
        onTap: () => Navigator.of(ctx).pop(countries[i]),
      ),
    );
  }
}

// ─── Single country tile ─────────────────────────────────────────────────────

class _CountryTile extends StatelessWidget {
  const _CountryTile({
    required this.country,
    required this.isSelected,
    required this.locale,
    required this.accent,
    required this.textColor,
    required this.subtleColor,
    required this.surfaceColor,
    required this.flagShape,
    required this.flagSize,
    required this.onTap,
  });

  final Country country;
  final bool isSelected;
  final String locale;
  final Color accent;
  final Color textColor;
  final Color subtleColor;
  final Color surfaceColor;
  final FlagShape flagShape;
  final double flagSize;
  final VoidCallback onTap;

  /// Builds the SVG flag based on [flagShape] and [flagSize].
  Widget _buildFlag() => switch (flagShape) {
        FlagShape.circle => FlagImage.circular(
            code: country.code,
            size: flagSize,
          ),
        FlagShape.rectangle => FlagImage.rectangular(
            code: country.code,
            width: flagSize * 1.5,
            height: flagSize,
          ),
        FlagShape.rounded => FlagImage.rounded(
            code: country.code,
            size: flagSize,
            borderRadius: 6,
          ),
      };

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Material(
          color: isSelected
              ? accent.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            splashColor: accent.withValues(alpha: 0.08),
            highlightColor: accent.withValues(alpha: 0.04),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // SVG flag image
                  _buildFlag(),
                  const SizedBox(width: 14),

                  // Country name
                  Expanded(
                    child: Text(
                      country.nameFor(locale),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Dial code badge
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        country.dialCode,
                        style: TextStyle(
                          color: subtleColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // Checkmark for selected
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.check_circle_rounded, color: accent, size: 20),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
