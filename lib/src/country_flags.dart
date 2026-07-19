// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

import 'package:flutter/widgets.dart';

import 'flag_image.dart';
import 'widgets/country_flag_emoji.dart';

// ─── Shape definitions ───────────────────────────────────────────────────────

/// Base class for flag shape variants.
sealed class Shape {
  const Shape();
}

/// Renders the flag in a standard rectangle.
class Rectangle extends Shape {
  const Rectangle();
}

/// Renders the flag inside a circle clip.
class Circle extends Shape {
  const Circle();
}

/// Renders the flag inside a rounded-rectangle clip.
class RoundedRectangle extends Shape {
  const RoundedRectangle(this.borderRadius);

  /// Corner radius applied to all four corners.
  final double borderRadius;
}

// ─── Theme definitions ───────────────────────────────────────────────────────

/// Base class for flag rendering themes.
sealed class FlagTheme {
  const FlagTheme();
}

/// Renders the flag from bundled SVG assets in a sized, shaped container.
///
/// Default shape is [Rectangle].
class ImageTheme extends FlagTheme {
  const ImageTheme({
    this.width,
    this.height,
    this.shape = const Rectangle(),
  });

  /// Desired width of the flag widget. Defaults to `60` for [Rectangle] /
  /// [RoundedRectangle] and [height] for [Circle].
  final double? width;

  /// Desired height of the flag widget. Defaults to `40`.
  final double? height;

  /// The clip shape applied to the flag image.
  final Shape shape;

  ImageTheme copyWith({double? width, double? height, Shape? shape}) =>
      ImageTheme(
        width: width ?? this.width,
        height: height ?? this.height,
        shape: shape ?? this.shape,
      );
}

/// Renders the flag as a plain emoji text widget. No assets required.
class EmojiTheme extends FlagTheme {
  const EmojiTheme({this.size});

  /// Font size of the emoji. Defaults to `32`.
  final double? size;

  EmojiTheme copyWith({double? size}) => EmojiTheme(size: size ?? this.size);
}

// ─── CountryFlag widget ───────────────────────────────────────────────────────

/// A widget that displays a country flag.
///
/// When using [ImageTheme] (default), flags are loaded from the bundled SVG
/// assets in `res/si/`. When using [EmojiTheme], flags are rendered as
/// Unicode Regional Indicator emoji — no assets needed.
///
/// Use the named constructors to create a flag from a country code, language
/// code, currency code, or phone prefix.
///
/// ## Example — SVG image with circle shape
///
/// ```dart
/// CountryFlag.fromCountryCode(
///   'SA',
///   theme: const ImageTheme(
///     width: 40,
///     height: 40,
///     shape: Circle(),
///   ),
/// )
/// ```
///
/// ## Example — emoji rendering
///
/// ```dart
/// CountryFlag.fromCountryCode('SA', theme: const EmojiTheme(size: 32))
/// ```
class CountryFlag extends StatelessWidget {
  const CountryFlag._({
    required this.countryCode,
    required this.theme,
    super.key,
  });

  /// Creates a [CountryFlag] from an ISO 3166-1 alpha-2 country code
  /// (e.g. `SA`, `AE`, `us`). Case-insensitive.
  factory CountryFlag.fromCountryCode(
    String countryCode, {
    FlagTheme theme = const ImageTheme(),
    Key? key,
  }) =>
      CountryFlag._(
          countryCode: countryCode.toUpperCase(), theme: theme, key: key);

  /// Creates a [CountryFlag] from a BCP 47 language code (e.g. `ar`, `en-US`).
  factory CountryFlag.fromLanguageCode(
    String languageCode, {
    FlagTheme theme = const ImageTheme(),
    Key? key,
  }) {
    final code = _languageToCountry[languageCode.toLowerCase()] ??
        languageCode.split('-').first.toUpperCase();
    return CountryFlag._(countryCode: code, theme: theme, key: key);
  }

  /// Creates a [CountryFlag] from an ISO 4217 currency code (e.g. `SAR`).
  factory CountryFlag.fromCurrencyCode(
    String currencyCode, {
    FlagTheme theme = const ImageTheme(),
    Key? key,
  }) {
    final code = _currencyToCountry[currencyCode.toUpperCase()] ?? currencyCode;
    return CountryFlag._(countryCode: code, theme: theme, key: key);
  }

