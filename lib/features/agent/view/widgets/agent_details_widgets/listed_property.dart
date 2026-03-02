import 'package:flutter/material.dart';

class ListedProperty extends StatelessWidget {
  const ListedProperty({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 150,
        color: Colors.blueGrey,
        child: const Center(child: Text("Listed Property")),
      ),
    );
  }
}