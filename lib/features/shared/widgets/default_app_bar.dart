import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class DefaultAppBar extends StatelessWidget {
  final String title;
  const DefaultAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: HeaderText(text: title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }
}