  /// Creates a [CountryFlag] from a phone prefix (e.g. `+966`, `44`).
  factory CountryFlag.fromPhonePrefix(
    String prefix, {
    FlagTheme theme = const ImageTheme(),
    Key? key,
  }) {
    final normalized = prefix.startsWith('+') ? prefix : '+$prefix';
    final code = _prefixToCountry[normalized] ?? 'UN';
    return CountryFlag._(countryCode: code, theme: theme, key: key);
  }

  /// The resolved ISO 3166-1 alpha-2 country code (uppercase).
  final String countryCode;

  /// The rendering theme — [ImageTheme] (SVG, default) or [EmojiTheme].
  final FlagTheme theme;

  @override
  Widget build(BuildContext context) => switch (theme) {
        EmojiTheme(:final size) => CountryFlagEmoji(
            code: countryCode,
            size: size ?? 32,
          ),
        ImageTheme(:final width, :final height, :final shape) =>
          _buildImage(shape, width, height),
      };

  Widget _buildImage(Shape shape, double? width, double? height) {
    final isCircle = shape is Circle;
    final w = width ?? (isCircle ? 40.0 : 60.0);
    final h = height ?? 40.0;
    final size = isCircle ? w : null;

    return switch (shape) {
      Circle() => FlagImage.circular(code: countryCode, size: size ?? w),
      RoundedRectangle(:final borderRadius) => FlagImage.rounded(
          code: countryCode,
          size: w,
          borderRadius: borderRadius,
        ),
      Rectangle() => FlagImage.rectangular(
          code: countryCode,
          width: w,
          height: h,
        ),
    };
  }

  // ─── Lookup tables ─────────────────────────────────────────────────────────

  static const Map<String, String> _languageToCountry = {
    'ar': 'SA', 'ar-ae': 'AE', 'ar-bh': 'BH', 'ar-dz': 'DZ',
    'ar-eg': 'EG', 'ar-iq': 'IQ', 'ar-jo': 'JO', 'ar-kw': 'KW',
    'ar-lb': 'LB', 'ar-ly': 'LY', 'ar-ma': 'MA', 'ar-om': 'OM',
    'ar-qa': 'QA', 'ar-sa': 'SA', 'ar-sy': 'SY', 'ar-tn': 'TN',
    'ar-ye': 'YE', 'az': 'AZ', 'be': 'BY', 'bg': 'BG', 'bn': 'BD',
    'ca': 'ES', 'cs': 'CZ', 'da': 'DK', 'de': 'DE', 'de-at': 'AT',
    'de-ch': 'CH', 'el': 'GR', 'en': 'GB', 'en-au': 'AU',
    'en-nz': 'NZ', 'en-us': 'US', 'es': 'ES', 'es-ar': 'AR',
    'es-bo': 'BO', 'es-cl': 'CL', 'es-co': 'CO', 'es-mx': 'MX',
    'et': 'EE', 'fa': 'IR', 'fi': 'FI', 'fr': 'FR', 'he': 'IL',
    'hi': 'IN', 'hr': 'HR', 'hu': 'HU', 'hy': 'AM', 'id': 'ID',
    'it': 'IT', 'ja': 'JP', 'ka': 'GE', 'kk': 'KZ', 'km': 'KH',
    'ko': 'KR', 'ky': 'KG', 'lt': 'LT', 'lv': 'LV', 'mk': 'MK',
    'mn': 'MN', 'ms': 'MY', 'mt': 'MT', 'ne': 'NP', 'nl': 'NL',
    'no': 'NO', 'pl': 'PL', 'pt': 'PT', 'pt-br': 'BR', 'ro': 'RO',
    'ru': 'RU', 'sk': 'SK', 'sl': 'SI', 'sq': 'AL', 'sr': 'RS',
    'sv': 'SE', 'th': 'TH', 'tr': 'TR', 'uk': 'UA', 'ur': 'PK',
    'uz': 'UZ', 'vi': 'VN', 'zh': 'CN', 'zh-cn': 'CN', 'zh-tw': 'TW',
  };

