import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SearchResult extends StatelessWidget {
  final String query;
  const SearchResult({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: AppText("Search Result")));
  }
}
