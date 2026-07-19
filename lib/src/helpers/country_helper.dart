// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

import '../data/countries_data.dart';
import '../models/country.dart';

/// A collection of static helper methods for querying and resolving
/// country information by code, dial code, or locale.
///
/// All lookups are performed against [kAllCountries] and are
/// case-insensitive where applicable.
///
/// ## Supported locales for [nameFor]
/// - `ar` — Arabic
/// - `en` — English (default fallback)
/// - `tr` — Turkish
///
/// Example:
/// ```dart
/// final country = CountryHelper.getByCode('SA');
/// print(country?.nameFor('ar')); // السعودية
///
/// final flag = CountryHelper.getFlagByCode('US');
/// print(flag); // 🇺🇸
///
/// final dial = CountryHelper.getDialCodeByCode('TR');
/// print(dial); // +90
/// ```
abstract final class CountryHelper {
  // ─── Retrieval ──────────────────────────────────────────────────────────────

  /// Returns all countries, optionally sorted alphabetically by [locale].
  ///
  /// If [locale] is not provided (or not one of `ar`, `en`, `tr`),
  /// the list is returned in its default order (Arab-first).
  ///
  /// ```dart
  /// final countries = CountryHelper.getAllCountries(locale: 'ar');
  /// ```
  static List<Country> getAllCountries({String? locale}) {
    if (locale == null) return List.unmodifiable(kAllCountries);
    final sorted = [...kAllCountries]
      ..sort((a, b) => a.nameFor(locale).compareTo(b.nameFor(locale)));
    return List.unmodifiable(sorted);
  }

  /// Returns the [Country] matching the given ISO 3166-1 alpha-2 [code],
  /// or `null` if not found. The lookup is case-insensitive.
  ///
  /// ```dart
  /// final sy = CountryHelper.getByCode('SY');
  /// ```
  static Country? getByCode(String code) {
    final upper = code.toUpperCase();
    for (final country in kAllCountries) {
      if (country.code == upper) return country;
    }
    return null;
  }

  /// Returns the first [Country] whose [Country.dialCode] matches [dialCode].
  ///
  /// [dialCode] may include or omit the leading `+`.
  ///
  /// ```dart
  /// final jo = CountryHelper.getByDialCode('+962');
  /// ```
  static Country? getByDialCode(String dialCode) {
    final normalized = dialCode.startsWith('+') ? dialCode : '+$dialCode';
    for (final country in kAllCountries) {
      if (country.dialCode == normalized) return country;
    }
    return null;
  }

  // ─── Scalar lookups ────────────────────────────────────────────────────────

  /// Returns the flag emoji for the given ISO 3166-1 alpha-2 [code],
  /// or an empty string if the country is not found.
  ///
  /// ```dart
  /// print(CountryHelper.getFlagByCode('PS')); // 🇵🇸
  /// ```
  static String getFlagByCode(String code) => getByCode(code)?.flag ?? '';

  /// Returns the international dial code for [code] (e.g. `+966`),
  /// or an empty string if the country is not found.
  static String getDialCodeByCode(String code) =>
      getByCode(code)?.dialCode ?? '';

  /// Returns the localised country name for the given [code] and [locale].
  ///
  /// Falls back to English, then to the country code itself.
  /// If [locale] is null or unsupported, English is used.
  ///
  /// ```dart
  /// print(CountryHelper.getNameByCode('TR', locale: 'tr')); // Türkiye
  /// print(CountryHelper.getNameByCode('TR', locale: 'ar')); // تركيا
  /// ```
  static String getNameByCode(String code, {String? locale}) {
    final country = getByCode(code);
    if (country == null) return code;
    return country.nameFor(locale ?? 'en');
  }

  /// Returns the maximum phone-number length for [code], or `0` if
  /// the country is not found.
  static int getMaxLengthByCode(String code) =>
      getByCode(code)?.maxLength ?? 0;

  /// Returns the flag emoji followed by the localised name for [code].
  ///
  /// Example: `🇸🇦 السعودية` when locale is `ar`.
  /// Falls back to an empty string if the country is not found.
  static String getFlagWithNameByCode(String code, {String? locale}) {
    final country = getByCode(code);
    if (country == null) return '';
    return country.flagWithNameFor(locale ?? 'en');
  }
}
