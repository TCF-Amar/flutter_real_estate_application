import 'package:flutter/material.dart';

class SearchResult extends StatelessWidget {
  final String query;
  const SearchResult({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Search Result")));
  }
}
