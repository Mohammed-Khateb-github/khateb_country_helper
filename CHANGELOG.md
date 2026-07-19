## 1.0.4

### 🎉 Initial release & Feature updates

#### Country Picker Bottom Sheet
* Unified `KhatebCountryPicker` class for both single-pick and multi-pick.
* `KhatebCountryPicker.show()` / `pickSingle()` for single country selection.
* `KhatebCountryPicker.pickMultiple()` for selecting multiple countries with a checkbox and confirmation button.
* Auto-detects app locale from `Localizations.localeOf(context)` — supported: `ar`, `en`, `tr`, fallback to English.
* `flagShape` parameter: `FlagShape.circle` / `FlagShape.rectangle` / `FlagShape.rounded`.
* `flagSize` parameter: control the flag image size in the list.
* `badgeColor` and `badgeSelectedColor` — fully customizable dial-code badge background.
* `showCheckmark` (default `true`) — toggle the trailing checkmark icon for single-selection.
* `titleStyle`, `searchHintStyle`, and `confirmStyle` — nullable `TextStyle` for full typography control.
* Dark / light mode auto-detected from `Theme`, with optional `isDark` override.
* Smooth bouncing scroll, live search by name / code / dial code.

#### Flag Images — `FlagImage`
* `FlagImage.circular(code, size)` — SVG flag clipped to circle.
* `FlagImage.rectangular(code, width, height)` — plain rectangle SVG flag.
* `FlagImage.rounded(code, size, {borderRadius})` — rounded-rectangle SVG flag.
* 250+ bundled `.si` (pre-compiled SVG) assets in `res/si/`, rendered via `jovial_svg`.
* Graceful fallback widget when a flag asset is not found.

#### `CountryFlag` Widget
* `CountryFlag.fromCountryCode(code, {theme})` — ISO alpha-2 code.
* `CountryFlag.fromLanguageCode(code, {theme})` — BCP 47 language code (e.g. `ar`, `en-US`).
* `CountryFlag.fromCurrencyCode(code, {theme})` — ISO 4217 currency code (e.g. `SAR`, `USD`).
* `CountryFlag.fromPhonePrefix(prefix, {theme})` — phone prefix (e.g. `+966`, `44`).
* `ImageTheme(width, height, shape)` — SVG rendering with `Circle()`, `Rectangle()`, or `RoundedRectangle(radius)`.
* `EmojiTheme(size)` — pure Unicode emoji, no assets needed.

#### `CountryFlagEmoji` Widget
* Pure Unicode Regional Indicator rendering — no assets, no external packages.
* Static `CountryFlagEmoji.emojiFromCode(code)` for raw emoji string.

#### `Country` Model
* `country.name` — **automatically** reads device locale via `PlatformDispatcher`, no `BuildContext` or `Get` needed.
* `country.nameFor(locale)` — explicit locale override (`ar` / `en` / `tr`).
* `country.flagWithName` — emoji + auto-localised name.
* `country.flagWithNameFor(locale)` — emoji + named locale.
* `==` / `hashCode` by ISO alpha-2 code.
* 200+ countries with Arabic, English, and Turkish names, dial codes, flag emoji, max phone length.

#### `CountryHelper` Static Utilities
* `getByCode(code)` — lookup by ISO 3166-1 alpha-2 code (case-insensitive).
* `getByDialCode(dialCode)` — lookup by dial code with or without `+`.
* `getAllCountries({locale})` — all countries, optionally sorted alphabetically.
* `getFlagByCode(code)` — emoji flag string.
* `getDialCodeByCode(code)` — dial code string.
* `getNameByCode(code, {locale})` — localised name string.
* `getMaxLengthByCode(code)` — max phone number length.
* `getFlagWithNameByCode(code, {locale})` — emoji + name combined.

#### General
* Dart 3 / Flutter 3.10+ compatible. 
* Bundled SVG assets via `jovial_svg ^1.1.20`.
