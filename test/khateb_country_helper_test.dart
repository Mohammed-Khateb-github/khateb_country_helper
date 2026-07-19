// Copyright (c) 2025 Mohammed Khateb. All rights reserved.
// Use of this source code is governed by an MIT-style license.

import 'package:flutter_test/flutter_test.dart';
import 'package:khateb_country_helper/khateb_country_helper.dart';

void main() {
  // ─── Country model ──────────────────────────────────────────────────────────
  group('Country model', () {
    const sa = Country(
      code: 'SA',
      flag: '🇸🇦',
      dialCode: '+966',
      maxLength: 13,
      names: {'ar': 'السعودية', 'en': 'Saudi Arabia', 'tr': 'Suudi Arabistan'},
    );

    const sy = Country(
      code: 'SY',
      flag: '🇸🇾',
      dialCode: '+963',
      maxLength: 12,
      names: {'ar': 'سوريا', 'en': 'Syria', 'tr': 'Suriye'},
    );

    test('nameFor returns Arabic name', () {
      expect(sa.nameFor('ar'), 'السعودية');
    });

    test('nameFor returns English name', () {
      expect(sa.nameFor('en'), 'Saudi Arabia');
    });

    test('nameFor returns Turkish name', () {
      expect(sa.nameFor('tr'), 'Suudi Arabistan');
    });

    test('nameFor falls back to English for unsupported locale', () {
      expect(sa.nameFor('fr'), 'Saudi Arabia');
    });

    test('nameFor falls back to code when no English name', () {
      const country = Country(
        code: 'XX',
        flag: '🏳',
        dialCode: '+0',
        maxLength: 10,
        names: {'ar': 'تجريبي'},
      );
      expect(country.nameFor('en'), 'XX');
    });

    test('flagWithNameFor returns flag + name', () {
      expect(sa.flagWithNameFor('en'), '🇸🇦 Saudi Arabia');
      expect(sa.flagWithNameFor('ar'), '🇸🇦 السعودية');
    });

    test('equality is by code', () {
      const sa2 = Country(
        code: 'SA',
        flag: '🇸🇦',
        dialCode: '+966',
        maxLength: 13,
        names: {'en': 'Saudi Arabia'},
      );
      expect(sa, equals(sa2));
    });

    test('different codes are not equal', () {
      expect(sa, isNot(equals(sy)));
    });

    test('hashCode matches for equal objects', () {
      const sa2 = Country(
        code: 'SA',
        flag: '🇸🇦',
        dialCode: '+966',
        maxLength: 13,
        names: {'en': 'Saudi Arabia'},
      );
      expect(sa.hashCode, equals(sa2.hashCode));
    });

    test('toString contains code and dialCode', () {
      expect(sa.toString(), contains('SA'));
      expect(sa.toString(), contains('+966'));
    });
  });

  // ─── CountryFlagEmoji ───────────────────────────────────────────────────────
  group('CountryFlagEmoji.emojiFromCode', () {
    test('returns emoji for valid uppercase code', () {
      expect(CountryFlagEmoji.emojiFromCode('SA'), isNotNull);
      expect(CountryFlagEmoji.emojiFromCode('US'), isNotNull);
      expect(CountryFlagEmoji.emojiFromCode('TR'), isNotNull);
    });

    test('is case-insensitive', () {
      expect(
        CountryFlagEmoji.emojiFromCode('sa'),
        equals(CountryFlagEmoji.emojiFromCode('SA')),
      );
    });

    test('returns null for empty string', () {
      expect(CountryFlagEmoji.emojiFromCode(''), isNull);
    });

    test('returns null for single character', () {
      expect(CountryFlagEmoji.emojiFromCode('A'), isNull);
    });

    test('returns a 2-character emoji string for valid codes', () {
      final emoji = CountryFlagEmoji.emojiFromCode('PS');
      expect(emoji, isNotNull);
      // Regional Indicator emojis are 8 bytes (2 × 4-byte code points)
      expect(emoji!.runes.length, equals(2));
    });
  });

  // ─── CountryHelper ──────────────────────────────────────────────────────────
  group('CountryHelper.getByCode', () {
    test('finds Saudi Arabia by SA', () {
      final country = CountryHelper.getByCode('SA');
      expect(country, isNotNull);
      expect(country!.dialCode, equals('+966'));
    });

    test('is case-insensitive', () {
      expect(
        CountryHelper.getByCode('sa'),
        equals(CountryHelper.getByCode('SA')),
      );
    });

    test('returns null for unknown code', () {
      expect(CountryHelper.getByCode('XX'), isNull);
    });

    test('finds Palestine', () {
      final ps = CountryHelper.getByCode('PS');
      expect(ps, isNotNull);
      expect(ps!.nameFor('ar'), equals('فلسطين'));
    });

    test('finds Turkey', () {
      final tr = CountryHelper.getByCode('TR');
      expect(tr, isNotNull);
      expect(tr!.dialCode, equals('+90'));
    });
  });

  group('CountryHelper.getByDialCode', () {
    test('finds Jordan by +962', () {
      final jo = CountryHelper.getByDialCode('+962');
      expect(jo, isNotNull);
      expect(jo!.code, equals('JO'));
    });

    test('adds + prefix automatically', () {
      expect(
        CountryHelper.getByDialCode('966'),
        equals(CountryHelper.getByDialCode('+966')),
      );
    });

    test('returns null for unknown dial code', () {
      expect(CountryHelper.getByDialCode('+0'), isNull);
    });
  });

  group('CountryHelper.getAllCountries', () {
    test('returns non-empty list', () {
      expect(CountryHelper.getAllCountries(), isNotEmpty);
    });

    test('returns at least 200 countries', () {
      expect(CountryHelper.getAllCountries().length, greaterThanOrEqualTo(200));
    });

    test('list is immutable', () {
      final list = CountryHelper.getAllCountries();
      expect(() => (list as dynamic).add(null), throwsA(isA<Error>()));
    });

    test('sorted by Arabic name when locale is ar', () {
      final sorted = CountryHelper.getAllCountries(locale: 'ar');
      for (var i = 0; i < sorted.length - 1; i++) {
        final a = sorted[i].nameFor('ar');
        final b = sorted[i + 1].nameFor('ar');
        expect(a.compareTo(b), lessThanOrEqualTo(0));
      }
    });

    test('sorted by English name when locale is en', () {
      final sorted = CountryHelper.getAllCountries(locale: 'en');
      for (var i = 0; i < sorted.length - 1; i++) {
        final a = sorted[i].nameFor('en');
        final b = sorted[i + 1].nameFor('en');
        expect(a.compareTo(b), lessThanOrEqualTo(0));
      }
    });

    test('no duplicate codes', () {
      final codes =
          CountryHelper.getAllCountries().map((c) => c.code).toList();
      final unique = codes.toSet();
      expect(codes.length, equals(unique.length));
    });
  });

  group('CountryHelper scalar lookups', () {
    test('getFlagByCode returns emoji for SA', () {
      final flag = CountryHelper.getFlagByCode('SA');
      expect(flag, isNotEmpty);
    });

    test('getFlagByCode returns empty string for unknown code', () {
      expect(CountryHelper.getFlagByCode('XX'), isEmpty);
    });

    test('getDialCodeByCode returns +966 for SA', () {
      expect(CountryHelper.getDialCodeByCode('SA'), equals('+966'));
    });

    test('getDialCodeByCode returns empty string for unknown code', () {
      expect(CountryHelper.getDialCodeByCode('XX'), isEmpty);
    });

    test('getNameByCode returns English name by default', () {
      expect(CountryHelper.getNameByCode('SA'), equals('Saudi Arabia'));
    });

    test('getNameByCode returns Arabic name for locale ar', () {
      expect(
        CountryHelper.getNameByCode('SA', locale: 'ar'),
        equals('السعودية'),
      );
    });

    test('getNameByCode returns code for unknown country', () {
      expect(CountryHelper.getNameByCode('XX'), equals('XX'));
    });

    test('getMaxLengthByCode returns > 0 for valid country', () {
      expect(CountryHelper.getMaxLengthByCode('SA'), greaterThan(0));
    });

    test('getMaxLengthByCode returns 0 for unknown code', () {
      expect(CountryHelper.getMaxLengthByCode('XX'), equals(0));
    });

    test('getFlagWithNameByCode returns flag + name', () {
      final result =
          CountryHelper.getFlagWithNameByCode('SA', locale: 'en');
      expect(result, contains('Saudi Arabia'));
    });

    test('getFlagWithNameByCode returns empty for unknown code', () {
      expect(CountryHelper.getFlagWithNameByCode('XX'), isEmpty);
    });
  });

  // ─── kAllCountries data integrity ───────────────────────────────────────────
  group('kAllCountries data integrity', () {
    test('all countries have non-empty code', () {
      for (final c in kAllCountries) {
        expect(c.code, isNotEmpty, reason: 'Empty code found');
      }
    });

    test('all codes are exactly 2 uppercase letters', () {
      final pattern = RegExp(r'^[A-Z]{2}$');
      for (final c in kAllCountries) {
        expect(
          pattern.hasMatch(c.code),
          isTrue,
          reason: 'Invalid code: ${c.code}',
        );
      }
    });

    test('all countries have a dial code starting with +', () {
      for (final c in kAllCountries) {
        expect(
          c.dialCode.startsWith('+'),
          isTrue,
          reason: '${c.code} has invalid dialCode: ${c.dialCode}',
        );
      }
    });

    test('all countries have maxLength > 0', () {
      for (final c in kAllCountries) {
        expect(
          c.maxLength,
          greaterThan(0),
          reason: '${c.code} has maxLength <= 0',
        );
      }
    });

    test('all countries have English name', () {
      for (final c in kAllCountries) {
        expect(
          c.names.containsKey('en'),
          isTrue,
          reason: '${c.code} missing English name',
        );
      }
    });

    test('no duplicate country codes', () {
      final codes = kAllCountries.map((c) => c.code).toList();
      final unique = codes.toSet();
      expect(
        codes.length,
        equals(unique.length),
        reason: 'Duplicate codes detected',
      );
    });
  });
}