  static const Map<String, String> _currencyToCountry = {
    'AED': 'AE', 'AFN': 'AF', 'ALL': 'AL', 'AMD': 'AM', 'ARS': 'AR',
    'AUD': 'AU', 'AZN': 'AZ', 'BAM': 'BA', 'BDT': 'BD', 'BGN': 'BG',
    'BHD': 'BH', 'BND': 'BN', 'BOB': 'BO', 'BRL': 'BR', 'BWP': 'BW',
    'BYN': 'BY', 'CAD': 'CA', 'CHF': 'CH', 'CLP': 'CL', 'CNY': 'CN',
    'COP': 'CO', 'CZK': 'CZ', 'DKK': 'DK', 'DZD': 'DZ', 'EGP': 'EG',
    'ETB': 'ET', 'GBP': 'GB', 'GEL': 'GE', 'GHS': 'GH', 'GTQ': 'GT',
    'HKD': 'HK', 'HUF': 'HU', 'IDR': 'ID', 'ILS': 'IL', 'INR': 'IN',
    'IQD': 'IQ', 'IRR': 'IR', 'ISK': 'IS', 'JOD': 'JO', 'JPY': 'JP',
    'KES': 'KE', 'KGS': 'KG', 'KRW': 'KR', 'KWD': 'KW', 'KZT': 'KZ',
    'LBP': 'LB', 'LKR': 'LK', 'LYD': 'LY', 'MAD': 'MA', 'MNT': 'MN',
    'MRU': 'MR', 'MXN': 'MX', 'MYR': 'MY', 'MZN': 'MZ', 'NGN': 'NG',
    'NOK': 'NO', 'NPR': 'NP', 'NZD': 'NZ', 'OMR': 'OM', 'PEN': 'PE',
    'PHP': 'PH', 'PKR': 'PK', 'PLN': 'PL', 'QAR': 'QA', 'RON': 'RO',
    'RSD': 'RS', 'RUB': 'RU', 'SAR': 'SA', 'SEK': 'SE', 'SGD': 'SG',
    'SYP': 'SY', 'THB': 'TH', 'TRY': 'TR', 'TWD': 'TW', 'UAH': 'UA',
    'USD': 'US', 'UZS': 'UZ', 'VND': 'VN', 'YER': 'YE', 'ZAR': 'ZA',
  };

  static const Map<String, String> _prefixToCountry = {
    '+1': 'US', '+7': 'RU', '+20': 'EG', '+27': 'ZA', '+30': 'GR',
    '+31': 'NL', '+32': 'BE', '+33': 'FR', '+34': 'ES', '+36': 'HU',
    '+39': 'IT', '+40': 'RO', '+41': 'CH', '+43': 'AT', '+44': 'GB',
    '+45': 'DK', '+46': 'SE', '+47': 'NO', '+48': 'PL', '+49': 'DE',
    '+52': 'MX', '+54': 'AR', '+55': 'BR', '+56': 'CL', '+57': 'CO',
    '+60': 'MY', '+61': 'AU', '+62': 'ID', '+63': 'PH', '+64': 'NZ',
    '+65': 'SG', '+66': 'TH', '+81': 'JP', '+82': 'KR', '+84': 'VN',
    '+86': 'CN', '+90': 'TR', '+91': 'IN', '+92': 'PK', '+93': 'AF',
    '+94': 'LK', '+98': 'IR', '+212': 'MA', '+213': 'DZ', '+216': 'TN',
    '+218': 'LY', '+220': 'GM', '+221': 'SN', '+222': 'MR', '+233': 'GH',
    '+234': 'NG', '+249': 'SD', '+251': 'ET', '+252': 'SO', '+253': 'DJ',
    '+254': 'KE', '+255': 'TZ', '+256': 'UG', '+260': 'ZM', '+263': 'ZW',
    '+351': 'PT', '+352': 'LU', '+353': 'IE', '+354': 'IS', '+355': 'AL',
    '+356': 'MT', '+357': 'CY', '+358': 'FI', '+359': 'BG', '+370': 'LT',
    '+371': 'LV', '+372': 'EE', '+373': 'MD', '+374': 'AM', '+375': 'BY',
    '+376': 'AD', '+377': 'MC', '+380': 'UA', '+381': 'RS', '+382': 'ME',
    '+383': 'XK', '+385': 'HR', '+386': 'SI', '+387': 'BA', '+389': 'MK',
    '+420': 'CZ', '+421': 'SK', '+423': 'LI', '+673': 'BN', '+852': 'HK',
    '+880': 'BD', '+886': 'TW', '+961': 'LB', '+962': 'JO', '+963': 'SY',
    '+964': 'IQ', '+965': 'KW', '+966': 'SA', '+967': 'YE', '+968': 'OM',
    '+970': 'PS', '+971': 'AE', '+972': 'IL', '+973': 'BH', '+974': 'QA',
    '+975': 'BT', '+976': 'MN', '+977': 'NP', '+992': 'TJ', '+993': 'TM',
    '+994': 'AZ', '+995': 'GE', '+996': 'KG', '+998': 'UZ',
  };
}
