import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/agent_card.dart';

class AgentsView extends StatelessWidget {
  const AgentsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final agents = List.generate(
      5,
      (index) => {
        "name": "Eddie Hudson",
        "company": "Dream Homes Realty",
        "image": "https://randomuser.me/api/portraits/men/${index + 10}.jpg",
        "rating": 4.7,
        "experience": "${index + 4}",
        "properties": "${15 + index}",
      },
    );

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: agents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final agent = agents[index];
        return ExploreAgentCard(
          name: agent["name"] as String,
          company: agent["company"] as String,
          image: agent["image"] as String,
          rating: agent["rating"] as double,
          experience: agent["experience"] as String,
          properties: agent["properties"] as String,
          onTap: () {},
        );
      },
    );
  }
}
