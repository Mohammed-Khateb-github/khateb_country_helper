// Copyright (c) 2025 Mohammed Khateb. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khateb_country_helper/khateb_country_helper.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'khateb_country_helper Demo',
        debugShowCheckedModeBanner: false,
        // Uncomment to test Arabic:
        // locale: const Locale('ar'),
        // supportedLocales: [Locale('ar'), Locale('en'), Locale('tr')],
        theme: ThemeData(
          colorSchemeSeed: Colors.teal,
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const _HomePage(),
      );
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  Country _selected = CountryHelper.getByCode('SA') ??
      const Country(
        code: 'SA',
        flag: '🇸🇦',
        dialCode: '+966',
        maxLength: 13,
        names: {
          'ar': 'السعودية',
          'en': 'Saudi Arabia',
          'tr': 'Suudi Arabistan',
        },
      );

  Future<void> _openPicker() async {
    final picked = await showCountryBottomSheet(
      context,
      _selected,
      primaryColor: Colors.teal,
    );
    if (picked != null) setState(() => _selected = picked);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Country Helper Demo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Selected country card ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    // Circle flag — same API the user requested
                    CountryFlag.fromCountryCode(
                      _selected.code,
                      theme: const ImageTheme(
                        width: 48,
                        height: 48,
                        shape: Circle(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selected.name, // Auto-detected locale!
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_selected.code}  •  ${_selected.dialCode}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Info rows ──
              _InfoRow('name (auto)',
                  CountryHelper.getNameByCode(_selected.code)),
              _InfoRow('name ar',
                  CountryHelper.getNameByCode(_selected.code, locale: 'ar')),
              _InfoRow('name en',
                  CountryHelper.getNameByCode(_selected.code, locale: 'en')),
              _InfoRow('name tr',
                  CountryHelper.getNameByCode(_selected.code, locale: 'tr')),
              _InfoRow('flag',
                  CountryHelper.getFlagByCode(_selected.code)),
              _InfoRow('dial',
                  CountryHelper.getDialCodeByCode(_selected.code)),
              _InfoRow('max len',
                  CountryHelper.getMaxLengthByCode(_selected.code).toString()),

              const Spacer(),

              // ── Flag shape demos ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CountryFlag.fromCountryCode(_selected.code,
                          theme: const ImageTheme(
                              width: 60, height: 40, shape: Rectangle())),
                      const SizedBox(height: 4),
                      const Text('Rectangle',
                          style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      CountryFlag.fromCountryCode(_selected.code,
                          theme: const ImageTheme(
                              width: 40, height: 40, shape: Circle())),
                      const SizedBox(height: 4),
                      const Text('Circle',
                          style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      CountryFlag.fromCountryCode(_selected.code,
                          theme: const ImageTheme(
                              width: 56,
                              height: 40,
                              shape: RoundedRectangle(8))),
                      const SizedBox(height: 4),
                      const Text('Rounded',
                          style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      CountryFlag.fromCountryCode(_selected.code,
                          theme: const EmojiTheme(size: 40)),
                      const SizedBox(height: 4),
                      const Text('Emoji',
                          style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _openPicker,
                icon: const Icon(Icons.flag_outlined),
                label: const Text('Pick a Country',
                    style: TextStyle(fontSize: 16)),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(color: Colors.white38, fontSize: 13)),
            ),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );
}
