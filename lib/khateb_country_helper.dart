// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

/// A Flutter package for country selection with a beautifully designed
/// bottom sheet, multilingual support (Arabic, English, Turkish),
/// SVG flag images from bundled assets, and zero dependency on GetX
/// or any third-party flag library.
///
/// ## Quick start
///
/// ```dart
/// import 'package:khateb_country_helper/khateb_country_helper.dart';
///
/// // Show the country picker with circular SVG flags
/// final Country? picked = await showCountryBottomSheet(
///   context,
///   currentCountry,
///   flagShape: FlagShape.circle,
///   flagSize: 44,
/// );
///
/// // Use helpers
/// final country = CountryHelper.getByCode('SA');
/// print(country?.name);  // Auto-detected locale
///
/// // SVG flag widget
/// FlagImage.circular(code: 'SA', size: 40)
/// FlagImage.rectangular(code: 'SA', width: 60, height: 40)
///
/// // CountryFlag with shapes
/// CountryFlag.fromCountryCode(
///   'SA',
///   theme: ImageTheme(width: 40, height: 40, shape: Circle()),
/// )
/// ```
library;

export 'src/country_flags.dart';
export 'src/data/countries_data.dart' show kAllCountries;
export 'src/flag_image.dart';
export 'src/helpers/country_helper.dart';
export 'src/models/country.dart';
export 'src/widgets/country_flag_emoji.dart';
export 'src/widgets/country_picker_sheet.dart'
    show FlagShape, showCountryBottomSheet;
