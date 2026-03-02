import 'package:flutter/material.dart';

class AgentAbout extends StatelessWidget {
  const AgentAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vel sapien eget nunc efficitur varius. Sed at felis ac nisl efficitur tincidunt.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
