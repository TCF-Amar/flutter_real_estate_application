import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final int id;
  const PropertyDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [AppText(id.toString())])),
    );
  }
}
