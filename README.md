# khateb_country_helper

[![pub.dev](https://img.shields.io/pub/v/khateb_country_helper.svg)](https://pub.dev/packages/khateb_country_helper)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-02569B)](https://flutter.dev)

A Flutter package for **country selection** with a beautifully designed bottom sheet, **multilingual support (Arabic · English · Turkish)**, SVG flag images from bundled assets, and a full suite of country helper utilities — **zero dependency on GetX or any third-party flag library**.

---

## 📸 Screenshots

| Light Green (Single) | Light Yellow (Single) | Dark Yellow (Single) |
|:-:|:-:|:-:|
| ![Light Green](https://raw.githubusercontent.com/Mohammed-Khateb-github/khateb_country_helper/main/screenshots/light_green.jpg) | ![Light Yellow](https://raw.githubusercontent.com/Mohammed-Khateb-github/khateb_country_helper/main/screenshots/light_yellow.jpg) | ![Dark Yellow](https://raw.githubusercontent.com/Mohammed-Khateb-github/khateb_country_helper/main/screenshots/dark_yellow.jpg) |

| Multiple Selection (Light) |
|:-:|
| ![Multiple Light](https://raw.githubusercontent.com/Mohammed-Khateb-github/khateb_country_helper/main/screenshots/multiple_light.jpg) |

---

## Features

- 🏴 **SVG flag images** — bundled `res/si/` assets, 250+ countries, rendered via `jovial_svg`
- 📋 **Country picker bottom sheet** — single & multi-select modes, shape-configurable flags (circle, rectangle, rounded), live search, dark/light auto-theming
- 🌐 **Auto-locale detection** — `country.name` reads the device locale automatically (`ar` / `en` / `tr`, fallback English)
- 🔍 **Country helpers** — look up by code, dial code, or name; scalar getters for flag, dial, max-length
- 🌍 **200+ countries** with AR / EN / TR names, ISO 3166-1 alpha-2 codes, dial codes, max phone length
- 🚩 **Unicode emoji fallback** — `CountryFlagEmoji` widget if you prefer emoji over SVG
- 🎨 **Full styling control** — customizable badge colors, primary color, title style, search hint style, flag shape, flag size


---

## Getting started

```yaml
dependencies:
  khateb_country_helper: ^1.0.0
```

No extra setup required — SVG assets are bundled inside the package.

---

## Usage

### 1. Country picker bottom sheet

Use the unified `KhatebCountryPicker` class to show single or multi-select sheets.

#### Single Pick
```dart
import 'package:khateb_country_helper/khateb_country_helper.dart';

final Country? picked = await KhatebCountryPicker.show(
  context,
  currentCountry,                           // pre-selected Country
  flagShape: FlagShape.circle,              // circle | rectangle | rounded
  flagSize: 44,                             // you decide the size
  primaryColor: Colors.teal,
  badgeColor: Colors.grey.shade200,         // badge bg color when unselected
  badgeSelectedColor: Colors.teal.shade100, // badge bg color when selected
  title: 'اختر الدولة',
  titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  searchHint: 'ابحث...',
  searchHintStyle: const TextStyle(color: Colors.grey),
  isDark: false,                            // null = auto from Theme
);

if (picked != null) {
  print(picked.dialCode);   // +966
  print(picked.name);       // Auto-detected: السعودية / Saudi Arabia / Suudi Arabistan
  print(picked.code);       // SA
}
```

#### Multi-select
```dart
final List<Country>? list = await KhatebCountryPicker.pickMultiple(
  context,
  initiallySelected: [currentCountry],      // List of pre-selected Countries
  primaryColor: Colors.indigo,
);
```

### 2. `country.name` — auto-locale, no context needed

`Country.name` automatically reads the device locale via `PlatformDispatcher`. You never pass the locale manually:

```dart
final country = CountryHelper.getByCode('SA')!;
print(country.name);             // السعودية  (on Arabic device)
print(country.name);             // Saudi Arabia  (on English device)
print(country.name);             // Suudi Arabistan  (on Turkish device)

// Explicit locale override when needed:
print(country.nameFor('ar'));    // السعودية
print(country.nameFor('en'));    // Saudi Arabia
print(country.nameFor('tr'));    // Suudi Arabistan
```

### 3. SVG flag images — `FlagImage`

```dart
// Circle (great for avatars / pickers)
FlagImage.circular(code: 'SA', size: 40)

// Rectangle
FlagImage.rectangular(code: 'SA', width: 60, height: 40)

// Rounded rectangle
FlagImage.rounded(code: 'SA', size: 40, borderRadius: 8)
```

### 4. `CountryFlag` — flexible flag widget

```dart
// SVG image, circle shape
CountryFlag.fromCountryCode(
  'SA',
  theme: const ImageTheme(width: 40, height: 40, shape: Circle()),
)

// SVG image, rectangle
CountryFlag.fromCountryCode(
  'SA',
  theme: const ImageTheme(width: 60, height: 40, shape: Rectangle()),
)

// SVG image, rounded rectangle
CountryFlag.fromCountryCode(
  'SA',
  theme: const ImageTheme(width: 50, height: 40, shape: RoundedRectangle(8)),
)

// Plain emoji (no assets)
CountryFlag.fromCountryCode('SA', theme: const EmojiTheme(size: 32))

// From language code
CountryFlag.fromLanguageCode('ar')

// From currency code
CountryFlag.fromCurrencyCode('SAR')

// From phone prefix
CountryFlag.fromPhonePrefix('+966')
```

### 5. `CountryFlagEmoji` — Unicode emoji flag

```dart
CountryFlagEmoji(code: 'PS')  // 🇵🇸
CountryFlagEmoji(code: 'SA', size: 32)

// Raw emoji string (no widget)
final String? emoji = CountryFlagEmoji.emojiFromCode('JO');  // 🇯🇴
```

### 6. `CountryHelper` — static utilities

```dart
// By ISO 3166-1 alpha-2 code
final Country? sa = CountryHelper.getByCode('SA');

// By dial code (with or without +)
final Country? jo = CountryHelper.getByDialCode('+962');
final Country? us = CountryHelper.getByDialCode('1');

// Scalar lookups
CountryHelper.getFlagByCode('PS');                      // 🇵🇸
CountryHelper.getDialCodeByCode('TR');                  // +90
CountryHelper.getNameByCode('DE', locale: 'ar');        // ألمانيا
CountryHelper.getMaxLengthByCode('SA');                 // 13
CountryHelper.getFlagWithNameByCode('SA', locale: 'en'); // 🇸🇦 Saudi Arabia

// All countries (default Arab-first order)
final List<Country> all = CountryHelper.getAllCountries();

// All countries sorted alphabetically by locale
final List<Country> arabic = CountryHelper.getAllCountries(locale: 'ar');
final List<Country> english = CountryHelper.getAllCountries(locale: 'en');
```

### 7. `Country` model

```dart
final Country sy = CountryHelper.getByCode('SY')!;

sy.code;                    // SY
sy.flag;                    // 🇸🇾
sy.dialCode;                // +963
sy.maxLength;               // 12
sy.name;                    // Auto-detected from device locale
sy.nameFor('ar');           // سوريا
sy.nameFor('en');           // Syria
sy.nameFor('tr');           // Suriye
sy.flagWithName;            // 🇸🇾 سوريا  (auto locale)
sy.flagWithNameFor('en');   // 🇸🇾 Syria
```

---

## API Reference

### `KhatebCountryPicker`

#### `KhatebCountryPicker.show` / `pickSingle`
```dart
static Future<Country?> show(
  BuildContext context,
  Country currentCountry, {
  FlagShape flagShape = FlagShape.circle,
  double flagSize = 40,
  Color? primaryColor,
  Color? badgeColor,
  Color? badgeSelectedColor,
  bool showCheckmark = true,
  bool? isDark,
  String? title,
  TextStyle? titleStyle,
  String? searchHint,
  TextStyle? searchHintStyle,
})
```

#### `KhatebCountryPicker.pickMultiple`
```dart
static Future<List<Country>?> pickMultiple(
  BuildContext context, {
  List<Country> initiallySelected = const [],
  FlagShape flagShape = FlagShape.circle,
  double flagSize = 40,
  Color? primaryColor,
  Color? badgeColor,
  Color? badgeSelectedColor,
  bool showCheckmark = true,
  bool? isDark,
  String? title,
  TextStyle? titleStyle,
  String? searchHint,
  TextStyle? searchHintStyle,
  String? confirmLabel,
  TextStyle? confirmStyle,
})
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Context for the sheet |
| `flagShape` | `FlagShape` | `circle` | `circle` / `rectangle` / `rounded` |
| `flagSize` | `double` | `40` | Flag image width/height in dp |
| `primaryColor` | `Color?` | theme primary | Accent color for selection |
| `badgeColor` | `Color?` | theme surface | Dial code badge bg (unselected) |
| `badgeSelectedColor` | `Color?` | primary alpha | Dial code badge bg (selected) |
| `badgeTextColor` | `Color?` | theme subtle | Dial code badge text (unselected) |
| `badgeSelectedTextColor` | `Color?` | theme primary | Dial code badge text (selected) |
| `showCheckmark` | `bool` | `true` | Show trailing checkmark icon when selected |
| `isDark` | `bool?` | auto | Override dark/light mode |
| `title` | `String?` | auto | Sheet header text |
| `titleStyle` | `TextStyle?` | null | Custom style for title |
| `searchHint` | `String?` | auto | Search placeholder text |
| `searchHintStyle` | `TextStyle?` | null | Custom style for search hint |
| `confirmLabel` | `String?` | auto | (Multi-select) Confirm button text |
| `confirmStyle` | `TextStyle?` | null | (Multi-select) Confirm text style |

### `CountryHelper` methods

| Method | Returns | Description |
|--------|---------|-------------|
| `getByCode(code)` | `Country?` | Lookup by ISO alpha-2 code |
| `getByDialCode(dialCode)` | `Country?` | Lookup by dial code (e.g. `+966`) |
| `getAllCountries({locale})` | `List<Country>` | All countries, optionally sorted |
| `getFlagByCode(code)` | `String` | Emoji flag for code |
| `getDialCodeByCode(code)` | `String` | Dial code string |
| `getNameByCode(code, {locale})` | `String` | Localised name |
| `getMaxLengthByCode(code)` | `int` | Max phone number length |
| `getFlagWithNameByCode(code, {locale})` | `String` | `🇸🇦 Saudi Arabia` |

### `FlagImage` constructors

| Constructor | Description |
|-------------|-------------|
| `FlagImage.circular(code, size)` | Circle-clipped SVG flag |
| `FlagImage.rectangular(code, width, height)` | Rectangle SVG flag |
| `FlagImage.rounded(code, size, {borderRadius})` | Rounded rectangle SVG flag |

### `CountryFlag` factory constructors

| Constructor | Description |
|-------------|-------------|
| `CountryFlag.fromCountryCode(code, {theme})` | From ISO alpha-2 code |
| `CountryFlag.fromLanguageCode(code, {theme})` | From BCP 47 language code |
| `CountryFlag.fromCurrencyCode(code, {theme})` | From ISO 4217 currency |
| `CountryFlag.fromPhonePrefix(prefix, {theme})` | From phone prefix |

### Supported locales

| Code | Language |
|------|----------|
| `ar` | Arabic (العربية) |
| `en` | English (default fallback) |
| `tr` | Turkish (Türkçe) |

Any other locale falls back to **English**.

---

## License

MIT © 2025 Mohammed Khateb
