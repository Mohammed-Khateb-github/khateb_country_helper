// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

import 'dart:ui' show PlatformDispatcher;

/// {@template country}
/// Represents a country with multilingual name support,
/// dial code, flag emoji, and phone number length constraints.
///
/// The [name] getter automatically resolves to the correct language
/// based on the device locale detected from [PlatformDispatcher].
/// Supported locales: `ar`, `en`, `tr`. Any other locale falls back to English.
///
/// Example:
/// ```dart
/// final country = CountryHelper.getByCode('SA');
/// print(country?.name);            // Auto-detected (e.g. السعودية on Arabic device)
/// print(country?.nameFor('en'));   // Saudi Arabia
/// print(country?.nameFor('tr'));   // Suudi Arabistan
/// ```
/// {@endtemplate}
class Country {
  /// {@macro country}
  const Country({
    required this.names,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.maxLength,
    this.flagImage = '',
  });

  /// Multilingual names keyed by ISO 639-1 language code.
  ///
  /// Supported keys: `ar`, `en`, `tr`.
  final Map<String, String> names;

  /// Unicode flag emoji (e.g. `🇸🇦`).
  final String flag;

  /// ISO 3166-1 alpha-2 country code (e.g. `SA`).
  final String code;

  /// International dial prefix, including the leading `+` (e.g. `+966`).
  final String dialCode;

  /// Maximum allowed phone number length (including dial code digits).
  final int maxLength;

  /// Optional path to a flag image asset, if bundled by the host app.
  final String flagImage;

  // ─── Supported locales ───────────────────────────────────────────────────────

  static const Set<String> _supported = {'ar', 'en', 'tr'};

  // ─── Name resolution ────────────────────────────────────────────────────────

  /// Returns the country name localised to the current device/app locale.
  ///
  /// The locale is read from [PlatformDispatcher.instance.locale].
  /// Supported languages: `ar`, `en`, `tr`. Any other language falls back
  /// to English, and if no English name is found, returns [code].
  ///
  /// ```dart
  /// // On an Arabic device:
  /// CountryHelper.getByCode('SA')?.name; // السعودية
  ///
  /// // On a Turkish device:
  /// CountryHelper.getByCode('SA')?.name; // Suudi Arabistan
  ///
  /// // On any other device:
  /// CountryHelper.getByCode('SA')?.name; // Saudi Arabia
  /// ```
  String get name {
    try {
      final lang = PlatformDispatcher.instance.locale.languageCode;
      final locale = _supported.contains(lang) ? lang : 'en';
      return names[locale] ?? names['en'] ?? code;
    } catch (_) {
      return names['en'] ?? code;
    }
  }

  /// Returns the country name for the given [locale].
  ///
  /// Falls back to English, then to [code] if no match is found.
  /// Supported locales: `ar`, `en`, `tr`.
  String nameFor(String locale) =>
      names[locale] ?? names['en'] ?? code;

  /// Returns the flag emoji followed by the auto-localised name.
  ///
  /// Example: `🇸🇦 السعودية` on an Arabic device.
  String get flagWithName => '$flag $name';

  /// Returns the flag emoji followed by the localised name for [locale].
  ///
  /// Example: `🇸🇦 Saudi Arabia` when locale is `en`.
  String flagWithNameFor(String locale) => '$flag ${nameFor(locale)}';

  // ─── Equality & debug ───────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Country(code: $code, dialCode: $dialCode)';
}
