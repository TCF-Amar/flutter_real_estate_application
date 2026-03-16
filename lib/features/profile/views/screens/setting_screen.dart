import 'package:flutter/material.dart';
import 'package:real_estate_app/features/profile/views/widgets/setting_widgets/country_setting_tile.dart';
import 'package:real_estate_app/features/profile/views/widgets/setting_widgets/location_access_tile.dart';
import 'package:real_estate_app/features/profile/views/widgets/setting_widgets/language_toggle_tile.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Settings"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const CountrySettingTile(),
              const Divider(),
              const LocationAccessTile(),
              const Divider(),
              const LanguageToggleTile(),
            ],
          ),
        ),
      ),
    );
  }
}
